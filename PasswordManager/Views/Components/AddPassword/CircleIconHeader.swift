import SwiftUI

struct CircleIconHeader: View {
    let iconName: String
    let size: CGFloat

    init(iconName: String = "key.fill", size: CGFloat = 80) {
        self.iconName = iconName
        self.size = size
    }

    var body: some View {
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
                .frame(width: size, height: size)

            Image(systemName: iconName)
                .font(.system(size: size * 0.5))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .padding(.top, 20)
    }
}
