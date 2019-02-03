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
    var selectedDays: [Component] = []
    var selectedPeriods: [Component] = []
    
    var userSelectedDays: [Int] = []
    var userSelectedPeriods: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMonday.layer.borderWidth = 1.0
        vMonday.layer.borderColor = UIColor.titleColor().cgColor
        vMonday.layer.cornerRadius = 8
        vMonday.alpha = 0.5
        vMonday.tag = 0
        lbMonday.textColor = UIColor.titleColor()
        lbMonday.isUserInteractionEnabled = true
        lbMonday.tag = 0
        selectedDays.append(Component(container: vMonday, label: lbMonday))
        
        vTuesday.layer.borderWidth = 1.0
        vTuesday.layer.borderColor = UIColor.titleColor().cgColor
        vTuesday.layer.cornerRadius = 8
        vTuesday.alpha = 0.5
        vTuesday.tag = 1
        lbTuesday.textColor = UIColor.descColor()
        lbTuesday.isUserInteractionEnabled = true
        lbTuesday.tag = 1
        selectedDays.append(Component(container: vTuesday, label: lbTuesday))
        
        vWednesday.layer.borderWidth = 1.0
        vWednesday.layer.borderColor = UIColor.titleColor().cgColor
        vWednesday.layer.cornerRadius = 8
        vWednesday.alpha = 0.5
        vWednesday.tag = 2
        lbWednesday.textColor = UIColor.descColor()
        lbWednesday.isUserInteractionEnabled = true
        lbWednesday.tag = 2
        selectedDays.append(Component(container: vWednesday, label: lbWednesday))
        
        vThursday.layer.borderWidth = 1.0
        vThursday.layer.borderColor = UIColor.titleColor().cgColor
        vThursday.layer.cornerRadius = 8
        vThursday.alpha = 0.5
        vThursday.tag = 3
        lbThursday.textColor = UIColor.descColor()
        lbThursday.isUserInteractionEnabled = true
        lbThursday.tag = 3
        selectedDays.append(Component(container: vThursday, label: lbThursday))
        
        vFriday.layer.borderWidth = 1.0
        vFriday.layer.borderColor = UIColor.titleColor().cgColor
        vFriday.layer.cornerRadius = 8
        vFriday.alpha = 0.5
        vFriday.tag = 4
        lbFriday.textColor = UIColor.descColor()
        lbFriday.isUserInteractionEnabled = true
        lbFriday.tag = 4
        selectedDays.append(Component(container: vFriday, label: lbFriday))
        
        vSaturday.layer.borderWidth = 1.0
        vSaturday.layer.borderColor = UIColor.titleColor().cgColor
        vSaturday.layer.cornerRadius = 8
        vSaturday.alpha = 0.5
        vSaturday.tag = 5
        lbSaturday.textColor = UIColor.descColor()
        lbSaturday.isUserInteractionEnabled = true
        lbSaturday.tag = 5
        selectedDays.append(Component(container: vSaturday, label: lbSaturday))
        
        vSunday.layer.borderWidth = 1.0
        vSunday.layer.borderColor = UIColor.titleColor().cgColor
        vSunday.layer.cornerRadius = 8
        vSunday.alpha = 0.5
        vSunday.tag = 6
        lbSunday.textColor = UIColor.descColor()
        lbSunday.isUserInteractionEnabled = true
        lbSunday.tag = 6
        selectedDays.append(Component(container: vSunday, label: lbSunday))
        
        vMorning.layer.borderWidth = 1.0
        vMorning.layer.borderColor = UIColor.titleColor().cgColor
        vMorning.layer.cornerRadius = 8
        vMorning.alpha = 0.5
        vMorning.tag = 0
        lbMorning.textColor = UIColor.descColor()
        lbMorning.isUserInteractionEnabled = true
        lbMorning.tag = 0
        selectedPeriods.append(Component(container: vMorning, label: lbMorning))
        
        vAfternoon.layer.borderWidth = 1.0
        vAfternoon.layer.borderColor = UIColor.titleColor().cgColor
        vAfternoon.layer.cornerRadius = 8
        vAfternoon.alpha = 0.5
        vAfternoon.tag = 1
        lbAfternoon.textColor = UIColor.descColor()
        lbAfternoon.isUserInteractionEnabled = true
        lbAfternoon.tag = 1
        selectedPeriods.append(Component(container: vAfternoon, label: lbAfternoon))
        
        vNight.layer.borderWidth = 1.0
        vNight.layer.borderColor = UIColor.titleColor().cgColor
        vNight.layer.cornerRadius = 8
        vNight.alpha = 0.5
        vNight.tag = 2
        lbNight.textColor = UIColor.descColor()
        lbNight.isUserInteractionEnabled = true
        lbNight.tag = 2
        selectedPeriods.append(Component(container: vNight, label: lbNight))
        
        for day in selectedDays {
            let touchDay = UITapGestureRecognizer(target: self, action: #selector(selectDay))
            day.label?.addGestureRecognizer(touchDay)
        }
        
        for period in selectedPeriods {
            let touchPeriod = UITapGestureRecognizer(target: self, action: #selector(selectPeriod))
            period.label?.addGestureRecognizer(touchPeriod)
        }
        
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("What is your availability ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        for day in selectedDays {
            if Preferences.shared.userDays.firstIndex(of: (day.container?.tag)!) != nil {
                day.container?.alpha = 1.0
            }
        }
        
        for period in selectedPeriods {
            if Preferences.shared.userPeriods.firstIndex(of: (period.container?.tag)!) != nil {
                period.container?.alpha = 1.0
            }
        }
        
        userSelectedDays = Preferences.shared.userDays
                
        userSelectedPeriods = Preferences.shared.userPeriods
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileInterests" {
            if userSelectedDays.count == 0 || userSelectedPeriods.count == 0 {
                showMissingAvailability()
            } else {
                Preferences.shared.userDays = userSelectedDays
                Preferences.shared.userPeriods = userSelectedPeriods
            }
        }
    }
    
    func showMissingAvailability() {
        var message = ""
        
        if userSelectedDays.count == 0 {
            message = NSLocalizedString("Please, select at least a day before continuing", comment: "")
        } else {
            message = NSLocalizedString("Please, select at least a period of the day before continuing", comment: "")
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
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

}
