import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    var onAuthenticated: ((Applicant) -> Void)?

    var body: some View {
        VStack(spacing: 20) {
            Text("NBN Login")
                .font(.title)
                .bold()

            switch viewModel.stage {
            case .enterEmail, .error:
                emailForm
            case let .codeSent(code):
                codeForm(code: code)
            case let .authenticated(applicant):
                VStack(spacing: 8) {
                    Text("Welcome, \(applicant.name)")
                        .font(.headline)
                    Text("You’re signed in.")
                        .foregroundStyle(.secondary)
                }
            }

            if case let .error(message) = viewModel.stage {
                Text(message)
                    .foregroundStyle(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .onChange(of: viewModel.stage) { newValue in
            if case let .authenticated(applicant) = newValue {
                AppModel.shared.setApplicant(applicant)
                onAuthenticated?(applicant)
            }
        }
    }

    @ViewBuilder
    private var emailForm: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            TextField("Name (new users)", text: $viewModel.name)
            TextField("Phone (new users)", text: $viewModel.phone)
                .keyboardType(.phonePad)
            TextField("Date of Birth (YYYY-MM-DD)", text: $viewModel.dateOfBirth)

            Button {
                Task { await viewModel.requestCode() }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Send Code")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.email.isEmpty || viewModel.isLoading)
        }
    }

    @ViewBuilder
    private func codeForm(code: String?) -> some View {
        VStack(spacing: 12) {
            Text("Check your email for a 6-digit code.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let code {
                Text("Dev code: \(code)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            TextField("Enter code", text: $viewModel.code)
                .keyboardType(.numberPad)

            Button {
                Task { await viewModel.verifyCode() }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Verify & Sign In")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.code.count < 6 || viewModel.isLoading)
        }
    }
}

#Preview {
    AuthView()
}
