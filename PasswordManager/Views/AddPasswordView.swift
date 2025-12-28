import CoreData
import CryptoKit
import SwiftUI

struct AddPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var container: DependencyContainer
    @StateObject private var viewModel: AddPasswordViewModel

    init() {
        let container = DependencyContainer.shared
        _viewModel = StateObject(
            wrappedValue: AddPasswordViewModel(
                repository: container.passwordRepository,
                encryptionService: container.encryptionService
            )
        )
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {

                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .blue.opacity(0.2),
                                            .purple.opacity(0.2),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)

                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .padding(.top, 20)

                        VStack(spacing: 16) {
                            CustomTextField(
                                icon: "building.2",
                                placeholder: "Account Type (e.g., Gmail)",
                                text: $viewModel.accountType
                            )

                            CustomTextField(
                                icon: "person",
                                placeholder: "Username / Email",
                                text: $viewModel.username
                            )
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                            CustomSecureField(
                                icon: "key",
                                placeholder: "Password",
                                text: $viewModel.passwordInput
                            )

                            if !viewModel.passwordInput.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password Strength")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    PasswordStrengthIndicator(
                                        strength:
                                            PasswordStrengthCalculator.calculate(
                                                viewModel.passwordInput
                                            )
                                    )
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            }
                        }

                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }

                        Button(action: {
                            viewModel.savePassword()
                            if viewModel.isSaved {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Save Password")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: viewModel.isFormValid
                                            ? [.blue, .purple]
                                            : [.gray, .gray],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(
                                    color: viewModel.isFormValid
                                        ? .blue.opacity(0.4) : .clear,
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .disabled(!viewModel.isFormValid)
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
    }
}
