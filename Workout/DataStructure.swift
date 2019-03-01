//
//  DataStructure.swift
//  Workout
//
//  Created by francis on 2019/2/14.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
import CoreData
enum WorkoutType{
    case PushUp
    case Running
    case SitUp
}
enum Weekday:Int{
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    var short:String{
        get{
            var str = ""
            switch self {
            case .Sunday:
                str = "Sun"
            case .Monday:
                str = "Mon"
            case .Tuesday:
                str = "Tue"
            case .Wednesday:
                str = "Wed"
            case .Thursday:
                str = "Thur"
            case .Friday:
                str = "Fri"
            case .Saturday:
                str = "Sat"
            }
            return str
        }
    }
    var fullString:String{
        get{
            var str = ""
            switch self {
            case .Sunday:
                str = "Sunday"
            case .Monday:
                str = "Monday"
            case .Tuesday:
                str = "Tuesday"
            case .Wednesday:
                str = "Wednesday"
            case .Thursday:
                str = "Thursday"
            case .Friday:
                str = "Friday"
            case .Saturday:
                str = "Saturday"
            }
            return str
        }
    }
}
func convertToWeekday(wd:Int)->Weekday{
    switch wd {
    case 1:
        return Weekday.Sunday
    case 2:
        return Weekday.Monday
    case 3:
        return Weekday.Tuesday
    case 4:
        return Weekday.Wednesday
    case 5:
        return Weekday.Thursday
    case 6:
        return Weekday.Friday
    case 7:
        return Weekday.Saturday
    default:
        return Weekday.Monday
    }
}
class cachePlanAndActions{
    static var cachedPlans:[Plans] = []
    static var cachedActions:[Actions] = []
}
class Workout {
    var startTime:Date
    var endTime:Date
    var workoutType:WorkoutType
    var workoutCount:Int
    init(startTime:Date,endTime:Date,workoutType:WorkoutType,count:Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.workoutType = workoutType
        self.workoutCount = count
    }
    //自定义方法
    func workoutTimeString()->(startTime:String,endTime:String,duration:String){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let startTimeStr = formatter.string(from: startTime)
        let endTimeStr = formatter.string(from: endTime)
        let durationInSecond = Int(round(endTime.timeIntervalSince(startTime)))
        var duration:String = ""
        if(durationInSecond < 60){duration = "1Min"}else
            if(durationInSecond<3600){duration = "\(Int(Double(durationInSecond)/60.0))min"}
            else{duration = "\(Int(Double(durationInSecond)/3600.0))Hr"}
        return (startTimeStr,endTimeStr,duration)
    }
    func workoutTypeString()->String{
        var typeStr:String = ""
        switch workoutType {
        case WorkoutType.PushUp:
            typeStr = "PushUp"
        case WorkoutType.Running:
            typeStr = "Running"
        case WorkoutType.SitUp:
            typeStr = "SitUp"
        }
        return typeStr
    }
}
class DailyWorkout{
    var workoutDate:Date
    var workouts:[Workout] = [Workout]()
    init(date:Date,workouts:[Workout]?) {
        self.workoutDate = date
        if(workouts != nil){self.workouts = workouts!}
    }
    func workoutDateStr()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.string(from: workoutDate)
    }
}
class SpecifiedAction{
    var action:Action
    var group:Int
    var num:Int
    var objectIDinCoreData:NSManagedObjectID?
    init(action:Action,group:Int,num:Int) {
        self.action = action
        self.group = group
        self.num = num
    }
}
class Action{
    var name :String
    var note:String
    var objectIDinCoreData:NSManagedObjectID?
    init(name:String,note:String) {
        self.name = name
        self.note = note
    }
}
class Plan{
    var weekday:Weekday = Weekday.Sunday//using the enum type of weekday in calendar
    var title = "Default Plan Name"
    var archievs:[Date] = []
    var actionsInPlan:[SpecifiedAction] = []
    var objectIDinCoreData:NSManagedObjectID?
    init(title:String,weekday:Weekday) {
        self.title = title
        self.weekday = weekday
    }
    func addAch(date:Date){
        archievs.append(date)
    }
    func addAction(action:[SpecifiedAction]){
        actionsInPlan.append(contentsOf: action)
    }
}
