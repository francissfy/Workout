//
//  AllActions.swift
//  Workout
//
//  Created by francis on 2019/2/26.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AllActions: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //控件
    @IBAction func edit(_ sender: Any) {
    }
    @IBAction func add(_ sender: Any) {
    }
    @IBOutlet weak var allActionTableView: UITableView!
    
    //变量
    var allAction:[Action] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allActionTableView.delegate = self
        allActionTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        refreshingData()
    }
    
    //delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAction.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellInAllAction") as! cellInAllAction
        cell.actionName.text = allAction[indexPath.row].name
        print(allAction[indexPath.row].name)
        return cell
    }
    //fetching, caching and reloading view
    //@deprecated
//    func fetchAllAction(){
//        let fetchingAlert = UIAlertController.init(title: "Fetching", message: nil, preferredStyle: UIAlertController.Style.alert)
//        let fetchRequest = NSFetchRequest<Actions>.init(entityName: "Actions")
//        fetchRequest.predicate = nil
//        let ctx = getPrivateQueueMOCtx()
//        let asyncFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest) { (result:NSAsynchronousFetchResult<Actions>) in
//            let res = result.finalResult!
//            self.allAction.removeAll()
//            for item in res{
//                let action = Action.init(name: item.name!, note: item.note)
//                self.allAction.append(action)
//            }
//            fetchingAlert.dismiss(animated: true, completion:nil)
//            DispatchQueue.main.async {
//                self.allActionTableView.reloadData()
//            }
//        }
//        ctx.performAndWait {
//            do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
//        }
//    }
    //
    func refreshingData(){
        let asyncQueue = DispatchQueue.global()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        asyncQueue.async {
            let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            ctx.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
            let fetchRequest = NSFetchRequest<Actions>.init(entityName: "Actions")
            fetchRequest.predicate = nil
            let asyncFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest, completionBlock: { (result:NSAsynchronousFetchResult<Actions>) in
                let allAcs = result.finalResult!
                self.allAction.removeAll()
                for item in allAcs{
                    let newAction = Action.init(name: item.name!, note: item.note)
                    self.allAction.append(newAction)
                }
                DispatchQueue.main.async {
                    self.allActionTableView.reloadData()
                }
            })
            do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
        }
    }
    
    
    
    //end of class
}

class cellInAllAction:UITableViewCell{
    @IBOutlet weak var actionName: UILabel!
}
