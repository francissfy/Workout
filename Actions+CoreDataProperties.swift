//
//  Actions+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/28.
//
//

import Foundation
import CoreData


extension Actions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Actions> {
        return NSFetchRequest<Actions>(entityName: "Actions")
    }

    @NSManaged public var name: String?
    @NSManaged public var note: String?
    @NSManaged public var specified: NSSet?

}

// MARK: Generated accessors for specified
extension Actions {

    @objc(addSpecifiedObject:)
    @NSManaged public func addToSpecified(_ value: SpecifiedActions)

    @objc(removeSpecifiedObject:)
    @NSManaged public func removeFromSpecified(_ value: SpecifiedActions)

    @objc(addSpecified:)
    @NSManaged public func addToSpecified(_ values: NSSet)

    @objc(removeSpecified:)
    @NSManaged public func removeFromSpecified(_ values: NSSet)

}
