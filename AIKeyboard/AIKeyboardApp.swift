//
//  AIKeyboardApp.swift
//  AIKeyboard
//
//  Created by Asami Doi on 2023/04/08.
//

import SwiftUI

@main
struct AIKeyboardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
