import Foundation
import Combine

@MainActor
final class AppModel: ObservableObject {
    static let shared = AppModel()

    @Published var applicant: Applicant?
    @Published var progress: ProgressResponse?

    private let api = NBNAPI()
    private let applicantIdKey = "nbn.applicant.id"

    // Derived counts for easy UI binding
    var completedDocuments: Int {
        progress?.uploaded ?? applicant?.documents.filter { $0.status == .received }.count ?? 0
    }

    var totalDocuments: Int {
        progress?.total ?? applicant?.documents.count ?? 0
    }

    var remainingDocuments: Int {
        max(0, totalDocuments - completedDocuments)
    }

    // Applicant shortcuts
    var applicantName: String { applicant?.name ?? "" }
    var applicantEmail: String { applicant?.email ?? "" }
    var applicantPhone: String { applicant?.phone ?? "" }
    var applicantDOB: String { applicant?.dateOfBirth ?? "" }

    // Access individual documents by name
    func document(named name: String) -> Document? {
        applicant?.documents.first { $0.name == name }
    }

    func documentStatus(named name: String) -> DocumentStatus? {
        document(named: name)?.status
    }

    func document(_ doc: DocumentName) -> Document? {
        document(named: doc.rawValue)
    }

    func documentStatus(_ doc: DocumentName) -> DocumentStatus? {
        documentStatus(named: doc.rawValue)
    }

    // Setters / mutators
    func updateApplicant(name: String? = nil, email: String? = nil, phone: String? = nil, dateOfBirth: String? = nil, profilePicture: String? = nil) {
        guard var current = applicant else { return }
        if let name { current.name = name }
        if let email { current.email = email }
        if let phone { current.phone = phone }
        if let dateOfBirth { current.dateOfBirth = dateOfBirth }
        if let profilePicture { current.profilePicture = profilePicture }
        setApplicant(current)
    }

    func setDocumentStatus(name: String, status: DocumentStatus, uploadedAt: String? = nil, fileName: String? = nil, filePath: String? = nil, mimeType: String? = nil, size: Int? = nil) {
        guard var current = applicant else { return }
        if let index = current.documents.firstIndex(where: { $0.name == name }) {
            var doc = current.documents[index]
            doc = Document(
                name: doc.name,
                status: status,
                uploadedAt: uploadedAt ?? doc.uploadedAt,
                fileName: fileName ?? doc.fileName,
                filePath: filePath ?? doc.filePath,
                mimeType: mimeType ?? doc.mimeType,
                size: size ?? doc.size
            )
            current.documents[index] = doc
            setApplicant(current)
        }
    }

    // MARK: - API-backed setters

    func updateApplicantRemote(_ request: UpdateApplicantRequest) async throws {
        guard let id = applicant?.id else { return }
        let updated = try await api.updateApplicant(id: id, request)
        setApplicant(updated)
    }

    func uploadDocumentRemote(_ doc: DocumentName, fileURL: URL) async throws -> Document {
        guard let id = applicant?.id else { throw URLError(.userAuthenticationRequired) }
        let updatedDoc = try await api.uploadDocument(applicantId: id, documentName: doc.rawValue, fileURL: fileURL)
        // Update local copy
        setDocumentStatus(
            name: updatedDoc.name,
            status: updatedDoc.status,
            uploadedAt: updatedDoc.uploadedAt,
            fileName: updatedDoc.fileName,
            filePath: updatedDoc.filePath,
            mimeType: updatedDoc.mimeType,
            size: updatedDoc.size
        )
        return updatedDoc
    }

    private init() {
        Task {
            await restoreSession()
        }
    }

    func setApplicant(_ applicant: Applicant) {
        self.applicant = applicant
        progress = nil
        UserDefaults.standard.set(applicant.id, forKey: applicantIdKey)
    }

    func signOut() {
        applicant = nil
        progress = nil
        Keychain.bearerToken = nil
        UserDefaults.standard.removeObject(forKey: applicantIdKey)
    }

    func refreshApplicant() async {
        guard let id = applicant?.id else { return }
        do {
            let refreshed = try await api.getApplicant(id: id)
            setApplicant(refreshed)
        } catch {
            print("Failed to refresh applicant: \(error)")
        }
    }

    func loadProgress() async {
        guard let id = applicant?.id else { return }
        do {
            progress = try await api.documentsProgress(applicantId: id)
        } catch {
            print("Failed to fetch progress: \(error)")
        }
    }

    private func restoreSession() async {
        guard let savedId = UserDefaults.standard.string(forKey: applicantIdKey) else { return }
        do {
            let savedApplicant = try await api.getApplicant(id: savedId)
            setApplicant(savedApplicant)
        } catch {
            // If restore fails, clear the saved id.
            UserDefaults.standard.removeObject(forKey: applicantIdKey)
        }
    }
}
