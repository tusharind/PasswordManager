import CoreData
import Foundation

final class PasswordRepository {

    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext = PersistenceController.shared.container
            .viewContext
    ) {
        self.context = context
    }

    func savePassword(
        accountType: String,
        username: String,
        encryptedPassword: Data
    ) throws {

        let entity = PasswordItem(context: context)
        entity.id = UUID()
        entity.accountType = accountType
        entity.username = username
        entity.encryptedPassword = encryptedPassword
        entity.createdAt = Date()

        try context.save()
    }

    func fetchPasswords() throws -> [PasswordItem] {

        let request: NSFetchRequest<PasswordItem> = PasswordItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]

        return try context.fetch(request)
    }

    func deletePassword(_ entity: PasswordItem) throws {
        context.delete(entity)
        try context.save()
    }
}
