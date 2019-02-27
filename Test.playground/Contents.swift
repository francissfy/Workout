import UIKit
import Foundation
import CoreData

let MainQueue = DispatchQueue.main
let GloQueue = DispatchQueue.global()

MainQueue.async {
    let ctx1 = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    ctx1.performAndWait {
        print(Thread.current)
    }
}
GloQueue.async {
    let ctx2 = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    ctx2.perform {
        print(Thread.current)
    }
}
