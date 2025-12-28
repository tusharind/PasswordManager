import SwiftUI

struct PasswordStrengthIndicator: View {
    let strength: PasswordStrength

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(barColor(for: index))
                    .frame(height: 4)
            }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .trailing) {
            Text(strength.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(strengthColor)
                .padding(.leading, 8)
        }
    }

    private func barColor(for index: Int) -> Color {
        switch strength {
        case .weak:
            return index == 0 ? .red : .gray.opacity(0.3)
        case .medium:
            return index <= 1 ? .orange : .gray.opacity(0.3)
        case .strong:
            return .green
        }
    }

    private var strengthColor: Color {
        switch strength {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
}
