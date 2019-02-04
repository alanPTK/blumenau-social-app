import UIKit
import MessageUI

class Utils {

    static var shared: Utils = Utils()
    
    /* Create a Date object with the components */
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
    
    /* Resize the text view accordingly to its size */
    @discardableResult
    func resizeTextView(textView: UITextView) -> CGSize {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        return textView.frame.size
    }
    
    func callPhoneNumber(phoneNumber: String) {
        if let number = URL(string: "tel://" + phoneNumber) {
            UIApplication.shared.open(number)
        }
    }
    
    func openLocation(address: String) {
        let location = String(format: "http://maps.apple.com/?address=%@", address)
        
        if let locationURL = URL(string: location) {
            UIApplication.shared.open(locationURL)
        }
    }
    
}
