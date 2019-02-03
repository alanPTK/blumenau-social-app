import UIKit

class Utils {

    static var shared: Utils = Utils()
    
    func createDateWithValues(day: Int, month: Int, year: Int, hour: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.timeZone = TimeZone(abbreviation: "BRT")
        
        let userCalendar = Calendar.current
        let date = userCalendar.date(from: dateComponents)
        
        return date!
    }
    
}
