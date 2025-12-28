import SwiftUI

struct PasswordDetailView: View {
    @StateObject var viewModel: PasswordDetailViewModel
    @EnvironmentObject private var container: DependencyContainer

    init(item: PasswordItem) {
        let encryptionService = DependencyContainer.shared.encryptionService
        _viewModel = StateObject(
            wrappedValue: PasswordDetailViewModel(
                item: item,
                encryptionService: encryptionService
            )
        )
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

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

                        Image(systemName: "key.fill")
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
                        if viewModel.isEditing {
                            CustomTextField(
                                icon: "building.2",
                                placeholder: "Account Type",
                                text: $viewModel.editAccountType
                            )
                            CustomTextField(
                                icon: "person",
                                placeholder: "Username",
                                text: $viewModel.editUsername
                            )
                            .textInputAutocapitalization(.never)
                        } else {
                            InfoRow(
                                label: "Account",
                                value: viewModel.item.accountType ?? "N/A"
                            )
                            InfoRow(
                                label: "Username",
                                value: viewModel.item.username ?? "N/A"
                            )
                        }
                    }

                    VStack(spacing: 16) {
                        if viewModel.isEditing {
                            CustomSecureField(
                                icon: "key",
                                placeholder: "New Password",
                                text: $viewModel.editPasswordInput
                            )
                            if !viewModel.revealedPassword.isEmpty {
                                Text("Original: \(viewModel.revealedPassword)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            HStack {
                                Image(systemName: "key")
                                    .foregroundColor(.secondary)
                                    .frame(width: 20)

                                Text(
                                    viewModel.isRevealed
                                        ? viewModel.revealedPassword
                                        : "••••••••"
                                )
                                .font(
                                    viewModel.isRevealed
                                        ? .system(.body, design: .monospaced)
                                        : .body
                                )

                                Spacer()

                                Button(action: viewModel.toggleReveal) {
                                    Image(
                                        systemName: viewModel.isRevealed
                                            ? "eye.slash.fill" : "eye.fill"
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(
                                color: .black.opacity(0.05),
                                radius: 5,
                                x: 0,
                                y: 2
                            )
                            .padding(.horizontal)

                            if viewModel.isRevealed {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Password Strength")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                    PasswordStrengthIndicator(
                                        strength:
                                            PasswordStrengthCalculator.calculate(
                                                viewModel.revealedPassword
                                            )
                                    )
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                            }
                        }
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    if viewModel.isEditing {
                        VStack(spacing: 12) {
                            Button(action: viewModel.saveChanges) {
                                Text("Save Changes")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                                    .shadow(
                                        color: .blue.opacity(0.4),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )
                            }

                            Button(action: { viewModel.isEditing = false }) {
                                Text("Cancel")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(
                                        color: .black.opacity(0.05),
                                        radius: 5,
                                        x: 0,
                                        y: 2
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationTitle(viewModel.item.accountType ?? "Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isEditing {
                    Button("Edit") {
                        if !viewModel.isRevealed {
                            viewModel.toggleReveal()
                        }
                        viewModel.editPasswordInput = viewModel.revealedPassword
                        viewModel.isEditing = true
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)

            Text(value)
                .fontWeight(.medium)

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
