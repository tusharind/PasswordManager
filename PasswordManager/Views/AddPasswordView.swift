import CoreData
import CryptoKit
import SwiftUI

struct AddPasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext

    @State private var accountType: String = ""
    @State private var username: String = ""
    @State private var passwordInput: String = ""
    @State private var errorMessage: String?

    private let encryptionService: EncryptionService

    init() {

        do {
            let keychainService = KeychainService()
            let key = try keychainService.getOrCreateKey()
            self.encryptionService = EncryptionService(secretKey: key)
        } catch {
            fatalError(
                "Failed to initialize security services: \(error.localizedDescription)"
            )
        }
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
                                text: $accountType
                            )

                            CustomTextField(
                                icon: "person",
                                placeholder: "Username / Email",
                                text: $username
                            )
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                            CustomSecureField(
                                icon: "key",
                                placeholder: "Password",
                                text: $passwordInput
                            )

                            if !passwordInput.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password Strength")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    PasswordStrengthIndicator(
                                        strength:
                                            PasswordStrengthCalculator.calculate(
                                                passwordInput
                                            )
                                    )
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            }
                        }

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.horizontal)
                        }

                        Button(action: savePassword) {
                            Text("Save Password")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: isFormValid
                                            ? [.blue, .purple]
                                            : [.gray, .gray],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                                .shadow(
                                    color: isFormValid
                                        ? .blue.opacity(0.4) : .clear,
                                    radius: 8,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .disabled(!isFormValid)
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

    private var isFormValid: Bool {
        !accountType.isEmpty && !username.isEmpty && !passwordInput.isEmpty
    }

    private func savePassword() {
        guard !accountType.isEmpty, !username.isEmpty, !passwordInput.isEmpty
        else {
            errorMessage = "All fields are required."
            return
        }

        do {
            let encryptedData = try encryptionService.encrypt(
                password: passwordInput
            )

            let newPassword = PasswordItem(context: viewContext)
            newPassword.id = UUID()
            newPassword.accountType = accountType
            newPassword.username = username
            newPassword.encryptedPassword = encryptedData
            newPassword.createdAt = Date()

            try viewContext.save()

            presentationMode.wrappedValue.dismiss()
        } catch {
            errorMessage =
                "Failed to save password: \(error.localizedDescription)"
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)

            TextField(placeholder, text: $text)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct CustomSecureField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)

            SecureField(placeholder, text: $text)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
