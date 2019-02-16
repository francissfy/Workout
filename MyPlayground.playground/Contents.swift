import Cocoa
import CoreFoundation
var dateCompo = DateComponents.init()
dateCompo.year = 2018
dateCompo.month = 11
let cal = Calendar.current
let date1 = cal.date(from: dateCompo)!
dateCompo.year = 2019
dateCompo.month = 2
let date2 = cal.date(from: dateCompo)!

