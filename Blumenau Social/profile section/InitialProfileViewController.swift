import UIKit

class InitialProfileViewController: UIViewController {

    @IBOutlet weak var lbNameAndAge: UILabel!
    @IBOutlet weak var tvInfo: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfName: UITextField!
    
    private var views: [UIView] = []
    private var currentIndex: Int = 0
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        views.append(tvInfo)
        views.append(lbNameAndAge)
        views.append(tfName)
        
        changeAlpha(view: views.first!)
        
        tfName.text = preferences.userName
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        tvInfo.alpha = 0
        lbNameAndAge.alpha = 0
        tfName.alpha = 0
        
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
                Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, fill your name before continuing", comment: ""), viewController: self)
                return
            } else {
                preferences.userName = tfName.text!
            }
        }
    }
    
    func checkFields() {
        
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
    
    /* When the user touches the return button, go to the next text field */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            view.endEditing(true)
        }
        
        return true
    }
    
}
