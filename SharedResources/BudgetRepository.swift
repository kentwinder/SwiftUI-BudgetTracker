//
//  BudgetRepository.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/15/21.
//

import CoreData
import Foundation
import UIKit
import WidgetKit

class BudgetRepository {
    static let shared = BudgetRepository()
    
    let context: NSManagedObjectContext!
    
    init(persistenceController: PersistenceController) {
        context = persistenceController.container.viewContext
    }
    
    convenience init() {
        self.init(persistenceController: PersistenceController.shared)
    }
    
    func insert(amount: Double, details: String) -> Budget? {
        guard let item = NSEntityDescription.insertNewObject(forEntityName: Budget.entityName,
                                                             into: context) as? Budget else { return nil }
        // item.amount = amount
        item.details = details
        item.updatedAt = Date()
        
        do {
            try context.save()
            
            WidgetCenter.shared.reloadTimelines(ofKind: "BudgetTracker_Widget")
            
            return item
        } catch {
            print("Failed to save budget with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getTotalAmount() throws -> Int {
        var amountTotal: Int = 0
        // create expression
        let expression = NSExpressionDescription()
        expression.expression =  NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: \Budget.amount)])
        expression.name = "amountTotal"
        expression.expressionResultType = NSAttributeType.integer32AttributeType
        // create fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Budget.entityName)
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        // execute fetch request
        let results = try context.fetch(fetchRequest)
        let resultMap = results[0] as? [String: Int]
        amountTotal = resultMap?["amountTotal"] ?? 0
        return amountTotal
    }
}
