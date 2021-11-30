//
//  BudgetTrackerApp.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/8/21.
//

import SwiftUI

@main
struct BudgetTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            BudgetListView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
