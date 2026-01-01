import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    enum Stage: Equatable {
        case enterEmail
        case codeSent(code: String?)
        case authenticated(applicant: Applicant)
        case error(String)

        static func == (lhs: Stage, rhs: Stage) -> Bool {
            switch (lhs, rhs) {
            case (.enterEmail, .enterEmail):
                return true
            case let (.codeSent(l), .codeSent(r)):
                return l == r
            case let (.authenticated(a), .authenticated(b)):
                return a.id == b.id
            case let (.error(l), .error(r)):
                return l == r
            default:
                return false
            }
        }
    }

    @Published var email: String = ""
    @Published var name: String = ""
    @Published var phone: String = ""
    @Published var dateOfBirth: String = ""
    @Published var code: String = ""
    @Published var stage: Stage = .enterEmail
    @Published var isLoading = false

    private let api = NBNAPI()

    func requestCode() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await api.requestLoginCode(
                email: email,
                name: name.isEmpty ? nil : name,
                phone: phone.isEmpty ? nil : phone,
                dateOfBirth: dateOfBirth.isEmpty ? nil : dateOfBirth
            )
            stage = .codeSent(code: response.code) // show locally for convenience
        } catch {
            stage = .error(error.localizedDescription)
        }
    }

    func verifyCode() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let response = try await api.verifyLoginCode(email: email, code: code)
            Keychain.bearerToken = response.token
            stage = .authenticated(applicant: response.applicant)
        } catch {
            stage = .error(error.localizedDescription)
        }
    }
}
