import Combine
import CoreData
import CryptoKit
import Foundation

class DependencyContainer: ObservableObject {
    static let shared = DependencyContainer()

    let persistenceController: PersistenceController
    let keychainService: KeychainService
    let encryptionService: EncryptionService
    let passwordRepository: PasswordRepository

    private init() {

        self.persistenceController = PersistenceController.shared

        self.keychainService = KeychainService()

        do {
            let key = try keychainService.getOrCreateKey()
            self.encryptionService = EncryptionService(secretKey: key)
        } catch {
            fatalError(
                "Failed to initialize encryption service: \(error.localizedDescription)"
            )
        }

        self.passwordRepository = PasswordRepository(
            context: persistenceController.container.viewContext
        )
    }

    var viewContext: NSManagedObjectContext {
        persistenceController.container.viewContext
    }
}
