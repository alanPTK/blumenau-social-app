import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    /* Show the email creation screen with the information in the parameters */
    func sendEmailTo(recipients: [String], withSubject subject: String, message: String) {
        if !MFMailComposeViewController.canSendMail() {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("We can't send the email. Please, check if you have an email configured in your settings.", comment: ""), viewController: self)            
        } else {
            let composeEmailViewController = MFMailComposeViewController()
            composeEmailViewController.mailComposeDelegate = self
            composeEmailViewController.setToRecipients(recipients)
            composeEmailViewController.setSubject(subject)
            composeEmailViewController.setMessageBody(message, isHTML: false)
            
            present(composeEmailViewController, animated: true, completion: nil)
        }
    }
    
    /* When the user closes the mail creation screen this method is called to dismiss the view */
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
