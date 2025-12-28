import SwiftUI

struct PasswordSection: View {
    let isEditing: Bool
    let isRevealed: Bool
    let revealedPassword: String
    @Binding var editPasswordInput: String
    let onToggleReveal: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            if isEditing {
                CustomSecureField(
                    icon: "key",
                    placeholder: "New Password",
                    text: $editPasswordInput
                )
                if !revealedPassword.isEmpty {
                    Text("Original: \(revealedPassword)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            } else {
                PasswordDisplayRow(
                    isRevealed: isRevealed,
                    revealedPassword: revealedPassword,
                    onToggleReveal: onToggleReveal
                )

                if isRevealed {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password Strength")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        PasswordStrengthIndicator(
                            strength:
                                PasswordStrengthCalculator.calculate(
                                    revealedPassword
                                )
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}
