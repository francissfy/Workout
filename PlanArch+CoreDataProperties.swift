//
//  PlanArch+CoreDataProperties.swift
//  
//
//  Created by francis on 2019/2/28.
//
//

import Foundation
import CoreData


extension PlanArch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlanArch> {
        return NSFetchRequest<PlanArch>(entityName: "PlanArch")
    }

    @NSManaged public var archDate: NSDate?
    @NSManaged public var plan: Plans?

}
