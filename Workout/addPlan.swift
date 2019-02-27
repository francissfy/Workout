//
//  addPlan.swift
//  Workout
//
//  Created by francis on 2019/2/26.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
class AddPlan:UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    //控件
    @IBOutlet weak var groupNumPicker: UIPickerView!
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var planName: UITextField!
    @IBAction func editActionTable(_ sender: UIButton) {
        if(actionTableView.isEditing == true){
            sender.setTitle("Edit", for: UIControl.State.normal)
            actionTableView.setEditing(false, animated: true)
        }else{
            actionTableView.setEditing(true, animated: true)
            sender.setTitle("Done", for: UIControl.State.normal)
        }
    }
    @IBAction func addActionToPlan(_ sender: UIButton) {
        //test
        let action = Action.init(name: "Hellp", note: "BR")
        let speActions = [SpecifiedAction.init(action: action, group: 4, num: 12)]
        newPlan.addAction(action: speActions)
        actionTableView.reloadData()
    }
    @IBOutlet weak var actionFreqLabel: UILabel!
    @IBAction func weekdayButton(_ sender: UIButton) {
        showWeekdayActionSheet()
    }
    @IBOutlet weak var weekdayLabel: UIButton!
    //变量
    var newPlan = Plan.init(title: "default", groups: 7, nums: 15, weekday: Weekday.Monday)
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
        actionTableView.dataSource = self
        actionTableView.delegate = self
    }
    //Alert
    func showWeekdayActionSheet(){
        let weekdaySelectActionSheet = UIAlertController.init(title: "Weekday", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for i in 1...7{
            let newAction = UIAlertAction.init(title: convertToWeekday(wd: i).fullString, style: UIAlertAction.Style.default) { (action:UIAlertAction) in
                self.newPlan.weekday = convertToWeekday(wd: i)
                self.weekdayLabel.titleLabel?.text = self.newPlan.weekday.fullString
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
}

class actionTableViewCell:UITableViewCell{
    @IBOutlet weak var actionName: UILabel!
    @IBOutlet weak var actionFreq: UILabel!
}
