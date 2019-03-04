//
//  BeginWorkout.swift
//  Workout
//
//  Created by francis on 2019/2/20.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class BeginWorkour: UIViewController, UITableViewDelegate,UITableViewDataSource {
    //控件
    @IBOutlet weak var planTableView: UITableView!
    @IBOutlet weak var planActionDetail: UITableView!
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var navEdit: UIBarButtonItem!
    @IBOutlet weak var navAdd: UIBarButtonItem!
    
    
    @IBAction func planEdit(_ sender: UIBarButtonItem) {
        if(sender.title == "Edit"){
            //implement edit action
        }else{
            moveBackToPlan()
        }
    }
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
        if(sender.title == "Add"){
            //implement add plan action
            performSegue(withIdentifier: "addPlan", sender: nil)
        }else{
            //implement stop or start action
        }
    }
    @IBOutlet weak var tabbar: UITabBarItem!
    @IBOutlet weak var bottomView: UIView!
    //变量
    var bottomSheetViewController:BottomSheetViewController? = nil
    let transactionTime = TimeInterval.init(0.4)
    let today = Date.init()
    let formatter = DateFormatter.init()
    let todayWeekday = Calendar.current.component(Calendar.Component.weekday, from: Date.init())
    var fetchedPlans:[Plan] = []
    var planActionController = planActionTableViewController()
    var screenWidth = CGFloat(375)
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView代理
        planTableView.delegate = self
        planTableView.dataSource = self
        planActionDetail.dataSource = planActionController
        planActionDetail.delegate = planActionController
        //
        formatter.dateFormat = "dd"
        //
        screenWidth = self.view.frame.width
        planActionDetail.transform = planActionDetail.transform.translatedBy(x: screenWidth, y: 0)
        //
        let tappedGesRecog = UITapGestureRecognizer.init(target: self, action: #selector(unFoldWidget))
        let sliderTapGesRecg = UITapGestureRecognizer.init(target: self, action: #selector(foldWidget))
        bottomSheetViewController!.tapView.addGestureRecognizer(tappedGesRecog)
        bottomSheetViewController!.slider.addGestureRecognizer(sliderTapGesRecg)
        bottomSheetViewController!.slider.alpha = 0
        //
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchAllPlans()
    }
    //dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedPlans.count
    }
    func getDateWithWeekday(today:Date,weekday:Weekday)->String{
        let cal = Calendar.current
        let todayWeekday = cal.component(Calendar.Component.weekday, from: today)
        let expectDate = cal.date(byAdding: Calendar.Component.day, value: weekday.rawValue-todayWeekday, to: today)!
        let formatter = DateFormatter.init()
        formatter.dateFormat = "dd"
        return formatter.string(from: expectDate)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plan") as! planViewCell
        let plan = fetchedPlans[indexPath.row]
        cell.planArch.text = "\(plan.archievs.count) Arch."
        cell.planTitle.text = plan.title
        cell.planWeekday.text = plan.weekday.short
        cell.planFreq.text = "\(plan.actionsInPlan.count) Actions"
        //
        let expectDate = Calendar.current.date(byAdding: Calendar.Component.day, value: plan.weekday.rawValue-todayWeekday, to: today)!
        cell.planDate.text = formatter.string(from: expectDate)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveToPlanActionDetail(selectedPlanRow: indexPath)
    }
    //
    func moveToPlanActionDetail(selectedPlanRow:IndexPath){
        navEdit.title = "Back"
        navTitle.title = "Actions"
        navAdd.title = "Stop"
        planActionController.actions = fetchedPlans[selectedPlanRow.row].actionsInPlan
        planActionDetail.reloadData()
        UIView.animate(withDuration: TimeInterval(0.4)) {
            self.planTableView.transform = self.planTableView.transform.translatedBy(x: -self.screenWidth, y: 0)
            self.planActionDetail.transform = self.planActionDetail.transform.translatedBy(x: -self.screenWidth, y: 0)
        }
    }
    func moveBackToPlan(){
        navEdit.title = "Edit"
        navTitle.title = "Plan"
        navAdd.title = "Add"
        UIView.animate(withDuration: TimeInterval(0.4)) {
            self.planTableView.transform = self.planTableView.transform.translatedBy(x: self.screenWidth, y: 0)
            self.planActionDetail.transform = self.planActionDetail.transform.translatedBy(x: self.screenWidth, y: 0)
        }
    }
    //
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{ return UIStatusBarStyle.lightContent }
    }
    //
    func fetchAllPlans(){
        let coordinator = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        DispatchQueue.global().async {
            let ctx = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            ctx.persistentStoreCoordinator = coordinator
            let fetchRequest = NSFetchRequest<Plans>.init(entityName: "Plans")
            fetchRequest.returnsObjectsAsFaults = false
            fetchRequest.relationshipKeyPathsForPrefetching = ["SpecifiedActions"]
            let asyncFetch = NSAsynchronousFetchRequest.init(fetchRequest: fetchRequest, completionBlock: { (result:NSAsynchronousFetchResult<Plans>) in
                let allPlans = result.finalResult!
                self.fetchedPlans.removeAll()
                for plan in allPlans{
                    let newPlan = Plan.init(title: plan.name!, weekday: convertToWeekday(wd: Int(plan.weekday)))
                    for i in plan.specifiedaction!{
                        let specAction = i as! SpecifiedActions
                        let action = Action.init(name: specAction.action!.name!, note: specAction.action!.note!)
                        let newSpecAction = SpecifiedAction.init(action: action, group: Int(specAction.group), num: Int(specAction.num))
                        newPlan.actionsInPlan.append(newSpecAction)
                    }
                    self.fetchedPlans.append(newPlan)
                }
                DispatchQueue.main.async {
                    self.planTableView.reloadData()
                }
                })
            do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if(segue.identifier != nil && segue.identifier! == "BottomSheetSegue"){
            bottomSheetViewController = (segue.destination as! BottomSheetViewController)
        }
    }
    @objc func unFoldWidget(){
        self.bottomSheetViewController!.slider.isUserInteractionEnabled = true
        self.bottomSheetViewController!.tapView.isUserInteractionEnabled = false
        UIView.animate(withDuration: transactionTime) {
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: 0, y: CGFloat(-212))
            self.bottomSheetViewController!.slider.alpha = 1
        }
    }
    @objc func foldWidget(){
        self.bottomSheetViewController!.slider.isUserInteractionEnabled = false
        self.bottomSheetViewController!.tapView.isUserInteractionEnabled = true
        UIView.animate(withDuration: transactionTime) {
            self.bottomView.transform = self.bottomView.transform.translatedBy(x: 0, y: CGFloat(212))
            self.bottomSheetViewController!.slider.alpha = 0
        }
    }
    //
}
class planViewCell:UITableViewCell{
    @IBOutlet weak var planDate: UILabel!
    @IBOutlet weak var planWeekday: UILabel!
    @IBOutlet weak var planTitle: UILabel!
    @IBOutlet weak var planFreq: UILabel!
    @IBOutlet weak var planArch: UILabel!
}

class planActionTableViewController:UIViewController,UITableViewDataSource,UITableViewDelegate{
    var currentAction:Int = -1
    var actions:[SpecifiedAction] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planActionCell") as! planActionCell
        let specAction = actions[indexPath.row]
        cell.note.layer.cornerRadius = 8
        cell.name.text = specAction.action.name
        cell.preq.text = "\(specAction.group)X\(specAction.num)"
        cell.note.text = specAction.action.note
        return cell
    }
}

class planActionCell:UITableViewCell{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var preq: UILabel!
    @IBOutlet weak var note: UITextView!
}
