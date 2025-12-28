import SwiftUI

struct PasswordDisplayRow: View {
    let isRevealed: Bool
    let revealedPassword: String
    let onToggleReveal: () -> Void

    var body: some View {
        HStack {
            Image(systemName: "key")
                .foregroundColor(.secondary)
                .frame(width: 20)

            Text(
                isRevealed
                    ? revealedPassword
                    : "••••••••"
            )
            .font(
                isRevealed
                    ? .system(.body, design: .monospaced)
                    : .body
            )

            Spacer()

            Button(action: onToggleReveal) {
                Image(
                    systemName: isRevealed
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
    }
}
