import Foundation

// MARK: - Documents

public enum DocumentStatus: String, Codable {
    case missing
    case received
}

public struct Document: Codable, Identifiable {
    public var id: String { name }
    public let name: String
    public let status: DocumentStatus
    public let uploadedAt: String?
    public let fileName: String?
    public let filePath: String?
    public let mimeType: String?
    public let size: Int?
}

// MARK: - Applicants

public struct Applicant: Codable, Identifiable {
    public let id: String
    public var name: String
    public var email: String
    public var phone: String
    public var dateOfBirth: String
    public var advisor: String?
    public var advisorEmail: String?
    public var profilePicture: String?
    public let createdAt: String
    public var documents: [Document]
}

// MARK: - Requests

public struct CreateApplicantRequest: Encodable {
    public var name: String
    public var email: String
    public var phone: String
    public var dateOfBirth: String
    public var advisor: String?
    public var advisorEmail: String?
    public var profilePicture: String?
}

public struct UpdateApplicantRequest: Encodable {
    public var name: String?
    public var email: String?
    public var phone: String?
    public var dateOfBirth: String?
    public var advisor: String?
    public var advisorEmail: String?
    public var profilePicture: String?
}

// MARK: - Status Responses

public struct CompletionResponse: Decodable {
    public let complete: Bool
}

public struct ProgressResponse: Decodable {
    public let uploaded: Int
    public let remaining: Int
    public let total: Int
    public let generalUploaded: Int?
    public let generalRemaining: Int?
    public let generalTotal: Int?
    public let personalUploaded: Int?
    public let personalRemaining: Int?
    public let personalTotal: Int?
}

// MARK: - Document Names (helps avoid typos)

public enum DocumentName: String, CaseIterable {
    case passport = "Passport"
    case aliyahVisa = "Aliyah Visa"
    case birthCertificate = "Birth Certificate"
    case proofOfJudaism = "Proof Of Judaism"
    case healthDeclaration = "Health Declaration"
    case apostilleOnBirthCertificate = "Apostille On Birth Certificate"
    case passportPhotos = "Passport Photos"
    case entryAndExitForm = "Entry And Exit Form"
    case criminalBackgroundCheck = "Criminal Background Check"
    case apostilleOnCriminalBackgroundCheck = "Apostille On Criminal Background Check"
    case waiverOfConfidentiality = "Waiver Of Confidentiality"
    case photographOfFamilyMembersMakingAliyah = "Photograph Of Family Member(s) Making Aliyah"
}

// MARK: - Auth

public struct LoginCodeResponse: Decodable {
    public let message: String
    public let code: String
    public let applicantId: String
}

public struct VerifyCodeResponse: Decodable {
    public let token: String
    public let applicant: Applicant
}
