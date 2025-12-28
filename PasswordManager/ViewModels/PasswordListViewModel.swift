import Combine
import CoreData
import Foundation
import SwiftUI

@MainActor
class PasswordListViewModel: ObservableObject {

    @Published var passwords: [PasswordItem] = []
    @Published var errorMessage: String?

    private let repository: PasswordRepository

    init() {
        self.repository = PasswordRepository()
        fetchPasswords()
    }

    func fetchPasswords() {
        do {
            self.passwords = try repository.fetchPasswords()
        } catch {
            self.errorMessage =
                "Failed to fetch passwords: \(error.localizedDescription)"
        }
    }

    func deletePassword(at offsets: IndexSet) {
        offsets.forEach { index in
            let password = passwords[index]
            do {
                try repository.deletePassword(password)
                self.passwords.remove(at: index)
            } catch {
                self.errorMessage =
                    "Failed to delete password: \(error.localizedDescription)"

                fetchPasswords()
            }
        }
    }
}
