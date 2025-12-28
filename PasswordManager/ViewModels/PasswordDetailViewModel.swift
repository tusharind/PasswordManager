import Combine
import CoreData
import CryptoKit
import Foundation

@MainActor
class PasswordDetailViewModel: ObservableObject {

    @Published var revealedPassword: String = ""
    @Published var isRevealed: Bool = false
    @Published var errorMessage: String?

    @Published var isEditing: Bool = false
    @Published var editAccountType: String = ""
    @Published var editUsername: String = ""
    @Published var editPasswordInput: String = ""

    let item: PasswordItem
    private let encryptionService: EncryptionService

    init(item: PasswordItem, encryptionService: EncryptionService) {
        self.item = item
        self.encryptionService = encryptionService

        self.editAccountType = item.accountType ?? ""
        self.editUsername = item.username ?? ""
    }

    func toggleReveal() {
        if isRevealed {
            isRevealed = false
            revealedPassword = ""
        } else {
            guard let encryptedData = item.encryptedPassword else {
                errorMessage = "No password data."
                return
            }

            do {
                revealedPassword = try encryptionService.decrypt(
                    encryptedData: encryptedData
                )
                isRevealed = true

                if editPasswordInput.isEmpty {
                    editPasswordInput = revealedPassword
                }
            } catch {
                errorMessage =
                    "Decryption failed: \(error.localizedDescription)"
            }
        }
    }

    func saveChanges() {
        do {
            let newEncryptedData = try encryptionService.encrypt(
                password: editPasswordInput
            )

            item.accountType = editAccountType
            item.username = editUsername
            item.encryptedPassword = newEncryptedData

            try item.managedObjectContext?.save()

            isEditing = false
            isRevealed = false
            revealedPassword = ""

        } catch {
            errorMessage = "Failed to update: \(error.localizedDescription)"
        }
    }
}
