import UIKit
import RealmSwift
import Nuke
import MessageUI

struct InstitutionConstant {
    static let TOGGLE_IS_EXPANDED = 1
    static let TOGGLE_IS_COLLAPSED = 1
    static let INSTITUTION_IMAGES_COLLECTION_VIEW_IDENTIFIER = 0
    static let INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER = 0
    static let INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER = 1
    static let INSTITUTION_ABOUT_TABLE_VIEW_IDENTIFIER = 3
}

class InstitutionViewController: UIViewController {
    
    //working hours
    @IBOutlet weak var vWorkingHours: UIView!
    @IBOutlet weak var btToggleWorkingHours: UIButton!
    @IBOutlet weak var lbWorkingHours: UILabel!
    @IBOutlet weak var lcWorkingHoursHeight: NSLayoutConstraint!
    @IBOutlet weak var tvWorkingHours: UITextView!
    var workingHoursOriginalHeight: CGFloat = 0
    
    //about
    @IBOutlet weak var vAbout: UIView!
    @IBOutlet weak var lcAboutHeight: NSLayoutConstraint!
    @IBOutlet weak var tvAbout: UITableView!
    var aboutOriginalHeight: CGFloat = 0
    
    //donation
    @IBOutlet weak var vDonations: UIView!
    @IBOutlet weak var btToggleDonation: UIButton!
    @IBOutlet weak var lbDonation: UILabel!
    @IBOutlet weak var lcDonationsHeight: NSLayoutConstraint!
    @IBOutlet weak var tvDonations: UITableView!
    var donationOriginalHeight: CGFloat = 0
    
    //volunteers
    @IBOutlet weak var vVolunteers: UIView!
    @IBOutlet weak var btToggleVolunteers: UIButton!
    @IBOutlet weak var lbVolunteers: UILabel!
    @IBOutlet weak var tvVolunteers: UITextView!
    @IBOutlet weak var lcVolunteersHeight: NSLayoutConstraint!
    var volunteersOriginalHeight: CGFloat = 0
    
    //events
    @IBOutlet weak var vEvents: UIView!
    @IBOutlet weak var btToggleEvent: UIButton!
    @IBOutlet weak var lbEvent: UILabel!
    @IBOutlet weak var lcEventHeight: NSLayoutConstraint!
    @IBOutlet weak var tvEvents: UITableView!
    var eventOriginalHeight: CGFloat = 0
    
    //pictures
    @IBOutlet weak var vPictures: UIView!
    @IBOutlet weak var btTogglePictures: UIButton!
    @IBOutlet weak var lbPictures: UILabel!
    @IBOutlet weak var lcPicturesHeight: NSLayoutConstraint!
    @IBOutlet weak var pcInstitutionPictures: UIPageControl!
    @IBOutlet weak var cvPictures: UICollectionView!
    var picturesOriginalHeight: CGFloat = 0
    
    //scope
    @IBOutlet weak var vScope: UIView!
    @IBOutlet weak var btToggleScope: UIButton!
    @IBOutlet weak var lbScope: UILabel!
    @IBOutlet weak var lcScopeHeight: NSLayoutConstraint!
    @IBOutlet weak var tvScope: UITextView!
    var scopeOriginalHeight: CGFloat = 0
    
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var lbResponsible: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbResponsibleTitle: UILabel!
    
    @IBOutlet weak var vMainInformation: UIView!
    @IBOutlet weak var vContactInformation: UIView!
    @IBOutlet weak var lcMainInformationHeight: NSLayoutConstraint!
    @IBOutlet weak var lcContactInformationHeight: NSLayoutConstraint!
    
