import Combine
import CryptoKit
import Foundation

@MainActor
class AddPasswordViewModel: ObservableObject {

    @Published var accountType: String = ""
    @Published var username: String = ""
    @Published var passwordInput: String = ""
    @Published var errorMessage: String?
    @Published var isSaved: Bool = false

    private let repository: PasswordRepository
    private let encryptionService: EncryptionService

    var isFormValid: Bool {
        !accountType.isEmpty && !username.isEmpty && !passwordInput.isEmpty
    }

    init(repository: PasswordRepository, encryptionService: EncryptionService) {
        self.repository = repository
        self.encryptionService = encryptionService
    }

    func savePassword() {
        guard !accountType.isEmpty, !username.isEmpty, !passwordInput.isEmpty
        else {
            errorMessage = "All fields are required."
            return
        }

        do {
            let encryptedData = try encryptionService.encrypt(
                password: passwordInput
            )
            try repository.savePassword(
                accountType: accountType,
                username: username,
                encryptedPassword: encryptedData
            )
            isSaved = true
        } catch {
            errorMessage =
                "Failed to save password: \(error.localizedDescription)"
        }
    }
}
