import Foundation
import SwiftUI

struct PasswordStrengthCalculator {

    static func calculate(_ password: String) -> PasswordStrength {
        var score = 0

        if password.count >= 8 {
            score += 1
        }
        if password.count >= 12 {
            score += 1
        }

        let hasUppercase =
            password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase =
            password.rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasNumbers = password.rangeOfCharacter(from: .decimalDigits) != nil
        let hasSpecialChars =
            password.rangeOfCharacter(
                from: CharacterSet(charactersIn: "!@#$%^&*()_+-=[]{}|;:,.<>?")
            ) != nil

        if hasUppercase && hasLowercase {
            score += 1
        }
        if hasNumbers {
            score += 1
        }
        if hasSpecialChars {
            score += 1
        }

        if score >= 4 {
            return .strong
        } else if score >= 2 {
            return .medium
        } else {
            return .weak
        }
    }
}
