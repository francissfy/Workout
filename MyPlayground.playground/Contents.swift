import Cocoa
import CoreFoundation
class YearMonth{
    var year:Int
    var month:Int
    init() {
        year = 2019
        month = 2
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
    func preMonth()->Date{
        let nY = month==1 ? year-1:year
        let nM = month==1 ? 12:month-1
        return toDate(Year: nY, Month: nM)
    }
    func nextMonth()->Date{
        let nY = month==12 ? year+1:year
        let nM = month==12 ? 1:month+1
        return toDate(Year: nY, Month: nM)
    }
}
let a = YearMonth()
let b = a.preMonth()
b
a.date


