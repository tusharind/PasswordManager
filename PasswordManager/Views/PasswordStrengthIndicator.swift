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
                .foregroundColor(strength.color)
                .padding(.leading, 8)
        }
    }

    private func barColor(for index: Int) -> Color {
        switch strength {
        case .weak:
            return index == 0 ? strength.color : .gray.opacity(0.3)
        case .medium:
            return index <= 1 ? strength.color : .gray.opacity(0.3)
        case .strong:
            return strength.color
        }
    }
}
