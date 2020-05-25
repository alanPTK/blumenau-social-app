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
        let formattedNumber = phoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        if let number = URL(string: "tel://" + formattedNumber) {
            UIApplication.shared.open(number)
        }
    }
    
    func openWhatsApp(phoneNumber: String) {
        var formattedNumber = phoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        formattedNumber = "55"+formattedNumber
        
        if let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(formattedNumber)") {
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }
    }
    
    func openLocation(address: String) {
        let location = String(format: "http://maps.apple.com/?address=%@", address)
        
        if let locationURL = URL(string: location) {
            UIApplication.shared.open(locationURL)
        }
    }
    
    func copyToPasteboard(string: String) {
        UIPasteboard.general.string = string                
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
    
    func showDefaultAlertWithMessage(message: String, viewController: UIViewController?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        if viewController == nil {
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        } else {
            viewController!.present(alertController, animated: true, completion: nil)
        }
    }
    
    func shouldSyncInformation(information: Int) -> Bool {
        let currentDate = Date()
        
        switch information {
            case Constants.INSTITUTIONS:
                if let institutionLastSync = Cache.shared.institutionLastSync {
                    let difference = Calendar.current.dateComponents([.day], from: institutionLastSync, to: currentDate)
                
                    return difference.day! >= 2
                } else {
                    return true
                }
            case Constants.FILTERS:
                if let filterLastSync = Cache.shared.filterLastSync {
                    let difference = Calendar.current.dateComponents([.day], from: filterLastSync, to: currentDate)
                
                    return difference.day! >= 2
                } else {
                    return true
                }
            default:
                break
            }
        
        return true
    }
}
