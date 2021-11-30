//
//  BudgetListViewModel.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/15/21.
//

import Foundation
import Combine

class BudgetListViewModel: ObservableObject {
    private var viewContext = PersistenceController.shared.container.viewContext
    
    @Published var showLoading = false
    @Published private(set) var budgets: [Budget] = []
    
    private let didChange = PassthroughSubject<BudgetListViewModel, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func getBudgets() {
        showLoading = true
        // budgets = BudgetRepository.shared.fetchAll()
    }
    
    func addBudget() {
        let newItem = Budget(context: viewContext)
        newItem.amount = 1
        newItem.details = "Test"
        newItem.updatedAt = Date()

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
