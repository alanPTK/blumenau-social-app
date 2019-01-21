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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMonday.layer.borderWidth = 1.0
        vMonday.layer.borderColor = UIColor.titleColor().cgColor
        vMonday.layer.cornerRadius = 8
        vMonday.alpha = 0.5
        lbMonday.textColor = UIColor.titleColor()
        lbMonday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vMonday, label: lbMonday))
        
        vTuesday.layer.borderWidth = 1.0
        vTuesday.layer.borderColor = UIColor.titleColor().cgColor
        vTuesday.layer.cornerRadius = 8
        vTuesday.alpha = 0.5
        lbTuesday.textColor = UIColor.descColor()
        lbTuesday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vTuesday, label: lbTuesday))
        
        vWednesday.layer.borderWidth = 1.0
        vWednesday.layer.borderColor = UIColor.titleColor().cgColor
        vWednesday.layer.cornerRadius = 8
        vWednesday.alpha = 0.5
        lbWednesday.textColor = UIColor.descColor()
        lbWednesday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vWednesday, label: lbWednesday))
        
        vThursday.layer.borderWidth = 1.0
        vThursday.layer.borderColor = UIColor.titleColor().cgColor
        vThursday.layer.cornerRadius = 8
        vThursday.alpha = 0.5
        lbThursday.textColor = UIColor.descColor()
        lbThursday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vThursday, label: lbThursday))
        
        vFriday.layer.borderWidth = 1.0
        vFriday.layer.borderColor = UIColor.titleColor().cgColor
        vFriday.layer.cornerRadius = 8
        vFriday.alpha = 0.5
        lbFriday.textColor = UIColor.descColor()
        lbFriday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vFriday, label: lbFriday))
        
        vSaturday.layer.borderWidth = 1.0
        vSaturday.layer.borderColor = UIColor.titleColor().cgColor
        vSaturday.layer.cornerRadius = 8
        vSaturday.alpha = 0.5
        lbSaturday.textColor = UIColor.descColor()
        lbSaturday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vSaturday, label: lbSaturday))
        
        vSunday.layer.borderWidth = 1.0
        vSunday.layer.borderColor = UIColor.titleColor().cgColor
        vSunday.layer.cornerRadius = 8
        vSunday.alpha = 0.5
        lbSunday.textColor = UIColor.descColor()
        lbSunday.isUserInteractionEnabled = true
        selectedDays.append(Component(container: vSunday, label: lbSunday))
        
        vMorning.layer.borderWidth = 1.0
        vMorning.layer.borderColor = UIColor.titleColor().cgColor
        vMorning.layer.cornerRadius = 8
        vMorning.alpha = 0.5
        lbMorning.textColor = UIColor.descColor()
        lbMorning.isUserInteractionEnabled = true
        selectedPeriods.append(Component(container: vMorning, label: lbMorning))
        
        vAfternoon.layer.borderWidth = 1.0
        vAfternoon.layer.borderColor = UIColor.titleColor().cgColor
        vAfternoon.layer.cornerRadius = 8
        vAfternoon.alpha = 0.5
        lbAfternoon.textColor = UIColor.descColor()
        lbAfternoon.isUserInteractionEnabled = true
        selectedPeriods.append(Component(container: vAfternoon, label: lbAfternoon))
        
        vNight.layer.borderWidth = 1.0
        vNight.layer.borderColor = UIColor.titleColor().cgColor
        vNight.layer.cornerRadius = 8
        vNight.alpha = 0.5
        lbNight.textColor = UIColor.descColor()
        lbNight.isUserInteractionEnabled = true
        selectedPeriods.append(Component(container: vNight, label: lbNight))
        
        for day in selectedDays {
            let touchDay = UITapGestureRecognizer(target: self, action: #selector(selectDay))
            day.label?.addGestureRecognizer(touchDay)
        }
        
        for period in selectedPeriods {
            let touchPeriod = UITapGestureRecognizer(target: self, action: #selector(selectPeriod))
            period.label?.addGestureRecognizer(touchPeriod)
        }
    }
    
    @objc func selectDay(tapGesture: UITapGestureRecognizer) {
        let view = tapGesture.view
        
        if (view?.superview?.alpha)! < CGFloat(1.0) {
            view?.superview?.alpha = 1
        } else {
            view?.superview?.alpha = 0.5
        }
    }
    
    @objc func selectPeriod(tapGesture: UITapGestureRecognizer) {
        let view = tapGesture.view
        
        if (view?.superview?.alpha)! < CGFloat(1.0) {
            view?.superview?.alpha = 1
        } else {
            view?.superview?.alpha = 0.5
        }
    }

}
