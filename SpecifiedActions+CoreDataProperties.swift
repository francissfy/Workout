//
//  SpecifiedActions+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/28.
//
//

import Foundation
import CoreData


extension SpecifiedActions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpecifiedActions> {
        return NSFetchRequest<SpecifiedActions>(entityName: "SpecifiedActions")
    }

    @NSManaged public var group: Int64
    @NSManaged public var num: Int64
    @NSManaged public var action: Actions?
    @NSManaged public var plan: Plans?

}
