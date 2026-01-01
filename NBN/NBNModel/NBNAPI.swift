import Foundation

/// Lightweight API client (no UnionNetworking) that mirrors the Booster pattern with bearer token support.
struct NBNAPI {
    var baseURL = URL(string: "http://127.0.0.1:3001")!
    private var session: URLSession { .shared }

    // MARK: - Public API

    func listApplicants() async throws -> [Applicant] {
        try await get("/applicants")
    }

    func getApplicant(id: String) async throws -> Applicant {
        try await get("/applicants/\(id)")
    }

    func getApplicantByEmail(_ email: String) async throws -> Applicant {
        let encoded = email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? email
        return try await get("/applicants/by-email/\(encoded)")
    }

    func createApplicant(_ request: CreateApplicantRequest) async throws -> Applicant {
        let body = try JSONEncoder().encode(request)
        return try await send("/applicants", method: "POST", jsonBody: body)
    }

    func updateApplicant(id: String, _ request: UpdateApplicantRequest) async throws -> Applicant {
        let body = try JSONEncoder().encode(request)
        return try await send("/applicants/\(id)", method: "PATCH", jsonBody: body)
    }

    func uploadDocument(applicantId: String, documentName: String, fileURL: URL) async throws -> Document {
        let encodedName = documentName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? documentName
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = try makeRequest(path: "/applicants/\(applicantId)/documents/\(encodedName)/upload")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let httpBody = try multipartBody(fileURL: fileURL, boundary: boundary, fieldName: "file")
        request.httpBody = httpBody

        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        return try JSONDecoder().decode(Document.self, from: data)
    }

    func documentsComplete(applicantId: String) async throws -> CompletionResponse {
        try await get("/applicants/\(applicantId)/documents/complete")
    }

    func documentsProgress(applicantId: String) async throws -> ProgressResponse {
        try await get("/applicants/\(applicantId)/documents/progress")
    }

    // MARK: - Auth (magic code)

    func requestLoginCode(email: String, name: String? = nil, phone: String? = nil, dateOfBirth: String? = nil) async throws -> LoginCodeResponse {
        let payload: [String: String?] = [
            "email": email,
            "name": name,
            "phone": phone,
            "dateOfBirth": dateOfBirth
        ]
        let body = try JSONSerialization.data(withJSONObject: payload.compactMapValues { $0 })
        return try await send("/auth/request-code", method: "POST", jsonBody: body)
    }

    func verifyLoginCode(email: String, code: String) async throws -> VerifyCodeResponse {
        let body = try JSONSerialization.data(withJSONObject: ["email": email, "code": code])
        return try await send("/auth/verify", method: "POST", jsonBody: body)
    }

    // MARK: - Private helpers

    private func get<T: Decodable>(_ path: String) async throws -> T {
        try await send(path, method: "GET")
    }

    private func send<Response: Decodable>(
        _ path: String,
        method: String,
        jsonBody: Data? = nil
    ) async throws -> Response {
        var request = try makeRequest(path: path)
        request.httpMethod = method
        if let jsonBody {
            request.httpBody = jsonBody
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await session.data(for: request)
        try validate(response: response, data: data)
        return try JSONDecoder().decode(Response.self, from: data)
    }

    private func makeRequest(path: String) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30

        if let token = Keychain.bearerToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw APIError(statusCode: http.statusCode, body: body)
        }
    }

    private func multipartBody(fileURL: URL, boundary: String, fieldName: String) throws -> Data {
        let filename = fileURL.lastPathComponent
        let mimeType = mimeTypeForPathExtension(fileURL.pathExtension)
        let fileData = try Data(contentsOf: fileURL)

        var body = Data()
        let prefix = "--\(boundary)\r\n"
        body.append(prefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    private func mimeTypeForPathExtension(_ ext: String) -> String {
        switch ext.lowercased() {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "pdf": return "application/pdf"
        default: return "application/octet-stream"
        }
    }
}

struct APIError: LocalizedError {
    let statusCode: Int
    let body: String

    var errorDescription: String? {
        "HTTP \(statusCode): \(body)"
    }
}
