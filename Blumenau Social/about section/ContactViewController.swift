import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvText: UITextView!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var btInstagram: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    @IBOutlet weak var lbDeveloperName: UILabel!
    @IBOutlet weak var lbArtistName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvText.layer.cornerRadius = 8
        
        tfName.placeholder = NSLocalizedString("Your name", comment: "")
        tfName.delegate = self
        tfPhone.placeholder = NSLocalizedString("Your phone", comment: "")
        tfPhone.delegate = self
        tfEmail.placeholder = NSLocalizedString("Your email", comment: "")
        tfEmail.delegate = self
        
        lbDeveloperName.text = NSLocalizedString("Developer", comment: "")
        lbArtistName.text = NSLocalizedString("Artist", comment: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfPhone.becomeFirstResponder()
        }
        
        if textField == tfPhone {
            tfEmail.becomeFirstResponder()
        }
        
        if textField == tfEmail {
            tvText.becomeFirstResponder()
        }
        
        return true
    }

    @IBAction func sendMail(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("We can't send the email. Please, check if you have an email configured in your settings.", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            var body = ""
            guard let name = tfName.text, let email = tfEmail.text, let phone = tfPhone.text else {
                return
            }
            
            if name.isEmpty {
                showAlertControllerWithMessage(message: NSLocalizedString("Please, fill your name.", comment: ""))
            }
            
            if email.isEmpty {
                showAlertControllerWithMessage(message: NSLocalizedString("Please, fill your email.", comment: ""))
            }
            
            if phone.isEmpty {
                showAlertControllerWithMessage(message: NSLocalizedString("Please, fill your phone.", comment: ""))
            }
            
            body.append(name)
            body.append("\n")
            body.append(email)
            body.append("\n")
            body.append(phone)
            body.append("\n")
            body.append(tvText.text)
            
            let composeEmailViewController = MFMailComposeViewController()
            
            composeEmailViewController.mailComposeDelegate = self
            composeEmailViewController.setToRecipients([Constants.CONTACT_EMAIL])
            composeEmailViewController.setSubject(NSLocalizedString("Contact via app", comment: ""))
            composeEmailViewController.setMessageBody(body, isHTML: false)
            
            present(composeEmailViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToFacebook(_ sender: Any) {
        let appURL = URL(string: Constants.FACEBOOK_APP_URL)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: Constants.FACEBOOK_WEB_URL)!
            application.open(webURL)
        }
    }
    
    @IBAction func goToInstagram(_ sender: Any) {
        let appURL = URL(string: Constants.INSTAGRAM_APP_URL)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = URL(string: Constants.INSTAGRAM_WEB_URL)!
            application.open(webURL)
        }
    }
    
    @IBAction func goToLinkedin(_ sender: UIButton) {
        var appURL: URL?
        var webURL: URL?
        
        if sender.tag == 0 {
            appURL = URL(string: Constants.ALAN_LINKEDIN_APP_URL)!
            webURL = URL(string: Constants.ALAN_LINKEDIN_WEB_URL)!
        } else {
            appURL = URL(string: Constants.THIAGO_LINKEDIN_APP_URL)!
            webURL = URL(string: Constants.THIAGO_LINKEDIN_WEB_URL)!
        }
        
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL!) {
            application.open(appURL!)
        } else {
            application.open(webURL!)
        }
    }
    
    func showAlertControllerWithMessage(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
