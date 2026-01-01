//
//  NBNApp.swift
//  NBN
//
//  Created by RJ  Kigner on 12/31/25.
//

import SwiftUI
import CoreData

@main
struct NBNApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
