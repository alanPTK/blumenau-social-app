import UIKit
import MapKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvEventDescription.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
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
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func confirmAttendance(_ sender: Any) {
        
    }        
    
}
