import UIKit
import MapKit
import EasyTipView
import RealmSwift

class EventViewController: UIViewController {
    
    @IBOutlet weak var btOpenMaps: UIButton!
    @IBOutlet weak var btShare: UIButton!
    @IBOutlet weak var btConfirmAttendance: UIButton!
    @IBOutlet weak var tvEventDescription: UITextView!
    @IBOutlet weak var lbEventTime: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivEventIcon: UIImageView!
    @IBOutlet weak var lbEventDate: UILabel!
    @IBOutlet weak var lbEventAddress: UILabel!
    @IBOutlet weak var lbLocationTitle: UILabel!
    @IBOutlet weak var lbShareTitle: UILabel!
    @IBOutlet weak var lbAttendanceTitle: UILabel!
    @IBOutlet weak var mvEventLocation: MKMapView!
    @IBOutlet weak var lcEvenDescriptionHeight: NSLayoutConstraint!
    
    var selectedEvent: InstitutionEvent?
    private let userPreferences = Preferences.shared
    private var userEvent: UserEvent?
    private var presenter: EventPresenter?
    
    /* Initialize all the necessary information for the view and load the information for the selected event */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EventPresenter(delegate: self)
        
        setupView()
        
        lbTitle.text = selectedEvent?.title
        lbEventDate.text = selectedEvent?.date
        lbEventAddress.text = selectedEvent?.address
        lbEventTime.text = selectedEvent?.time
        tvEventDescription.text = selectedEvent?.desc
    }
    
    /* Initialize the view components */
    func setupView() {
        tvEventDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /* Show the event location on the map and on the first time, show a tip to the user */
    override func viewWillAppear(_ animated: Bool) {
        presenter?.getEventLocationOnMap(event: selectedEvent!, map: mvEventLocation)
        
        if !userPreferences.eventRouteTipViewWasShown {
            var preferences = EasyTipView.Preferences()
            preferences.drawing.foregroundColor = UIColor.titleColor()
            preferences.drawing.backgroundColor = UIColor.white
            preferences.drawing.arrowPosition = .top
            preferences.animating.showDuration = 1.5
            
            let tipView = EasyTipView(text: NSLocalizedString("Touch here to open the Maps application and get routes to the event.", comment: ""), preferences: preferences, delegate: nil)
            
            tipView.show(animated: true, forView: btOpenMaps, withinSuperview: self.view)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2500)) {
                tipView.dismiss()
            }
            
            userPreferences.eventRouteTipViewWasShown = true
        }
        
        presenter?.getUserEvent(event: selectedEvent!)
    }
    
    /* Close the view when the user touches the button */
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /* Share the event information when the user touches the button */
    @IBAction func share(_ sender: Any) {
        var toShare: Array<Any> = []
        
        toShare.append(lbTitle.text ?? "")
        toShare.append("\n")
        toShare.append(lbEventAddress.text ?? "")
        toShare.append("\n")
        toShare.append(lbEventDate.text ?? "")
        toShare.append("\n")
        toShare.append(lbEventTime.text ?? "")
        toShare.append("\n")
        toShare.append(tvEventDescription.text)
        
        let activityViewController = UIActivityViewController(activityItems: toShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.excludedActivityTypes = [.addToReadingList, .airDrop, .assignToContact, .copyToPasteboard, .openInIBooks, .postToFlickr, .postToTencentWeibo, .postToVimeo, .print, .saveToCameraRoll]
        activityViewController.completionWithItemsHandler = {activity, success, items, error in
            if success {
                activityViewController.dismiss(animated: true, completion: nil)
            }
        }
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    /* When the user touches the button, confirm or desconfirm the its attendance */
    @IBAction func confirmAttendance(_ sender: Any) {
        guard let eventFromUser = userEvent else { return }
        
        if eventFromUser.confirmed {
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("This event will be removed from your notifications and calendar.", comment: ""), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive) { (alert) in
                self.presenter?.changeAttendanceStatusForEvent(event: self.selectedEvent!, attendance: false)
                
                self.lbAttendanceTitle.text = NSLocalizedString("I want to go!", comment: "")
                
                self.presenter?.removeEventFromCalendar(event: self.selectedEvent!)
                self.btConfirmAttendance.setImage(UIImage(named: "star"), for: .normal)
            }
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            self.presenter?.changeAttendanceStatusForEvent(event: self.selectedEvent!, attendance: true)            

            lbAttendanceTitle.text = NSLocalizedString("I will go!", comment: "")
            self.btConfirmAttendance.setImage(UIImage(named: "confirm"), for: .normal)
            
            addToCalendarAlert()            
        }
    }
    
    /* Show a message to the user that the event will be added to the calendar */
    func addToCalendarAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("You will be notified when the event is coming. Do you want to add this event to your calendar ?", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (alert) in
            self.presenter?.addEventToCalendar(event: self.selectedEvent!)
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /* When the uses touches the button, the Maps app will be open with the event address */
    @IBAction func openMapsApp(_ sender: Any) {
        presenter?.openMapsApp(map: mvEventLocation, event: selectedEvent!)        
    }
    
}

extension EventViewController: EventDelegate {
    
    /* Update the labels with the user event information */
    func showUserEvent(userEvent: UserEvent) {
        self.userEvent = userEvent
        
        if userEvent.confirmed {
            lbAttendanceTitle.text = NSLocalizedString("I will go!", comment: "")
            btConfirmAttendance.setImage(UIImage(named: "confirm"), for: .normal)
        } else {
            lbAttendanceTitle.text = NSLocalizedString("I want to go!", comment: "")
            btConfirmAttendance.setImage(UIImage(named: "star"), for: .normal)
        }
    }
    
    /* Show the event location on the map */
    func showLocationOnMap(region: MKCoordinateRegion, mark: MKPlacemark) {
        mvEventLocation.setRegion(region, animated: true)
        mvEventLocation.addAnnotation(mark)
    }
    
    /* Show an alert message with the string in the params */
    func showAlertWithMessage(message: String) {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
