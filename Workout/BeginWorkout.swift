//
//  BeginWorkout.swift
//  Workout
//
//  Created by francis on 2019/2/20.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit
class BeginWorkour: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //控件
    @IBOutlet weak var planTableView: UITableView!
    @IBAction func planEdit(_ sender: UIBarButtonItem) {
    }
    @IBAction func addPlan(_ sender: UIBarButtonItem) {
    }
    //变量
    var plans:[Plan] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView代理
        planTableView.delegate = self
        planTableView.dataSource = self
        //
    }
    //dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plans.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plan") as! planViewCell
        let plan = plans[indexPath.row]
        cell.planArch.text = "\(plan.archievs.count) Arch."
        cell.planTitle.text = plan.title
        cell.planWeekday.text = plan.weekday.short
        cell.planFreq.text = "\(plan.actionsInPlan.count) Actions"
        return cell
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
