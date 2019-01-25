import UIKit
import RealmSwift
import Nuke

class InstitutionViewController: UIViewController {
    
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var lbResponsible: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lcAboutHeight: NSLayoutConstraint!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lcVolunteersHeight: NSLayoutConstraint!
    @IBOutlet weak var lcDonationsHeight: NSLayoutConstraint!
    @IBOutlet weak var lcScopeHeight: NSLayoutConstraint!
    @IBOutlet weak var lcWorkingHoursHeight: NSLayoutConstraint!
    @IBOutlet weak var lcPicturesHeight: NSLayoutConstraint!
    @IBOutlet weak var vWorkingHours: UIView!
    @IBOutlet weak var vMainInformation: UIView!
    @IBOutlet weak var vContactInformation: UIView!
    @IBOutlet weak var tvWorkingHours: UITextView!
    @IBOutlet weak var tvScope: UITextView!
    @IBOutlet weak var vScope: UIView!
    @IBOutlet weak var vDonations: UIView!
    @IBOutlet weak var tvDonations: UITableView!
    @IBOutlet weak var vVolunteers: UIView!
    @IBOutlet weak var tvVolunteers: UITextView!
    @IBOutlet weak var vPictures: UIView!
    @IBOutlet weak var pcInstitutionPictures: UIPageControl!
    @IBOutlet weak var vAbout: UIView!
    @IBOutlet weak var tvAbout: UITableView!
    var currentPage: Int = 0
    var currentInstitution: Institution?
    let institutionRepository = InstitutionRepository()
    
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
        lbPhone.text = currentInstitution?.phone
        lbEmail.text = currentInstitution?.mail
        lbResponsible.text = currentInstitution?.responsible
        lbTitle.text = currentInstitution?.title
        lbSubtitle.text = currentInstitution?.subtitle
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(close))
        ivClose.addGestureRecognizer(closeTap)
        ivClose.isUserInteractionEnabled = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        //longPressGesture.delegate = self
        //tvDonations.addGestureRecognizer(longPressGesture)
        
        if currentInstitution?.pictures.count == 0 {
            lcPicturesHeight.constant = 0
        }
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
        lcScopeHeight.constant = tvScope.frame.size.height + tvScope.frame.origin.y + 16
        lcDonationsHeight.constant = tvDonations.contentSize.height + tvDonations.frame.origin.y + 16
        lcVolunteersHeight.constant = tvVolunteers.contentSize.height + tvVolunteers.frame.origin.y + 16
        lcAboutHeight.constant = tvAbout.contentSize.height + 16
        
        UIView.animate(withDuration: 1.0) {
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
    
    @IBAction func grow(_ sender: Any) {
        lcWorkingHoursHeight.constant += 1
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
            print(currentDonation?.title)
            
            cell.contentView.backgroundColor = UIColor.titleColor()
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.textLabel?.text = currentDonation?.title
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            let currentDonation = currentInstitution?.donations[indexPath.section]
            
            let alertController = UIAlertController(title: "", message: currentDonation?.title, preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .destructive, handler: nil)
            alertController.addAction(okAction)
            
            present(alertController, animated: true, completion: nil)
        }
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
            
            Nuke.loadImage(with: URL(string: (currentPicture?.link)!)!, into: imageCell.ivAction)                        
            
            return imageCell
        } else {
            let currentCause = currentInstitution?.causes[indexPath.row]
            
            let causeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "causeCell", for: indexPath) as! CauseCollectionViewCell
            causeCell.lbCause.text = currentCause?.title
            
            return causeCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        } else {
            return CGSize(width: 100, height: 17)
        }
    }

}
