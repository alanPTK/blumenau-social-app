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
    
    func applyBlurTo(image: UIImage) -> UIImage {
        if let imageToBlur = image.cgImage {
            let radius: CGFloat = 20
            let context = CIContext(options: nil)
            let inputImage = CIImage(cgImage: imageToBlur)
            let filter = CIFilter(name: "CIGaussianBlur")
            
            filter?.setValue(inputImage, forKey: kCIInputImageKey)
            filter?.setValue(20, forKey: kCIInputRadiusKey)
            
            let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
            let rect = CGRect(x: radius * 2, y: radius * 2, width: image.size.width - radius * 4, height: image.size.height - radius * 4)
            let cgImage = context.createCGImage(result, from: rect)
            let returnImage = UIImage(cgImage: cgImage!)
            
            return returnImage
        }
        
        return UIImage(named: "initial")!
    }
    
    func showDefaultAlertWithMessage(message: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
