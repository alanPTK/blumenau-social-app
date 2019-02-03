import UIKit
import RealmSwift
import Nuke
import MessageUI

class InstitutionViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        
    @IBOutlet weak var vMainInformation: UIView!
    @IBOutlet weak var vContactInformation: UIView!
    @IBOutlet weak var lcMainInformationHeight: NSLayoutConstraint!
    @IBOutlet weak var lcContactInformationHeight: NSLayoutConstraint!
    
    var currentPage: Int = 0
    var currentInstitution: Institution?
    let institutionRepository = InstitutionRepository()
    let filterRepository = FilterOptionsRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMainInformation.layer.cornerRadius = 8
        vContactInformation.layer.cornerRadius = 8
        vWorkingHours.layer.cornerRadius = 8
        vScope.layer.cornerRadius = 8
        vDonations.layer.cornerRadius = 8
        vVolunteers.layer.cornerRadius = 8
        vPictures.layer.cornerRadius = 8
        vAbout.layer.cornerRadius = 8
        
        tvWorkingHours.text = currentInstitution?.workingHours
        tvWorkingHours.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0);
        
        tvScope.text = currentInstitution?.scope
        tvScope.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0);
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleAboutVisibility), name: NSNotification.Name(rawValue: "toggleAboutVisibility"), object: nil)
    }
    
    @objc func showInstitutionLocation() {
        let location = String(format: "http://maps.apple.com/?address=%@", lbAddress.text!)
        
        if let locationURL = URL(string: location) {
            UIApplication.shared.open(locationURL)
        }
    }
    
    @objc func callInstitution() {
        if let number = URL(string: "tel://" + lbPhone.text!) {
            UIApplication.shared.open(number)
        }
    }
    
    @objc func sendEmailToInstitution() {
        if !MFMailComposeViewController.canSendMail() {
            let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("We can't send the email. Please, check if you have an email configured in your settings.", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        } else {
            let body = ""
            
            let composeEmailViewController = MFMailComposeViewController()
            
            composeEmailViewController.mailComposeDelegate = self
            if let email = lbEmail.text {
                composeEmailViewController.setToRecipients([email])
            }
            composeEmailViewController.setSubject("")
            composeEmailViewController.setMessageBody(body, isHTML: false)
            
            present(composeEmailViewController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLongPress(longPressGesture:UILongPressGestureRecognizer) {
        let p = longPressGesture.location(in: tvDonations)
        let indexPath = tvDonations.indexPathForRow(at: p)
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .destructive, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
        
        if indexPath == nil {
            print("Long press on table view, not row.")
        } else if (longPressGesture.state == UIGestureRecognizer.State.began) {
            print("Long press on row, at \(indexPath!.section)")
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func toggleButtonImage(button: UIButton, expand: Bool) {
        let image = expand ? UIImage(named: "expand") : UIImage(named: "collapse")
        UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            button.setImage(image, for: .normal)
        }, completion: nil)
    }
    
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
        
        resizeTextView(textView: tvWorkingHours)
        resizeTextView(textView: tvScope)
        resizeTextView(textView: tvVolunteers)
        
        lcWorkingHoursHeight.constant = tvWorkingHours.frame.size.height + tvWorkingHours.frame.origin.y + 16
        workingHoursOriginalHeight = lcWorkingHoursHeight.constant
        
        lcScopeHeight.constant = tvScope.frame.size.height + tvScope.frame.origin.y + 16
        scopeOriginalHeight = lcScopeHeight.constant
        
        lcDonationsHeight.constant = tvDonations.contentSize.height + tvDonations.frame.origin.y + 16
        donationOriginalHeight = lcDonationsHeight.constant
        
        lcVolunteersHeight.constant = tvVolunteers.contentSize.height + tvVolunteers.frame.origin.y + 16
        volunteersOriginalHeight = lcVolunteersHeight.constant
        
        lcAboutHeight.constant = tvAbout.contentSize.height + 16
        aboutOriginalHeight = lcAboutHeight.constant
        
        if currentInstitution?.pictures.count == 0 {
            lcPicturesHeight.constant = 0
        } else {
            picturesOriginalHeight = lcPicturesHeight.constant
        }
        
        if (currentInstitution?.volunteers.isEmpty)! {
            vVolunteers.isHidden = true
            lcVolunteersHeight.constant = 0
        }
        
        lcMainInformationHeight.constant = lbSubtitle.frame.origin.y + lbSubtitle.frame.size.height + 8
        lcContactInformationHeight.constant = lbResponsible.frame.origin.y + lbResponsible.frame.size.height + 8
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        pcInstitutionPictures.currentPage = currentPage
    }
    
    @discardableResult
    func resizeTextView(textView: UITextView) -> CGSize {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        return textView.frame.size
    }
    
}

extension InstitutionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 0 {
            if let count = currentInstitution?.donations.count {
                return count
            }
        } else {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 1
        } else {
            if let count = currentInstitution?.about.count {
                return count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)            
            let currentDonation = currentInstitution?.donations[indexPath.section]
            
            cell.contentView.backgroundColor = UIColor.titleColor()
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.textLabel?.text = currentDonation?.desc
            
            cell.textLabel?.backgroundColor = .clear
            cell.textLabel?.textAlignment = .center
            
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.titleColor().cgColor
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath) as! AboutTableViewCell
            let currentAbout = currentInstitution?.about[indexPath.row]
            
            cell.lbTitle.text = currentAbout?.title
            cell.lbTitle.adjustsFontSizeToFitWidth = true
            cell.lbTitle.minimumScaleFactor = 0.5
            
            cell.tvDesc.text = currentAbout?.information
            cell.tvDesc.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
            cell.lcAboutHeight.constant = resizeTextView(textView: cell.tvDesc).height
            
            if indexPath.row == 0 {
                cell.btToggleVisibility.isHidden = false
            } else {
                cell.btToggleVisibility.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 0 {
            return 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 0 {
            let v = UIView()
            v.backgroundColor = .clear
            
            return v
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension InstitutionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let currentPicture = currentInstitution?.pictures[indexPath.row]
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ActionImageCollectionViewCell
            
            if let pictureURL = URL(string: currentPicture!) {
                Nuke.loadImage(with: pictureURL, into: imageCell.ivAction)
            }
            
            return imageCell
        } else {
            let currentCause = currentInstitution?.causes[indexPath.row]
            let cause = filterRepository.getAreaWithId(id: (currentCause?.id)!)
            
            let causeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "causeCell", for: indexPath) as! CauseCollectionViewCell
            causeCell.lbCause.text = String(format: "%@", (cause?.name)!)
            
            return causeCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            let fullImageViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.FULL_IMAGE_VIEW_STORYBOARD_ID) as! FullImageViewController
            fullImageViewController.showInstitutionPictures = true
            fullImageViewController.institutionPictures = currentInstitution?.pictures
            
            present(fullImageViewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            let currentCause = currentInstitution?.causes[indexPath.row]
            let cause = filterRepository.getAreaWithId(id: (currentCause?.id)!)
            let textSize = cause?.name.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])            
            
            return CGSize(width: (textSize?.width)! + 30, height: 17)
        }
    }

}
