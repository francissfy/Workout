//
//  workoutCalendar.swift
//  Workout
//
//  Created by francis on 2019/2/14.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import UIKit


class workoutCalendarViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate{
    //组件
    @IBOutlet weak var workoutTableView: UITableView!
    @IBOutlet weak var workoutCalendarView: UICollectionView!
    @IBAction func preMonth(_ sender: Any) {
        preMonth()
    }
    @IBAction func nextMonth(_ sender: Any) {
        nextMonth()
    }
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var editHistory: UIBarButtonItem!
    //数据
    let today = Date.init()
    var year:Int = 2019
    var monthCursor:Date = Date.init(){
        didSet{
            workoutCalendarView.reloadData()
        }
    }
    var month :Int = 02{
        didSet{
            monthLabel.text = "\(year)年\(month)月"
            let dateDF = DateFormatter.init()
            dateDF.dateFormat = "yyyyMM"
            let dateStr = String(format: "%04d%02d", year,month)
            monthCursor = dateDF.date(from: dateStr)!
        }
    }
    var workoutData = [DailyWorkout]()
    var workoutDay = DailyWorkout.init(date: Date.init(), workouts: nil)
    var calendar = Calendar.current
    //按钮动作
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //workoutTableView.delegate = self
        //workoutTableView.dataSource = self
        workoutCalendarView.dataSource = self
        workoutCalendarView.delegate = self
        //更正init错误
        month = 2
        //
        
    }
    //日历CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth(day: monthCursor)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutCalendarViewCell", for: indexPath) as! workoutCalendarViewCell
        let cellDate = dayInMonth(day: monthCursor, index: indexPath)
        if(cellDate == 0){
            collectionCell.dateBackground.isHighlighted = false
            collectionCell.date.text = nil
        }else{
            collectionCell.dateBackground.isHighlighted = false
            collectionCell.date.text = String(cellDate)
        }
        return collectionCell as UICollectionViewCell
    }
    //每天的锻炼 TableViewDateSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "workoutTableViewCell") as! workoutTableViewCell
        let workoutItem = workoutDay.workouts[indexPath.row]
        let timeStr = workoutItem.workoutTimeString()
        cell.startTime.text = timeStr.startTime
        cell.endTime.text = timeStr.endTime
        cell.workoutDuration.text = timeStr.duration
        cell.workoutType.text = workoutItem.workoutTypeString()
        cell.workoutCount.text = "x\(workoutItem.workoutCount)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutDay.workouts.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //设置白色状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{ return UIStatusBarStyle.lightContent }
    }
    //日历计算
    func daysInMonth(day:Date)->Int{
        //let calendar = Calendar.current
        //let days = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: day)!.endIndex-1
        return 42
    }
    func dayInMonth(day:Date,index:IndexPath)->Int{
        let calendar = Calendar.current
        let firstWeekDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: day)!
        print(firstWeekDay)
        let totalDays = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: day)!.endIndex-1
        if(index.item<=totalDays+firstWeekDay-1 && index.item>=firstWeekDay-1){return index.item-firstWeekDay+2}else{return 0}
    }
    func nextMonth(){
        month = month>11 ? 1:month+1
        year = month>11 ? year+1:year
    }
    func preMonth(){
        month = month==1 ? 12:month-1
        year = month==1 ? year-1:year
    }
    //
}

class workoutTableViewCell:UITableViewCell{
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var workoutType: UILabel!
    @IBOutlet weak var workoutCount: UILabel!
    @IBOutlet weak var workoutDuration: UILabel!
}
class workoutCalendarViewCell:UICollectionViewCell{
    @IBOutlet weak var dateBackground: UIImageView!
    @IBOutlet weak var date: UILabel!
}
