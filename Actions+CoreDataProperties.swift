//
//  Actions+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/25.
//
//

import Foundation
import CoreData


extension Actions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Actions> {
        return NSFetchRequest<Actions>(entityName: "Actions")
    }

    @NSManaged public var group: Int64
    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var num: Int64
    @NSManaged public var plan: NSSet?

}

// MARK: Generated accessors for plan
extension Actions {

    @objc(addPlanObject:)
    @NSManaged public func addToPlan(_ value: Plans)

    @objc(removePlanObject:)
    @NSManaged public func removeFromPlan(_ value: Plans)

    @objc(addPlan:)
    @NSManaged public func addToPlan(_ values: NSSet)

    @objc(removePlan:)
    @NSManaged public func removeFromPlan(_ values: NSSet)

}
