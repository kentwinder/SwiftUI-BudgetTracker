//
//  Budget.swift
//  BudgetTracker
//
//  Created by Kent Winder on 2/15/21.
//

import UIKit
import Foundation
import CoreData

@objc(Budget)
class Budget: NSManagedObject, Identifiable {
    static let entityName = "Budget"
    
    @NSManaged public var amount: NSNumber?
    @NSManaged public var details: String?
    @NSManaged public var updatedAt: Date?
    
    public func isIncome() -> Bool {
        return amount?.doubleValue ?? 0 >= 0
    }
}
