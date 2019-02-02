import UIKit
import IHKeyboardAvoiding

class InitialProfileViewController: UIViewController {

    @IBOutlet weak var lbNameAndAge: UILabel!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    var views: [UIView] = []
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeyboardAvoiding.avoidingView = tfName
        KeyboardAvoiding.avoidingView = tfAge
        
        tvInfo.alpha = 0
        lbNameAndAge.alpha = 0
        tfName.alpha = 0
        tfAge.alpha = 0
        
        views.append(tvInfo)
        views.append(lbNameAndAge)
        views.append(tfName)
        views.append(tfAge)
        
        changeAlpha(view: views.first!)
        
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("Welcome to Blumenau Social", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        tfName.text = Preferences.shared.userName
        if Preferences.shared.userAge > 0 {
            tfAge.text = String(format: "%d", Preferences.shared.userAge)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNextProfileInfo" {
            if (tfName.text?.isEmpty)! {
                showMissingFields(field: NSLocalizedString("Please, fill your name before continuing", comment: ""))
            } else {
                Preferences.shared.userName = tfName.text!
            }
            
            if (tfAge.text?.isEmpty)! {
                showMissingFields(field: NSLocalizedString("Please, fill your age before continuing", comment: ""))
            } else {
                Preferences.shared.userAge = Int(tfAge.text!)!
            }
        }
    }
    
    func showMissingFields(field: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: field, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func changeAlpha(view: UIView) {
            UIView.animate(withDuration: 0.7, animations: {
                view.alpha = 1
            }) {(finished) in
                self.currentIndex += 1
                if self.currentIndex < self.views.count {
                    self.changeAlpha(view: self.views[self.currentIndex])
                }
            }
        }

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
