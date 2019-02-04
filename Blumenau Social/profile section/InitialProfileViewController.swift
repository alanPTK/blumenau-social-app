import UIKit
import IHKeyboardAvoiding

class InitialProfileViewController: UIViewController {

    @IBOutlet weak var lbNameAndAge: UILabel!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    private var views: [UIView] = []
    private var currentIndex: Int = 0
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        KeyboardAvoiding.avoidingView = tfName
        KeyboardAvoiding.avoidingView = tfAge
        
        views.append(tvInfo)
        views.append(lbNameAndAge)
        views.append(tfName)
        views.append(tfAge)
        
        changeAlpha(view: views.first!)
        
        tfName.text = preferences.userName
        if preferences.userAge > 0 {
            tfAge.text = String(format: "%d", preferences.userAge)
        }
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        tvInfo.alpha = 0
        lbNameAndAge.alpha = 0
        tfName.alpha = 0
        tfAge.alpha = 0
        
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("Welcome to Blumenau Social", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    /* Before going to the next view, check and alert the user if the fields are missing */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextProfileInfo" {
            if (tfName.text?.isEmpty)! {
                showMissingFields(field: NSLocalizedString("Please, fill your name before continuing", comment: ""))
            } else {
                preferences.userName = tfName.text!
            }
            
            if (tfAge.text?.isEmpty)! {
                showMissingFields(field: NSLocalizedString("Please, fill your age before continuing", comment: ""))
            } else {
                preferences.userAge = Int(tfAge.text!)!
            }
        }
    }
    
    /* Alert the user if some of the fields are empty */
    func showMissingFields(field: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: field, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /* Alpha animation for the text fields */
    func changeAlpha(view: UIView) {
            UIView.animate(withDuration: 0.5, animations: {
                view.alpha = 1
            }) {(finished) in
                self.currentIndex += 1
                if self.currentIndex < self.views.count {
                    self.changeAlpha(view: self.views[self.currentIndex])
                }
            }
        }

    /* Dismiss the view if the user don't want to create a profile */
    @IBAction func cancelProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension InitialProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfAge.becomeFirstResponder()
        }
        
        if textField == tfAge {
            view.endEditing(true)
        }
        
        return true
    }
    
}
