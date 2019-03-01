//
//  Plans+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/28.
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
    @NSManaged public var arch: NSSet?
    @NSManaged public var specifiedaction: NSSet?

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

// MARK: Generated accessors for specifiedaction
extension Plans {

    @objc(addSpecifiedactionObject:)
    @NSManaged public func addToSpecifiedaction(_ value: SpecifiedActions)

    @objc(removeSpecifiedactionObject:)
    @NSManaged public func removeFromSpecifiedaction(_ value: SpecifiedActions)

    @objc(addSpecifiedaction:)
    @NSManaged public func addToSpecifiedaction(_ values: NSSet)

    @objc(removeSpecifiedaction:)
    @NSManaged public func removeFromSpecifiedaction(_ values: NSSet)

}
