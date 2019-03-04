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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBAction func back(_ sender: Any) {
    }
    @IBAction func editHistory(_ sender: Any) {
        monthSet.append(monthSet.last!.nextMonth())
        workoutCalendarView.reloadData()
    }
    //数据
    let (startYear,startMonth) = (2019,2)
    let (endYear,endMonth) = (2019,6)
    let calendar = Calendar.current
    var monthSet:[YearMonth]  = []
    var collectionSize = CGSize.init(width: 343, height: 296)
    //@deprecated
    var workoutData = [DailyWorkout]()
    var workoutDay = DailyWorkout.init(date: Date.init(), workouts: nil)
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        //workoutTableView.delegate = self
        //workoutTableView.dataSource = self
        workoutCalendarView.dataSource = self
        workoutCalendarView.delegate = self
        //加载数据
        monthSet = range(startYear: startYear, startMonth: startMonth, endYear: endYear, endMonth: endMonth)
        //Flow layout configure
        flowLayout.sectionHeadersPinToVisibleBounds = true
        //
    }
    //日历CollectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! workoutCalendarViewSectionHeader
        let date = monthSet[indexPath.section]
        sectionHeader.sectionhHeader.text = "\(date.year)年\(date.month)月"
        return sectionHeader as UICollectionReusableView
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthSet.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let date = monthSet[indexPath.section]
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "workoutCalendarViewCell", for: indexPath) as! workoutCalendarViewCell
        let cellDate = dayInMonth(day: date.date, index: indexPath)
        if(cellDate == 0){
            collectionCell.isUserInteractionEnabled = false
            collectionCell.date.text = nil
        }else{
            collectionCell.isUserInteractionEnabled = true
            collectionCell.date.text = String(cellDate)
        }
        return collectionCell as UICollectionViewCell
    }
    //可更改
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    //增加月份
    func addMonthSection(){
        let endMonth = monthSet.last!
        monthSet.append(endMonth.nextMonth())
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
    func monthDescription(firstDate:Date)->(firstWeekDay:Int,totalDays:Int){
        let firstWeekDay = calendar.ordinality(of: Calendar.Component.weekday, in: Calendar.Component.weekOfMonth, for: firstDate)!
        let totalDays = calendar.range(of: Calendar.Component.day, in: Calendar.Component.month, for: firstDate)!.endIndex-1
        return (firstWeekDay,totalDays)
    }
    func dayInMonth(day:Date,index:IndexPath)->Int{
        let (firstWeekDay,totalDays) = monthDescription(firstDate: day)
        if(index.item<=totalDays+firstWeekDay-2 && index.item>=firstWeekDay-1){return index.item-firstWeekDay+2}else{return 0}
    }
}

class workoutCalendarViewSectionHeader:UICollectionReusableView{
    @IBOutlet weak var sectionhHeader: UILabel!
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
//
class YearMonth{
    var year:Int
    var month:Int
    init() {
        year = 2019
        month = 2
    }
    init(Year:Int,Month:Int) {
        self.month = Month
        self.year = Year
    }
    var date:Date{
        get{
            let calendar = Calendar.current
            var dateComponent = DateComponents()
            dateComponent.month = month
            dateComponent.year = year
            return calendar.date(from: dateComponent)!
        }
    }
    func toDate()->Date{
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = month
        dateComponent.year = year
        return calendar.date(from: dateComponent)!
    }
    func toDate(Year:Int,Month:Int)->Date{
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.month = Month
        dateComponent.year = Year
        return calendar.date(from: dateComponent)!
    }
    func preMonth()->YearMonth{
        let nY = month==1 ? year-1:year
        let nM = month==1 ? 12:month-1
        return YearMonth.init(Year: nY, Month: nM)
    }
    func nextMonth()->YearMonth{
        let nY = month==12 ? year+1:year
        let nM = month==12 ? 1:month+1
        return YearMonth.init(Year: nY, Month: nM)
    }
}
func range(startYear:Int,startMonth:Int,endYear:Int,endMonth:Int)->[YearMonth]{
    var iY = startYear
    var iM = startMonth
    var range:[YearMonth] = []
    while (iY,iM) != (endYear,endMonth) {
        range.append(YearMonth.init(Year: iY, Month: iM))
        iY = iM>11 ? iY+1:iY
        iM = iM>11 ? 1:iM+1
    }
    range.append(YearMonth.init(Year: endYear, Month: endMonth))
    return range
}
