import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    /* Show the email creation screen with the information in the parameters */
    func sendEmailTo(recipients: [String], withSubject subject: String, message: String) {
        if !MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("We can't send the email. Please, check if you have an email configured in your settings.", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)

            alertController.addAction(okAction)

            present(alertController, animated: true, completion: nil)
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
