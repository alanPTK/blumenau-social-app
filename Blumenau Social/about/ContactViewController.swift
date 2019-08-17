import UIKit
import MessageUI

class ContactViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tvText: UITextView!
    @IBOutlet weak var btSend: UIButton!
    @IBOutlet weak var btInstagram: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    @IBOutlet weak var lbDeveloper: UILabel!
    @IBOutlet weak var lbDeveloperName: UILabel!
    @IBOutlet weak var lbArtist: UILabel!
    @IBOutlet weak var lbArtistName: UILabel!
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        lbDeveloperName.text = NSLocalizedString("Developer name", comment: "")
        lbDeveloper.text = NSLocalizedString("Developer", comment: "")
        
        lbArtistName.text = NSLocalizedString("Artist name", comment: "")
        lbArtist.text = NSLocalizedString("Artist", comment: "")
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        tvText.layer.cornerRadius = 8
        
        tfName.placeholder = NSLocalizedString("Your name", comment: "")
        tfName.delegate = self
        tfPhone.placeholder = NSLocalizedString("Your phone", comment: "")
        tfPhone.delegate = self
        tfEmail.placeholder = NSLocalizedString("Your email", comment: "")
        tfEmail.delegate = self
    }
    
    /* When the user touches the return button, go to the next text field */
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

    /* Show the email creation screen with the information from the fields */
    @IBAction func sendMail(_ sender: Any) {
        var body = ""
        guard let name = tfName.text, let email = tfEmail.text, let phone = tfPhone.text else {
            return
        }
        
        if name.isEmpty {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, fill your name.", comment: ""), viewController: self)
            return
        }
        
        if email.isEmpty {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, fill your email.", comment: ""), viewController: self)
            return
        }
        
        if phone.isEmpty {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, fill your phone.", comment: ""), viewController: self)
            return
        }
        
        if tvText.text.isEmpty {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, write something before sending the email.", comment: ""), viewController: self)
            return
        }
        
        let initialBody = String(format: "%@ - %@ - %@", name, email, phone)
        
        body.append(initialBody)
        body.append("\n \n")
        body.append(tvText.text)
        
        sendEmailTo(recipients: [email], withSubject: "", message: body)
    }            
    
    /* Go to the Facebook profile when the user touches the button */
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
    
    /* Go to the Instagram profile when the user touches the button */
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
    
    /* Go to the Linkedin profiles when the user touches the buttons */
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
}
