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

    init() {
        self.repository = PasswordRepository()

        do {
            let keychainService = KeychainService()
            let key = try keychainService.getOrCreateKey()
            self.encryptionService = EncryptionService(secretKey: key)
        } catch {
            fatalError(
                "Failed to initialize security services: \(error.localizedDescription)"
            )
        }
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
