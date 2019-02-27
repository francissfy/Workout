//
//  Database.swift
//  Workout
//
//  Created by francis on 2019/2/25.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import CoreData
import UIKit
//@ deperecated
func getPrivateQueueMOCtx()->NSManagedObjectContext{
    let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    let delegate = UIApplication.shared.delegate as! AppDelegate
    ctx.persistentStoreCoordinator = delegate.persistentContainer.persistentStoreCoordinator
    return ctx
}
func addAction(action:Action,ctx:NSManagedObjectContext){
    let actionEntityDescription = NSEntityDescription.entity(forEntityName: "Actions", in: ctx)!
    let actionMO = NSManagedObject.init(entity: actionEntityDescription, insertInto: ctx) as! Actions
    actionMO.name = action.name
    actionMO.note = action.note
    ctx.perform {
        do{try ctx.save()}catch{fatalError(error.localizedDescription)}
    }
}
//suggested
func addActionViaPrivateCTX(action:Action,afterSave:@escaping ()->Void){
    let ctx = getPrivateQueueMOCtx()
    let entityDescription = NSEntityDescription.entity(forEntityName: "Actions", in: ctx)!
    let managedObeject = NSManagedObject.init(entity: entityDescription, insertInto: ctx) as! Actions
    managedObeject.name = action.name
    managedObeject.note = action.note
    ctx.performAndWait {
        do{
            try ctx.save()
        }catch{
            fatalError(error.localizedDescription)
        }
    }
    afterSave()
}







func testStoredContent(){
    let asynCtx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    asynCtx.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
    let fetchRequest = NSFetchRequest<Actions>.init(entityName: "Actions")
    do{
        let result = try asynCtx.fetch(fetchRequest)
        for item in result{
            print(item.name)
            print("///////")
        }
    }catch{}
}


func testRemoveAllAction(){
    
}
func removeAction(toDeleteActionName:[String],ctx:NSManagedObjectContext){
    let fetchRequest = NSFetchRequest<Actions>.init(entityName: "Actions")
    fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: toDeleteActionName)
    do{
        let result = try ctx.fetch(fetchRequest)
        for item in result{
            ctx.delete(item)
        }
        try ctx.save()
    }catch{
        fatalError(error.localizedDescription)
    }
}

