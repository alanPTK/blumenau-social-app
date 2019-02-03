import UIKit
import MapKit
import CoreLocation
import EventKit
import EasyTipView

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
    let userPreferences = Preferences.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvEventDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        
        lbTitle.text = selectedEvent?.title
        lbEventDate.text = selectedEvent?.date
        lbEventAddress.text = selectedEvent?.address
        lbEventTime.text = selectedEvent?.time
        tvEventDescription.text = selectedEvent?.desc
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let location = lbEventAddress.text!
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)
                
                if var region = self?.mvEventLocation.region {
                    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                    region.center = location.coordinate
                    region.span = span
                    
                    self?.mvEventLocation.setRegion(region, animated: true)
                    self?.mvEventLocation.addAnnotation(mark)
                }
            }
        }
        
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
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @IBAction func confirmAttendance(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("Do you want to add this event to your calendar ?", comment: ""), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (alert) in
            
        }
        
        let noAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func openMapsApp(_ sender: Any) {
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: mvEventLocation.region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: mvEventLocation.region.span)
        ]
        
        let placemark = MKPlacemark(coordinate: mvEventLocation.centerCoordinate)
        let mapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = selectedEvent?.title
        mapItem.openInMaps(launchOptions: options)
    }
    
    /*func addEventToCalendar() {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                
                var eventStartDate: Date = Date()
                var eventEndDate: Date = Date()
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy HH:mm"
                
                if let startDay = self.selectedEvent?.start, let startHour = self.selectedEvent?.startHour {
                    let fullDate: String = String(format: "%@ %@", startDay, startHour)
                    
                    if let startDate = dateFormatter.date(from: fullDate) {
                        eventStartDate = startDate
                        print(startDate)
                    }
                }
                
                if let endDay = self.selectedEvent?.end, let endHour = self.selectedEvent?.endHour {
                    let fullDate: String = String(format: "%@ %@", endDay, endHour)
                    
                    if let endDate = dateFormatter.date(from: fullDate) {
                        eventEndDate = endDate
                        print(endDate)
                    }
                }
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = self.selectedEvent?.title
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                event.notes = self.selectedEvent?.desc
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    
//                    if let name = self.selectedEvent?.name, let pk = self.selectedEvent?.pk {
//                        LogController.sharedLogController.saveLogWith(type: Constants.LogTypes.user, event: Constants.EventTypes.addEventToCalendar, location: Constants.LocationTypes.eventDetail, payload: "Evento \(name)", pk: pk)
//                    }
                    
//                    self.showDefaultAlertWithTitle(title: NSLocalizedString("Attention", comment: ""), andMessage: NSLocalizedString("Event added successfully. We wait for you there !", comment: ""), andActionTitle: NSLocalizedString("OK", comment: ""))
                } catch _ as NSError {
//                    self.showDefaultAlertWithTitle(title: NSLocalizedString("Attention", comment: ""), andMessage: NSLocalizedString("Error adding the event to you calendar. Please, try again later.", comment: ""), andActionTitle: NSLocalizedString("OK", comment: ""))
                }
            } else {
//                self.showDefaultAlertWithTitle(title: NSLocalizedString("Attention", comment: ""), andMessage: NSLocalizedString("Error adding the event to you calendar. Did you allowed us to add events ? Please, check and try again.", comment: ""), andActionTitle: NSLocalizedString("OK", comment: ""))
            }
        }
    }*/
    
}
