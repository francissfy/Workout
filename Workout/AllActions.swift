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
    
    @IBAction func backAndCancel(_ sender: UIBarButtonItem) {
        if(allActionTableView.isEditing){
            sender.title = "Back"
            editAndAddBtn.title = "Edit"
            allActionTableView.setEditing(false, animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBOutlet weak var backAndCancelBtn: UIBarButtonItem!
    @IBOutlet weak var editAndAddBtn: UIBarButtonItem!
    @IBAction func editAndAdd(_ sender: UIBarButtonItem) {
        if(allActionTableView.isEditing){
            sender.title = "Edit"
            backAndCancelBtn.title = "Back"
            allActionTableView.setEditing(false, animated: true)
            performSegue(withIdentifier: "addActionSegue", sender: self)
        }else{
            sender.title = "Add"
            backAndCancelBtn.title = "Cancel"
            allActionTableView.setEditing(true, animated: true)
        }
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
    //
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{ return UIStatusBarStyle.lightContent }
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            let toDelete = allAction[indexPath.row]
            allAction.remove(at: indexPath.row)
            tableView.reloadData()
            let coordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
            DispatchQueue.global().async {
                let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                ctx.persistentStoreCoordinator = coordinator
                let fetchRequest = NSFetchRequest<Actions>.init(entityName: "Actions")
                fetchRequest.predicate = NSPredicate.init(format: "name = %@", argumentArray: [toDelete.name])
                let asyncFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest, completionBlock: { (result:NSAsynchronousFetchResult<Actions>) in
                    let toDeleteActions = result.finalResult!
                    for item in toDeleteActions{
                        ctx.delete(item)
                    }
                    do{try ctx.save()}catch{fatalError(error.localizedDescription)}
                })
                do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
            }
            
        }
    }
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
                    let newAction = Action.init(name: item.name!, note: item.note!)
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
