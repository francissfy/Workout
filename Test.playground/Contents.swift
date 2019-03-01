import UIKit
import Foundation
import CoreData


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

func getDateWithWeekday(today:Date,weekday:Weekday)->String{
    let cal = Calendar.current
    let todayWeekday = cal.component(Calendar.Component.weekday, from: today)
    let expectDate = cal.date(byAdding: Calendar.Component.day, value: weekday.rawValue-todayWeekday, to: today)!
    let formatter = DateFormatter.init()
    formatter.dateFormat = "dd"
    return formatter.string(from: expectDate)
}

func getExpectDate(today:Date,expect:Weekday)->Int{
    let cal = Calendar.current
    let todayWeekday = cal.component(Calendar.Component.weekday, from: today)
    let todayDay = cal.component(Calendar.Component.day, from: today)
    let dayInMonth = cal.range(of: Calendar.Component.day, in: Calendar.Component.month, for: today)!.endIndex-1
    let expectDate = (todayDay + (expect.rawValue - todayWeekday))>dayInMonth ? todayDay + (expect.rawValue - todayWeekday)-dayInMonth : todayDay + (expect.rawValue - todayWeekday)
    return expectDate
}
getDateWithWeekday(today: Date.init(), weekday: Weekday.Saturday)
getExpectDate(today: Date.init(), expect: Weekday.Saturday)
