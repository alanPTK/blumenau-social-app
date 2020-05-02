import UIKit

struct Component {
    var container: UIView?
    var label: UILabel?
}

class ProfileAvailabilityViewController: UIViewController {

    @IBOutlet weak var vMonday: UIView!
    @IBOutlet weak var vTuesday: UIView!
    @IBOutlet weak var vWednesday: UIView!
    @IBOutlet weak var vThursday: UIView!
    @IBOutlet weak var vFriday: UIView!
    @IBOutlet weak var vSaturday: UIView!
    @IBOutlet weak var vSunday: UIView!
    @IBOutlet weak var vMorning: UIView!
    @IBOutlet weak var vAfternoon: UIView!
    @IBOutlet weak var vNight: UIView!
    @IBOutlet weak var lbMonday: UILabel!
    @IBOutlet weak var lbTuesday: UILabel!
    @IBOutlet weak var lbWednesday: UILabel!
    @IBOutlet weak var lbThursday: UILabel!
    @IBOutlet weak var lbFriday: UILabel!
    @IBOutlet weak var lbSaturday: UILabel!
    @IBOutlet weak var lbSunday: UILabel!    
    @IBOutlet weak var lbMorning: UILabel!
    @IBOutlet weak var lbAfternoon: UILabel!
    @IBOutlet weak var lbNight: UILabel!
    @IBOutlet weak var vAll: UIView!
    @IBOutlet weak var lbAll: UILabel!
    
    private var selectedDays: [Component] = []
    private var selectedPeriods: [Component] = []
    
    private var userSelectedDays: [Int] = []
    private var userSelectedPeriods: [Int] = []
    
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view and configure the visual components for days and periods */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDays.append(Component(container: vMonday, label: lbMonday))
        selectedDays.append(Component(container: vTuesday, label: lbTuesday))
        selectedDays.append(Component(container: vWednesday, label: lbWednesday))
        selectedDays.append(Component(container: vThursday, label: lbThursday))
        selectedDays.append(Component(container: vFriday, label: lbFriday))
        selectedDays.append(Component(container: vSaturday, label: lbSaturday))
        selectedDays.append(Component(container: vSunday, label: lbSunday))
        
        selectedPeriods.append(Component(container: vMorning, label: lbMorning))
        selectedPeriods.append(Component(container: vAfternoon, label: lbAfternoon))
        selectedPeriods.append(Component(container: vNight, label: lbNight))
        