    private var currentPage: Int = 0
    private let institutionRepository = InstitutionRepository()
    private let filterRepository = FilterOptionsRepository()
    private var events: [InstitutionEvent] = []
    var currentInstitution: Institution?
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleAboutVisibility), name: NSNotification.Name(rawValue: "toggleAboutVisibility"), object: nil)
        
        events = Array((currentInstitution?.events)!)
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        vMainInformation.layer.cornerRadius = 8
        vContactInformation.layer.cornerRadius = 8
        vWorkingHours.layer.cornerRadius = 8
        vScope.layer.cornerRadius = 8
        vDonations.layer.cornerRadius = 8
        vVolunteers.layer.cornerRadius = 8
        vPictures.layer.cornerRadius = 8
        vEvents.layer.cornerRadius = 8
        vAbout.layer.cornerRadius = 8
        
        tvWorkingHours.text = currentInstitution?.workingHours
        tvWorkingHours.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        tvScope.text = currentInstitution?.scope
        tvScope.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        tvVolunteers.text = currentInstitution?.volunteers
        tvVolunteers.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        pcInstitutionPictures.pageIndicatorTintColor = UIColor.descColor()
        pcInstitutionPictures.currentPageIndicatorTintColor = UIColor.titleColor()
        pcInstitutionPictures.numberOfPages = (currentInstitution?.pictures.count)!
        
        tvAbout.estimatedRowHeight = 100
        tvAbout.rowHeight = UITableView.automaticDimension
        
        lbAddress.text = currentInstitution?.address
        lbAddress.textColor = UIColor.descColor()
        lbAddress.font = UIFont.boldSystemFont(ofSize: lbAddress.font.pointSize)
        lbAddress.isUserInteractionEnabled = true
        
        let underlineLocationText = NSAttributedString(string: (currentInstitution?.address)!, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lbAddress.attributedText = underlineLocationText
        
        lbPhone.text = currentInstitution?.phone
        lbPhone.textColor = UIColor.descColor()
        lbPhone.font = UIFont.boldSystemFont(ofSize: lbPhone.font.pointSize)
        lbPhone.isUserInteractionEnabled = true
        
        let underlinePhoneText = NSAttributedString(string: (currentInstitution?.phone)!, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lbPhone.attributedText = underlinePhoneText
        
        lbEmail.text = currentInstitution?.mail
        lbEmail.textColor = UIColor.descColor()
        lbEmail.isUserInteractionEnabled = true
        lbEmail.font = UIFont.boldSystemFont(ofSize: lbEmail.font.pointSize)
        
        let underlineEmailText = NSAttributedString(string: (currentInstitution?.mail)!, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        lbEmail.attributedText = underlineEmailText
        
        lbResponsible.text = currentInstitution?.responsible
        lbTitle.text = currentInstitution?.title
        lbSubtitle.text = currentInstitution?.subtitle
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(close))
        ivClose.addGestureRecognizer(closeTap)
        ivClose.isUserInteractionEnabled = true
        
        let phoneTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(callInstitution))
        lbPhone.addGestureRecognizer(phoneTapGestureRecognizer)
        
        let emailTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sendEmailToInstitution))
        lbEmail.addGestureRecognizer(emailTapGestureRecognizer)
        
        let locationTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showInstitutionLocation))
        lbAddress.addGestureRecognizer(locationTapGestureRecognizer)
        
        if currentInstitution?.responsible.isEmpty ?? true {
            lbResponsible.isHidden = true
            lbResponsibleTitle.isHidden = true
        }
    }
    
    /* When the user taps the address, open the Maps application with the institution location */
    @objc func showInstitutionLocation() {
        if let address = lbAddress.text {
            Utils.shared.openLocation(address: address)
        }        
    }
    
    /* When the user taps the phone, make a call */
    @objc func callInstitution() {
        if let phone = lbPhone.text {
            Utils.shared.callPhoneNumber(phoneNumber: phone)
        }                
    }
    
    /* When the user taps the email, call the mail composer screen */
    @objc func sendEmailToInstitution() {
        if let email = lbEmail.text {
            sendEmailTo(recipients: [email], withSubject: "", message: "")
        }
    }
    
    /* When the user touches the image, dismiss the view */
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    /* Hide or show the institution working hours section */
    @IBAction func toggleWorkingHoursVisibility(_ sender: Any) {
        if btToggleWorkingHours.tag == 0 {
            btToggleWorkingHours.tag = 1
            lcWorkingHoursHeight.constant = tvWorkingHours.frame.origin.y + 8
            
            toggleButtonImage(button: btToggleWorkingHours, expand: true)
        } else {
            btToggleWorkingHours.tag = 0
            lcWorkingHoursHeight.constant = workingHoursOriginalHeight
            
            toggleButtonImage(button: btToggleWorkingHours, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution donations section */
    @IBAction func toggleDonationVisibility(_ sender: Any) {
        if btToggleDonation.tag == 0 {
            btToggleDonation.tag = 1
            lcDonationsHeight.constant = tvDonations.frame.origin.y + 8
            
            toggleButtonImage(button: btToggleDonation, expand: true)
        } else {
            btToggleDonation.tag = 0
            lcDonationsHeight.constant = donationOriginalHeight
            
            toggleButtonImage(button: btToggleDonation, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution events section */
    @IBAction func toggleEventVisibility(_ sender: Any) {
        if btToggleEvent.tag == 0 {
            btToggleEvent.tag = 1
            lcEventHeight.constant = tvEvents.frame.origin.y + 8
            
            toggleButtonImage(button: btToggleEvent, expand: true)
        } else {
            btToggleEvent.tag = 0
            lcEventHeight.constant = eventOriginalHeight
            
            toggleButtonImage(button: btToggleEvent, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution volunteers section */
    @IBAction func toggleVolunteersVisibility(_ sender: Any) {
        if btToggleVolunteers.tag == 0 {
            btToggleVolunteers.tag = 1
            lcVolunteersHeight.constant = tvDonations.frame.origin.y + 8
            
            toggleButtonImage(button: btToggleVolunteers, expand: true)
        } else {
            btToggleDonation.tag = 0
            lcVolunteersHeight.constant = volunteersOriginalHeight
            
            toggleButtonImage(button: btToggleVolunteers, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution pictures section */
    @IBAction func togglePicturesVisibility(_ sender: Any) {
        if btTogglePictures.tag == 0 {
            btTogglePictures.tag = 1
            lcPicturesHeight.constant = cvPictures.frame.origin.y + 8
            pcInstitutionPictures.isHidden = true
            
            toggleButtonImage(button: btTogglePictures, expand: true)
        } else {
            btTogglePictures.tag = 0
            lcPicturesHeight.constant = picturesOriginalHeight
            pcInstitutionPictures.isHidden = false
            
            toggleButtonImage(button: btTogglePictures, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution scope section */
    @IBAction func toggleScopeVisibility(_ sender: Any) {
        if btToggleScope.tag == 0 {
            btToggleScope.tag = 1
            lcScopeHeight.constant = cvPictures.frame.origin.y + 8
            
            toggleButtonImage(button: btToggleScope, expand: true)
        } else {
            btToggleScope.tag = 0
            lcScopeHeight.constant = scopeOriginalHeight
            
            toggleButtonImage(button: btToggleScope, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Hide or show the institution about section */
    @objc func toggleAboutVisibility(notification: Notification) {
        let btToggleAbout = notification.object as! UIButton
        
        if btToggleAbout.tag == 0 {
            btToggleAbout.tag = 1
            lcAboutHeight.constant = tvAbout.frame.origin.y + 40

            toggleButtonImage(button: btToggleAbout, expand: true)
        } else {
            btToggleAbout.tag = 0
            lcAboutHeight.constant = aboutOriginalHeight

            toggleButtonImage(button: btToggleAbout, expand: false)
        }
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* Animate the toggle button */
    func toggleButtonImage(button: UIButton, expand: Bool) {
        let image = expand ? UIImage(named: "expand") : UIImage(named: "collapse")
        UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            button.setImage(image, for: .normal)
        }, completion: nil)
    }
    
    /* When the view appears, calculate the size of the components to make the view with the right size */
    override func viewDidAppear(_ animated: Bool) {
        tvWorkingHours.setContentOffset(.zero, animated: false)
        tvWorkingHours.scrollRangeToVisible(NSRange(location:0, length:0))
        tvWorkingHours.isScrollEnabled = true
        
        tvScope.setContentOffset(.zero, animated: false)
        tvScope.scrollRangeToVisible(NSRange(location:0, length:0))
        tvScope.isScrollEnabled = true
        
        tvVolunteers.setContentOffset(.zero, animated: false)
        tvVolunteers.scrollRangeToVisible(NSRange(location:0, length:0))
        tvVolunteers.isScrollEnabled = true
        
        Utils.shared.resizeTextView(textView: tvWorkingHours)
        Utils.shared.resizeTextView(textView: tvScope)
        Utils.shared.resizeTextView(textView: tvVolunteers)
        
        lcWorkingHoursHeight.constant = tvWorkingHours.frame.size.height + tvWorkingHours.frame.origin.y + 16
        workingHoursOriginalHeight = lcWorkingHoursHeight.constant
        
        lcScopeHeight.constant = tvScope.frame.size.height + tvScope.frame.origin.y + 16
        scopeOriginalHeight = lcScopeHeight.constant
        
        lcDonationsHeight.constant = tvDonations.contentSize.height + tvDonations.frame.origin.y + 16
        donationOriginalHeight = lcDonationsHeight.constant
        
        lcEventHeight.constant = tvEvents.contentSize.height + tvEvents.frame.origin.y + 16
        eventOriginalHeight = lcEventHeight.constant
        
        lcVolunteersHeight.constant = tvVolunteers.contentSize.height + tvVolunteers.frame.origin.y + 16
        volunteersOriginalHeight = lcVolunteersHeight.constant
        
        lcAboutHeight.constant = tvAbout.contentSize.height + 16
        aboutOriginalHeight = lcAboutHeight.constant
        
        if currentInstitution?.workingHours.isEmpty ?? true {
            lcWorkingHoursHeight.constant = 0
            vWorkingHours.isHidden = true
        } else {
            workingHoursOriginalHeight = lcWorkingHoursHeight.constant
            vWorkingHours.isHidden = false
        }
        
        if currentInstitution?.pictures.count == 0 {
            lcPicturesHeight.constant = 0
            vPictures.isHidden = true
        } else {
            picturesOriginalHeight = lcPicturesHeight.constant
            vPictures.isHidden = false
        }
        
        if (currentInstitution?.volunteers.isEmpty)! {
            vVolunteers.isHidden = true
            lcVolunteersHeight.constant = 0
        }
        
        if events.count == 0 {
            lcEventHeight.constant = 0
            vEvents.isHidden = true
        } else {
            eventOriginalHeight = lcEventHeight.constant
            vEvents.isHidden = false
        }
        
        lcMainInformationHeight.constant = lbSubtitle.frame.origin.y + lbSubtitle.frame.size.height + 8
        lcContactInformationHeight.constant = lbResponsible.frame.origin.y + lbResponsible.frame.size.height + 8
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    /* When the scrolling is finished, update the page control */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        pcInstitutionPictures.currentPage = currentPage
    }        
    
}

extension InstitutionViewController: UITableViewDataSource, UITableViewDelegate {
    
    /* Returns the number of sections in the table views */
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView.tag {
            case InstitutionConstant.INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER:
                if let count = currentInstitution?.donations.count {
                    return count
                }
                return 0
            case InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER:
                return events.count
            case InstitutionConstant.INSTITUTION_ABOUT_TABLE_VIEW_IDENTIFIER:
                return 1
            default:
                return 0
        }
    }
    
    /* Returns the number of rows in the table views */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
            case InstitutionConstant.INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER,
                 InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER:
                return 1
            case InstitutionConstant.INSTITUTION_ABOUT_TABLE_VIEW_IDENTIFIER:
                if let count = currentInstitution?.about.count {
                    return count
                }
                return 0
            default:
                return 0
        }
    }
    
    /* Returns the cell content */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == InstitutionConstant.INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TITLE_CELL_IDENTIFIER, for: indexPath)
            let currentDonation = currentInstitution?.donations[indexPath.section]
            
            cell.contentView.backgroundColor = UIColor.titleColor()
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.textLabel?.text = currentDonation?.desc
            
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.titleColor().cgColor
            
            return cell
        } else if tableView.tag == InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TITLE_CELL_IDENTIFIER, for: indexPath)
            let currentEvent = events[indexPath.section]
            
            cell.contentView.backgroundColor = UIColor.titleColor()
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.textLabel?.text = currentEvent.title                        
            
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.titleColor().cgColor
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.INSTITUTION_ABOUT_CELL_IDENTIFIER, for: indexPath) as! AboutTableViewCell
            let currentAbout = currentInstitution?.about[indexPath.row]
            
            cell.setupCell()
            cell.loadInformation(about: currentAbout!, indexPath: indexPath)                        
            
            return cell
        }
    }
    
    /* Returns the height for the table view header */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView.tag {
            case InstitutionConstant.INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER,
                 InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER:
                return 2
            default:
                return 0
        }
    }
    
    /* Returns the view for the table view header */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView.tag {
            case InstitutionConstant.INSTITUTION_DONATIONS_TABLE_VIEW_IDENTIFIER,
                 InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER:
                
                let view = UIView()
                view.backgroundColor = .clear
                
                return view
            default:
                return UIView()
        }
    }
    
    /* Returns the size of the table view row, the size is calculated automatically based on the constraints */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /* When the user selects an event, show it */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == InstitutionConstant.INSTITUTION_EVENTS_TABLE_VIEW_IDENTIFIER {
            let event = events[indexPath.section]
            showEvent(event: event)
        }
    }
    
    /* Show the event screen with the selected event */
    func showEvent(event: InstitutionEvent) {
        let eventViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.EVENT_VIEW_STORYBOARD_ID) as! EventViewController
        eventViewController.selectedEvent = event
        
        present(eventViewController, animated: true, completion: nil)
    }
    
}

extension InstitutionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Returns the number of sections in the collection views */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == InstitutionConstant.INSTITUTION_IMAGES_COLLECTION_VIEW_IDENTIFIER {
            if let count = currentInstitution?.pictures.count {
                return count
            }
        } else {
            if let count = currentInstitution?.causes.count {
                return count
            }
        }
        
        return 0
    }
    
    /* Returns the cell content */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == InstitutionConstant.INSTITUTION_IMAGES_COLLECTION_VIEW_IDENTIFIER {
            let currentPicture = currentInstitution?.pictures[indexPath.row]
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.IMAGE_CELL_IDENTIFIER, for: indexPath) as! ActionImageCollectionViewCell
            
            if let pictureURL = URL(string: currentPicture!) {
                Nuke.loadImage(with: pictureURL, into: imageCell.ivAction)
            }
            
            return imageCell
        } else {
            let currentCause = currentInstitution?.causes[indexPath.row]
            let cause = filterRepository.getAreaWithId(id: (currentCause?.id)!)
            
            let causeCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_CAUSE_CELL_IDENTIFIER, for: indexPath) as! CauseCollectionViewCell
            
            if let name = cause?.name {
                causeCell.lbCause.text = String(format: "%@", name)
            }
            
            return causeCell
        }
    }
    
    /* If the user selected an image from the institution, opens in full screen */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == InstitutionConstant.INSTITUTION_IMAGES_COLLECTION_VIEW_IDENTIFIER {
            let fullImageViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.DIALOG_STORYBOARD_NAME) as! FullImageViewController
            fullImageViewController.showInstitutionPictures = true
            fullImageViewController.institutionPictures = currentInstitution?.pictures
            
            present(fullImageViewController, animated: true, completion: nil)
        }
    }
    
    /* Returns the size of the item in the collection view. If it is the image collection view, the item occupies the full size  If it is the causes collectio view, the size is calculated based on the string lenght plus a fixed constant */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == InstitutionConstant.INSTITUTION_IMAGES_COLLECTION_VIEW_IDENTIFIER {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            let currentCause = currentInstitution?.causes[indexPath.row]
            let cause = filterRepository.getAreaWithId(id: (currentCause?.id)!)
            if cause != nil {
                let textSize = cause?.name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
                
                return CGSize(width: (textSize?.width)! + 30, height: 17)
            } else {
                return CGSize(width: 0, height: 0)
            }
        }
    }

}
