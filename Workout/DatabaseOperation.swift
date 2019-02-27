//
//  DatabaseOperation.swift
//  Workout
//
//  Created by francis on 2019/2/24.
//  Copyright © 2019年 francis. All rights reserved.
//

//sorry but the whole file seems useless
//MARK: deprecated

import Foundation
import CoreData
import UIKit
func insertNewAction(action:Action,ctx:NSManagedObjectContext){
    let actionEntity = NSEntityDescription.entity(forEntityName: "Actions", in: ctx)!
    let actionClassEntity = NSManagedObject.init(entity: actionEntity, insertInto: ctx) as! Actions
    actionClassEntity.name = action.name
    actionClassEntity.note = action.note
    do{try ctx.save()}catch{fatalError(error.localizedDescription)}
}

func removeAction(actionName:String,ctx:NSManagedObjectContext){
    let fetch = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Actions")
    fetch.predicate = NSPredicate.init(format: "name = %@", argumentArray: [actionName])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetch) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        let toDelete = result.finalResult as! [Actions]
        for item in toDelete {
            ctx.delete(item as NSManagedObject)
        }
        do{try ctx.save()}catch{fatalError(error.localizedDescription)}
    }
    do{try ctx.execute(asynFetch)}catch{fatalError(error.localizedDescription)}
}

func addNewPlan(actionNameSet:[String]){}

func addToPlan(actionNameSet:[String],planName:String,ctx:NSManagedObjectContext){
    let fetchActions = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Actions")
    fetchActions.predicate = NSPredicate.init(format: "name = %@", argumentArray: actionNameSet)
    var plan:[Plans] = []
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchActions) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        let fetchPlan = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Plans")
        fetchPlan.predicate = NSPredicate.init(format: "name = %@", argumentArray: [planName])
        do{plan = try (ctx.fetch(fetchPlan) as! [Plans])}catch{fatalError(error.localizedDescription)}
        for action in result.finalResult as! [Actions]{
            //plan[0].addToActions(action)
        }
        do{try ctx.save()}catch{fatalError(error.localizedDescription)}
    }
    do{try ctx.execute(asynFetch)}catch{fatalError(error.localizedDescription)}
}

//MARK: deprecated
func insertNewPlan(plan:Plan,ctx:NSManagedObjectContext){
    let planEntity = NSEntityDescription.entity(forEntityName: "Plans", in: ctx)!
    let planClassEntity = NSManagedObject.init(entity: planEntity, insertInto: ctx) as! Plans
    planClassEntity.weekday = Int64.init(exactly: plan.weekday.rawValue)!
    planClassEntity.name = plan.title
    //planClassEntity.actions = NSSet.init(array: plan.actionsInPlan)
    planClassEntity.arch = NSSet.init(array: plan.archievs)
    // the following save methods may be replaced with the saveContext methods decleared in AppDelegate
    do{
        try ctx.save()
    }catch{
        fatalError(error.localizedDescription)
    }
}
func deletePlan(toDeletePlanTitle:String,ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Plans")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [toDeletePlanTitle])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        for toDeletePlans in result.finalResult!{
            ctx.delete(toDeletePlans as! NSManagedObject)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    do{
        try ctx.execute(asynFetch)
    }catch{
        fatalError(error.localizedDescription)
    }
}
func addPlanArch(newArch:[Date],planTitle:String,ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plans")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [planTitle])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        let matched = result.finalResult as! [Plans]
        for item in matched{
            item.addToArch(NSSet.init(array: newArch))
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    do{
        try ctx.execute(asynFetch)
    }catch{
        fatalError(error.localizedDescription)
    }
}
func removePlanArch(toDelete:[Date],planTitle:String,ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plans")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [planTitle])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        for item in result.finalResult as! [Plans]{
            item.removeFromArch(NSSet.init(array: toDelete))
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
    }
    do{
        try ctx.execute(asynFetch)
    }catch{
        fatalError(error.localizedDescription)
    }
}
func addPlanAction(toAdd:[Action],planTitle:String,ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Plan")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [planTitle])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        for item in result.finalResult as! [Plans]{
            //item.addToActions(NSSet.init(array: toAdd))
        }
    }
    do{
        try ctx.execute(asynFetch)
    }catch{
        fatalError(error.localizedDescription)
    }
}
func deletePlanAction(toDelete:[Action],planTitle:String,ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Plans")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [planTitle])
    let asynFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<NSFetchRequestResult>) in
        let results = result.finalResult as! [Plans]
        for item in results{
            //item.removeFromActions(NSSet.init(array: toDelete))
        }
    }
    do{
        try ctx.execute(asynFetch)
    }catch{
        fatalError(error.localizedDescription)
    }
}

