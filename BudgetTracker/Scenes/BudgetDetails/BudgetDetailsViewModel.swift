//
//  BudgetDetailsViewModel.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/22/21.
//

import Foundation
import Combine
import SwiftUI
import CoreData
import WidgetKit

final class BudgetDetailsViewModel: ObservableObject {
    @Binding var isActive: Bool
    @Published var details = ""
    @Published var amount = ""
    @Published var isIncome: Bool
    @Published var errorMessage = ""
    
    // private var viewContext = PersistenceController.shared.container.viewContext
    private var repository = BudgetRepository()
    private var budget: Budget?
    
    init(budget: Budget? = nil, isActive: Binding<Bool>) {
        self.budget = budget
        self._isActive = isActive
        self.details = budget?.details ?? ""
        self.amount = String(abs(budget?.amount?.intValue ?? 0))
        self.isIncome = budget?.isIncome() ?? true
    }
    
    func save() {
        if details == "" {
            errorMessage = "Please input details"
            return
        }
        
        var amountInNumber: NSNumber = 0
        if amount == "" {
            errorMessage = "Please input amount"
            return
        } else {
            if let intValue = Int(amount) {
                amountInNumber = NSNumber(value: intValue * (isIncome ? 1 : -1))
            } else {
                errorMessage = "Invalid amount"
                return
            }
        }
        
        if budget == nil {
            budget = Budget(context: repository.context)
        }
        budget?.details = details
        budget?.amount = amountInNumber
        budget?.updatedAt = Date()

        do {
            try repository.context.save()
            WidgetCenter.shared.reloadTimelines(ofKind: "BudgetTracker_Widget")
            isActive = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
