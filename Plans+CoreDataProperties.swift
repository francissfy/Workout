//
//  Plans+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/25.
//
//

import Foundation
import CoreData


extension Plans {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Plans> {
        return NSFetchRequest<Plans>(entityName: "Plans")
    }

    @NSManaged public var name: String?
    @NSManaged public var weekday: Int64
    @NSManaged public var actions: NSSet?
    @NSManaged public var arch: NSSet?

}

// MARK: Generated accessors for actions
extension Plans {

    @objc(addActionsObject:)
    @NSManaged public func addToActions(_ value: Actions)

    @objc(removeActionsObject:)
    @NSManaged public func removeFromActions(_ value: Actions)

    @objc(addActions:)
    @NSManaged public func addToActions(_ values: NSSet)

    @objc(removeActions:)
    @NSManaged public func removeFromActions(_ values: NSSet)

}

// MARK: Generated accessors for arch
extension Plans {

    @objc(addArchObject:)
    @NSManaged public func addToArch(_ value: PlanArch)

    @objc(removeArchObject:)
    @NSManaged public func removeFromArch(_ value: PlanArch)

    @objc(addArch:)
    @NSManaged public func addToArch(_ values: NSSet)

    @objc(removeArch:)
    @NSManaged public func removeFromArch(_ values: NSSet)

}
