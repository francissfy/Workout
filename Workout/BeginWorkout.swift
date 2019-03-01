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
class BeginWorkour: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //控件
    @IBOutlet weak var planTableView: UITableView!
    @IBAction func planEdit(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
    }
    //变量
    let today = Date.init()
    let formatter = DateFormatter.init()
    let todayWeekday = Calendar.current.component(Calendar.Component.weekday, from: Date.init())
    var fetchedPlans:[Plan] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView代理
        planTableView.delegate = self
        planTableView.dataSource = self
        //
        formatter.dateFormat = "dd"
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
                })
            do{try ctx.execute(asyncFetch)}catch{fatalError(error.localizedDescription)}
            DispatchQueue.main.async {
                self.planTableView.reloadData()
            }
        }
    }

}
class planViewCell:UITableViewCell{
    @IBOutlet weak var planDate: UILabel!
    @IBOutlet weak var planWeekday: UILabel!
    @IBOutlet weak var planTitle: UILabel!
    @IBOutlet weak var planFreq: UILabel!
    @IBOutlet weak var planArch: UILabel!
}
