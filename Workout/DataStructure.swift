//
//  DataStructure.swift
//  Workout
//
//  Created by francis on 2019/2/14.
//  Copyright © 2019年 francis. All rights reserved.
//

import Foundation
enum WorkoutType{
    case PushUp
    case Running
    case SitUp
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
