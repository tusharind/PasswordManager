import CoreData
import SwiftUI

@main
struct PasswordManagerApp: App {
    @StateObject private var container = DependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(container)
                .environment(
                    \.managedObjectContext,
                    container.viewContext
                )
        }
    }
}
