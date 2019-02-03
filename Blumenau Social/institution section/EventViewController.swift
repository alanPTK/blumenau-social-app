import UIKit
import MapKit
import CoreLocation

class EventViewController: UIViewController {

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
        
    }        
    
}