        var index = 0
        for dayComponent in selectedDays {
            dayComponent.container?.layer.borderWidth = 1.0
            dayComponent.container?.layer.borderColor = UIColor.titleColor().cgColor
            dayComponent.container?.layer.cornerRadius = 8
            dayComponent.container?.alpha = 0.5
            dayComponent.container?.tag = index
            dayComponent.label?.textColor = UIColor.titleColor()
            dayComponent.label?.isUserInteractionEnabled = true
            dayComponent.label?.tag = index
            
            let touchDay = UITapGestureRecognizer(target: self, action: #selector(selectDay))
            dayComponent.label?.addGestureRecognizer(touchDay)
            
            if preferences.userDays.firstIndex(of: (dayComponent.container?.tag)!) != nil {
                dayComponent.container?.alpha = 1.0
            }
            
            index+=1
        }
        
        index = 0
        for periodComponent in selectedPeriods {
            periodComponent.container?.layer.borderWidth = 1.0
            periodComponent.container?.layer.borderColor = UIColor.titleColor().cgColor
            periodComponent.container?.layer.cornerRadius = 8
            periodComponent.container?.alpha = 0.5
            periodComponent.container?.tag = index
            periodComponent.label?.textColor = UIColor.titleColor()
            periodComponent.label?.isUserInteractionEnabled = true
            periodComponent.label?.tag = index
            
            let touchPeriod = UITapGestureRecognizer(target: self, action: #selector(selectPeriod))
            periodComponent.label?.addGestureRecognizer(touchPeriod)
            
            if preferences.userPeriods.firstIndex(of: (periodComponent.container?.tag)!) != nil {
                periodComponent.container?.alpha = 1.0
            }
            
            index+=1
        }
        
        vAll.tag = 0
        vAll.layer.borderWidth = 1.0
        vAll.layer.borderColor = UIColor.titleColor().cgColor
        vAll.layer.cornerRadius = 8
        vAll.alpha = 0.5
        
        lbAll.textColor = UIColor.titleColor()
        lbAll.isUserInteractionEnabled = true
        lbAll.tag = 0
        
        let touchAllOption = UITapGestureRecognizer(target: self, action: #selector(touchAll))
        lbAll.addGestureRecognizer(touchAllOption)
        
        userSelectedDays = preferences.userDays
        userSelectedPeriods = preferences.userPeriods
        
        setupView()
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("What is your availability ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setStatusBarBackgroundColor(UIColor.backgroundColor())
    }
    
    /* Go to the next view */
    @IBAction func showProfileInterests(_ sender: Any) {
        if availabilityIsSelected() {
            performSegue(withIdentifier: "showProfileInterests", sender: nil)
        } else {
            showMissingAvailability()
        }
    }
    
    /* Before going to the next view, check if the days and periods are filled and warn the user if not */
    func availabilityIsSelected() -> Bool {
        if userSelectedDays.isEmpty || userSelectedPeriods.isEmpty {
            return false
        } else {
            preferences.userDays = userSelectedDays
            preferences.userPeriods = userSelectedPeriods
            
            return true
        }
    }
    
    /* Show alert message if the days and periods are not filled  */
    func showMissingAvailability() {
        var message = ""
        
        if userSelectedDays.isEmpty {
            message = NSLocalizedString("Please, select at least a day before continuing", comment: "")
        } else {
            message = NSLocalizedString("Please, select at least a period of the day before continuing", comment: "")
        }
                
        Utils.shared.showDefaultAlertWithMessage(message: message, viewController: self)
    }
    
    @objc func touchAll(tapGesture: UITapGestureRecognizer) {
        let shouldSelect = lbAll.tag == 0 ? true : false
        lbAll.tag = shouldSelect ? 1 : 0
        
        if shouldSelect {
            vAll.alpha = 1
        } else {
            vAll.alpha = 0.5
        }
                
        for selectedDay in selectedDays {
            let tag = selectedDay.label?.tag
            if shouldSelect {
                selectedDay.container?.alpha = 1
                
                userSelectedDays.append(tag ?? 0)
            } else {
                selectedDay.container?.alpha = 0.5
                
                let index = userSelectedDays.firstIndex(of: tag ?? 0)
                userSelectedDays.remove(at: index!)
            }
        }
        
        for selectedPeriods in selectedPeriods {
            let tag = selectedPeriods.label?.tag
            
            if shouldSelect {
                selectedPeriods.container?.alpha = 1
                
                userSelectedPeriods.append(tag ?? 0)
            } else {
                selectedPeriods.container?.alpha = 0.5
                
                let index = userSelectedPeriods.firstIndex(of: tag ?? 0)
                userSelectedPeriods.remove(at: index!)
            }
        }
    }
    
    /* When the user touches a day component */
    @objc func selectDay(tapGesture: UITapGestureRecognizer) {
        let view = tapGesture.view
        
        if (view?.superview?.alpha)! < CGFloat(1.0) {
            view?.superview?.alpha = 1
            
            userSelectedDays.append((view?.tag)!)
        } else {
            view?.superview?.alpha = 0.5
            
            let index = userSelectedDays.firstIndex(of: (view?.tag)!)
            userSelectedDays.remove(at: index!)
        }
    }
    
    /* When the user touches a period component */
    @objc func selectPeriod(tapGesture: UITapGestureRecognizer) {
        let view = tapGesture.view
        
        if (view?.superview?.alpha)! < CGFloat(1.0) {
            view?.superview?.alpha = 1
            
            userSelectedPeriods.append((view?.tag)!)
        } else {
            view?.superview?.alpha = 0.5
            
            let index = userSelectedPeriods.firstIndex(of: (view?.tag)!)
            userSelectedPeriods.remove(at: index!)
        }
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }

}
