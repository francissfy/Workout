//
//  addPlan.swift
//  Workout
//
//  Created by francis on 2019/2/26.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AddPlan:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    //控件
    @IBOutlet weak var groupNumPicker: UIPickerView!
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var planName: UITextField!
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        if(newPlan.objectIDinCoreData != nil){
            savingPlanWithID(toSave: newPlan)
        }else{savingPlan(toSave: newPlan)}
    }
    
    
    @IBAction func editActionTable(_ sender: UIButton) {
        if(actionTableView.isEditing == true){
            sender.setTitle("Edit", for: UIControl.State.normal)
            actionTableView.setEditing(false, animated: true)
        }else{
            actionTableView.setEditing(true, animated: true)
            sender.setTitle("Done", for: UIControl.State.normal)
        }
    }
    @IBOutlet weak var actionFreqLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    
    //变量
    var newPlan = Plan.init(title: "Default",weekday: Weekday.Monday)
    //ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        groupNumPicker.layer.cornerRadius = CGFloat(8)
        actionTableView.layer.cornerRadius = CGFloat(8)
        groupNumPicker.delegate = self
        groupNumPicker.dataSource = self
        groupNumPicker.selectRow(6, inComponent: 0, animated: false)
        groupNumPicker.selectRow(14, inComponent: 1, animated: false)
        planName.delegate = self
        planName.text = newPlan.title
        actionTableView.dataSource = self
        actionTableView.delegate = self
        weekdayLabel.isUserInteractionEnabled = true
        weekdayLabel.text = newPlan.weekday.fullString
        let gesRecog = UITapGestureRecognizer.init(target: self, action: #selector(showWeekdayActionSheet))
        weekdayLabel.addGestureRecognizer(gesRecog)
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    //saving plan
    func savingPlanWithID(toSave:Plan){
        let fetchingSavingAlert = UIAlertController.init(title: "Saving Plan", message: nil, preferredStyle: UIAlertController.Style.alert)
        if(toSave.objectIDinCoreData != nil){
            DispatchQueue.main.async {
                self.present(fetchingSavingAlert, animated: true, completion: nil)
            }
            let coordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
            DispatchQueue.global().async {
                let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
                ctx.persistentStoreCoordinator = coordinator
                let NSMO = (ctx.object(with: toSave.objectIDinCoreData!) as! Plans)
                NSMO.name = toSave.title
                NSMO.weekday = Int64(toSave.weekday.rawValue)
                NSMO.specifiedaction = NSSet()
                let specificActionEntitydDes = NSEntityDescription.entity(forEntityName: "SpecifiedActions", in: ctx)!
                for specAction in toSave.actionsInPlan{
                    let NSMSpecAction = (NSManagedObject.init(entity: specificActionEntitydDes, insertInto: ctx) as! SpecifiedActions)
                    NSMSpecAction.action = (ctx.object(with: specAction.action.objectIDinCoreData!) as! Actions)
                    NSMSpecAction.group = Int64(specAction.group)
                    NSMSpecAction.num = Int64(specAction.num)
                    NSMO.addToSpecifiedaction(NSMSpecAction)
                }
                // MARK: left for saving arch infomation
                do{try ctx.save()}catch{fatalError(error.localizedDescription)}
                DispatchQueue.main.async {
                    fetchingSavingAlert.dismiss(animated: true, completion: {()->Void in
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
    func savingPlan(toSave:Plan){
        let fetchingSavingAlert = UIAlertController.init(title: "Saving Plan", message: nil, preferredStyle: UIAlertController.Style.alert)
        let coordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.present(fetchingSavingAlert, animated: true, completion: nil)
            }
            let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            ctx.persistentStoreCoordinator = coordinator
            let planEntityDescription = NSEntityDescription.entity(forEntityName: "Plans", in: ctx)!
            let newMPlan = NSManagedObject.init(entity: planEntityDescription, insertInto: ctx) as! Plans
            let specifiedActionEntityDescription = NSEntityDescription.entity(forEntityName: "SpecifiedActions", in: ctx)!
            for specAction in toSave.actionsInPlan{
                let managedAction = ctx.object(with: specAction.action.objectIDinCoreData!) as! Actions
                let managedSpecifiedAction = NSManagedObject.init(entity: specifiedActionEntityDescription, insertInto: ctx) as! SpecifiedActions
                managedSpecifiedAction.action = managedAction
                managedSpecifiedAction.group = Int64(specAction.group)
                managedSpecifiedAction.num = Int64(specAction.num)
                newMPlan.addToSpecifiedaction(managedSpecifiedAction)
            }
            newMPlan.arch = NSSet.init()
            newMPlan.name = self.newPlan.title
            newMPlan.weekday = Int64(self.newPlan.weekday.rawValue)
            do{try ctx.save()}catch{fatalError(error.localizedDescription)}
            DispatchQueue.main.async {
                fetchingSavingAlert.dismiss(animated: true, completion: {()->Void in
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    //Alert
    @objc func showWeekdayActionSheet(){
        let weekdaySelectActionSheet = UIAlertController.init(title: "Weekday", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for i in 1...7{
            let newAction = UIAlertAction.init(title: convertToWeekday(wd: i).fullString, style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                self.newPlan.weekday = convertToWeekday(wd: i)
                self.weekdayLabel.text = self.newPlan.weekday.fullString
            }
            weekdaySelectActionSheet.addAction(newAction)
        }
        self.present(weekdaySelectActionSheet, animated: true, completion: nil)
    }
    
    func showEmptyNameAlert(){
        let nameAlertViewController = UIAlertController.init(title: "Empty Infomation", message: "Please enter text for plan name!", preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction.init(title: "Cancel", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) in
            nameAlertViewController.dismiss(animated: true, completion: nil)
        }
        nameAlertViewController.addAction(action)
        self.present(nameAlertViewController, animated: true, completion: nil)
    }
    //delegate and datasource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var num = 20
        if(component == 0){num = 20}
        else if(component == 1){num = 50}
        return num
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attr = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: CGFloat(20))]
        let nsattrstr = NSAttributedString.init(string: "\(row+1)", attributes: attr)
        return nsattrstr
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var (oldGroup,oldNum) = (groupNumPicker.selectedRow(inComponent: 0)+1,groupNumPicker.selectedRow(inComponent: 1)+1)
        if(component == 0){oldGroup = row+1}
        else if(component == 1){oldNum = row+1}
        if(actionTableView.indexPathForSelectedRow != nil){
            let selectedRow = actionTableView.indexPathForSelectedRow!.row
            actionFreqLabel.text = "Group \(oldGroup) X Num \(oldNum)"
            newPlan.actionsInPlan[selectedRow].group = oldGroup
            newPlan.actionsInPlan[selectedRow].num = oldNum
            actionTableView.reloadRows(at: [actionTableView.indexPathForSelectedRow!], with: UITableView.RowAnimation.automatic)
        }else{
            actionFreqLabel.text = "Group - X Num -"
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text == ""){
            showEmptyNameAlert()
        }else{
            newPlan.title = textField.text!
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPlan.actionsInPlan.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionInPlan") as! actionTableViewCell
        cell.actionName.text = newPlan.actionsInPlan[indexPath.row].action.name
        cell.actionFreq.text = "\(newPlan.actionsInPlan[indexPath.row].group)X\(newPlan.actionsInPlan[indexPath.row].num)"
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCell.EditingStyle.delete){
            newPlan.actionsInPlan.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (group,num) = (newPlan.actionsInPlan[indexPath.row].group,newPlan.actionsInPlan[indexPath.row].num)
        actionFreqLabel.text = "Group \(group) X Num \(num)"
        groupNumPicker.selectRow(group-1, inComponent: 0, animated: true)
        groupNumPicker.selectRow(num-1, inComponent: 1, animated: true)
    }
    //状态栏设置
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{ return UIStatusBarStyle.lightContent }
    }
    @IBAction func unwindSegueFromSearchAction(_ segue:UIStoryboardSegue){
        let sourceVC = segue.source as! SearchActionViewController
        for item in sourceVC.didSelectedActions{
            let specifeidAction = SpecifiedAction.init(action: item.value, group: 7, num: 15)
            newPlan.actionsInPlan.append(specifeidAction)
        }
        actionTableView.reloadData()
    }
}

class actionTableViewCell:UITableViewCell{
    @IBOutlet weak var actionName: UILabel!
    @IBOutlet weak var actionFreq: UILabel!
}
