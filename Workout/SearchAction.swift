//
//  SearchAction.swift
//  Workout
//
//  Created by francis on 2019/2/21.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class SearchActionViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    //组件
    @IBOutlet weak var backAndDone: UIBarButtonItem!
    @IBOutlet weak var selectAndCancel: UIBarButtonItem!
    @IBAction func backAndDoneBtn(_ sender: UIBarButtonItem) {
        if(actionTableView.isEditing == false){
            self.dismiss(animated: true, completion: nil)
        }else{
            //processed in segue
            performSegue(withIdentifier: "unwindFromSearchAction", sender: self)
        }
    }
    @IBAction func SelectAndCancelBtn(_ sender: UIBarButtonItem) {
        if(actionTableView.isEditing == false){
            actionTableView.setEditing(true, animated: true)
            actionTableView.allowsMultipleSelection = true
            backAndDone.title = "Done"
            selectAndCancel.title = "Cancel"
        }else{
            actionTableView.setEditing(false, animated: true)
            actionTableView.allowsMultipleSelection = false
            backAndDone.title = "Back"
            selectAndCancel.title = "Select"
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var actionTableView: UITableView!
    @IBAction func manageAction(_ sender: Any) {
        
    }
    //变量
    var cachedActions:[Action] = []
    var searchedActions:[Action] = []
    var didSelectedActions:[Int:Action] = [:]
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        actionTableView.delegate = self
        actionTableView.dataSource = self
        actionTableView.allowsSelection = false
        actionTableView.allowsMultipleSelection = false
    }
    override func viewDidAppear(_ animated: Bool) {
        cacheAllActions()
    }
    override func viewWillDisappear(_ animated: Bool) {
        actionTableView.setEditing(false, animated: true)
        backAndDone.title = "Back"
        selectAndCancel.title = "Select"
        didSelectedActions.removeAll()
    }
    //cache all the stored actions
    func cacheAllActions(){
        let waittingAlert = UIAlertController.init(title: "Fetching", message: nil, preferredStyle: UIAlertController.Style.alert)
        let persistentCoordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        let fetch = NSFetchRequest<Actions>.init(entityName: "Actions")
        fetch.predicate = nil
        let asyncFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetch) { (result:NSAsynchronousFetchResult<Actions>) in
            self.cachedActions.removeAll()
            for item in result.finalResult!{
                let newAction = Action.init(name: item.name!, note: item.note!)
                newAction.objectIDinCoreData = item.objectID.isTemporaryID ? nil:item.objectID
                self.cachedActions.append(newAction)
            }
            self.searchedActions = self.cachedActions
            DispatchQueue.main.async {
                self.actionTableView.reloadData()
            }
        }
        DispatchQueue.global().async {
            let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            ctx.persistentStoreCoordinator = persistentCoordinator
            do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
            waittingAlert.dismiss(animated: true, completion: nil)
        }
    }
    //query
    func queryCachedActions(keywords:String){
        let searchingAlert = UIAlertController.init(title: "Searching", message: "Searching all actions", preferredStyle: UIAlertController.Style.alert)
        let queue = DispatchQueue.global()
        self.present(searchingAlert, animated: true, completion: nil)
        let regExStr = "\\b\(keywords)[a-z]*\\b"
        var reg = NSRegularExpression.init()
        do{
            reg = try NSRegularExpression.init(pattern: regExStr, options: NSRegularExpression.Options.caseInsensitive)
        }catch{
            fatalError(error.localizedDescription)
        }
        queue.async {
            self.searchedActions.removeAll()
            for item in self.cachedActions{
                if(reg.numberOfMatches(in: item.name, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, item.name.count-1))>0){self.searchedActions.append(item)}
            }
            DispatchQueue.main.async {
                self.actionTableView.reloadData()
            }
            searchingAlert.dismiss(animated: true, completion: nil)
        }
    }
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedActions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell") as! actionCell
        cell.actionName.text = searchedActions[indexPath.row].name
        return cell
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text == ""){
            searchedActions = cachedActions
            actionTableView.reloadData()
        }else{
            queryCachedActions(keywords: searchBar.text!)
        }
        searchBar.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectedActions[indexPath.row] = searchedActions[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        didSelectedActions.removeValue(forKey: indexPath.row)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let type = UITableViewCell.EditingStyle.insert.rawValue | UITableViewCell.EditingStyle.delete.rawValue
        return UITableViewCell.EditingStyle.init(rawValue: type)!
    }
    //
}
class actionCell:UITableViewCell{
    @IBOutlet weak var actionName: UILabel!
}
