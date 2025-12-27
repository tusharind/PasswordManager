//
//  PasswordManagerApp.swift
//  PasswordManager
//
//  Created by Prakhar Jaiswal on 27/12/25.
//

import SwiftUI
import CoreData

@main
struct PasswordManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
