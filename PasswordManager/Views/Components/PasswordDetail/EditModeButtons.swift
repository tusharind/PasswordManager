import SwiftUI

struct EditModeButtons: View {
    let onSave: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onSave) {
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

            Button(action: onCancel) {
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
