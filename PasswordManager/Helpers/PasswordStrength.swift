import SwiftUI

enum PasswordStrength: String {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"

    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .orange
        case .strong: return .green
        }
    }
}
