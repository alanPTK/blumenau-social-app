import UIKit
import StoreKit
import EasyTipView

struct MatchConstants {
    static let MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER = 0
    static let EVENT_COLLECTION_VIEW_IDENTIFIER = 1
}

class MatchViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var pcMatchingInstitutions: UIPageControl!
    @IBOutlet weak var cvMatchingInstitutions: UICollectionView!
    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var tvDonations: UITableView!
    @IBOutlet weak var lbInfo: UILabel!
    @IBOutlet weak var lbDonation: UILabel!
    @IBOutlet weak var btShowMap: UIButton!
    
    private var currentPage = 0
    private var matchingInstitutions: [Institution] = []
    private let institutionRepository = InstitutionRepository()
    private var preferences = Preferences.shared
    private var currentInstitution: Institution?
    private var tipView: EasyTipView?
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(showMoreInfo), name: NSNotification.Name("showMoreInfo"), object: nil)
        
        matchingInstitutions = institutionRepository.searchInstitutionsForMatch(neighborhood: preferences.userNeighborhood, causes: preferences.userInterests, days: preferences.userDays, periods: preferences.userPeriods, limit: 5)
        
        currentInstitution = matchingInstitutions.first
        tvDonations.reloadData()
        
        setupView()
        
        if preferences.profileIsCreated {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    /* Show the institution when the user touches the button */
    @objc func showMoreInfo(notification: Notification) {
        let institution = notification.object as! Institution
        
        showInstitution(institution: institution)
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        if matchingInstitutions.count < 2 {
            pcMatchingInstitutions.isHidden = true
        }
        
        pcMatchingInstitutions.numberOfPages = matchingInstitutions.count
        pcMatchingInstitutions.pageIndicatorTintColor = UIColor.descColor()
        pcMatchingInstitutions.currentPageIndicatorTintColor = UIColor.titleColor()
        
        lbTitle.text = NSLocalizedString("Institutions and events", comment: "")
        lbInfo.text = NSLocalizedString("Touch here to create a profile and find out which institutions that fit it", comment: "")
        lbInfo.isUserInteractionEnabled = true
        
        lbDonation.text = NSLocalizedString("We need...", comment: "")
        
        let tapInfoRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        vInfo.addGestureRecognizer(tapInfoRecognizer)        
        
        cvMatchingInstitutions.layer.cornerRadius = 8
    }
    
    /* When the scrolling is finished, update the respectvily page control */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == cvMatchingInstitutions {
            currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
            currentInstitution = matchingInstitutions[currentPage]
            
            tvDonations.reloadData()
        }
        
        pcMatchingInstitutions.currentPage = currentPage
    }

    /* Show the profile screen */
    @IBAction func showProfile(_ sender: Any) {
        let initialProfileViewController = UIStoryboard(name: Constants.PROFILE_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_PROFILE_VIEW_STORYBOARD_ID)
        
        let navigationController = UINavigationController(rootViewController: initialProfileViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func showInstitutionsMap(_ sender: Any) {
        let institutionsMapViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_MAP_VIEW_STORYBOARD_ID) as! InstitutionsMapViewController
        
        institutionsMapViewController.selectedInstitutions = matchingInstitutions        
        present(institutionsMapViewController, animated: true, completion: nil)
    }
    
    /* When the view appears, hide the info view if the profile is already created */
    override func viewWillAppear(_ animated: Bool) {
        if preferences.profileIsCreated {
            vInfo.isHidden = true
            
            setStatusBarBackgroundColor(UIColor.titleColor())
        } else {
            setStatusBarBackgroundColor(UIColor.backgroundColor())
        }
    }
    
    /* Show the selected institution */
    func showInstitution(institution: Institution) {
        let institutionInformationViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        institutionInformationViewController.currentInstitution = institution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    /* Show the selected event */
    func showEvent(event: InstitutionEvent) {
        let institutionEventViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.EVENT_VIEW_STORYBOARD_ID) as! EventViewController
        institutionEventViewController.selectedEvent = event
        
        present(institutionEventViewController, animated: true, completion: nil)
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if preferences.profileIsCreated {
            if !preferences.institutionMapTipViewWasShown {
                var easyTipPreferences = EasyTipView.Preferences()
                easyTipPreferences.drawing.font = UIFont(name: "VAGRoundedNext-Bold", size: 13)!
                easyTipPreferences.drawing.foregroundColor = UIColor.titleColor()
                easyTipPreferences.drawing.backgroundColor = UIColor.white
                easyTipPreferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
                
                tipView = EasyTipView(text: NSLocalizedString("Toque aqui para localizar as suas instituições de forma mais fácil", comment: ""), preferences: easyTipPreferences, delegate: nil)
                
                tipView?.show(animated: true, forView: btShowMap, withinSuperview: self.view)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(3000)) {
                    self.tipView?.dismiss()
                }
                
                preferences.institutionMapTipViewWasShown = true
            }
        }
    }
}

extension MatchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Returns the number of items that the collection view should show. If there is no profile, the number is zero */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            if preferences.profileIsCreated {
                return matchingInstitutions.count
            }
        }
        
        return 0
    }
    
    /* Returns the cell content */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_CARD_CELL_IDENTIFIER, for: indexPath) as! InstitutionCardCollectionViewCell
            
            let currentInstitution = matchingInstitutions[indexPath.row]
            
            cell.setupCell()
            cell.loadInformation(institution: currentInstitution)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    /* Show the institution or event screen with the selected item */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            let selectedInstitution = matchingInstitutions[indexPath.row]
            showInstitution(institution: selectedInstitution)
        }
    }
    
    /* Returns the size of the collection view item */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}

extension MatchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = currentInstitution?.donations.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentDonation = currentInstitution?.donations[indexPath.section]
        
        let alertController = UIAlertController(title: NSLocalizedString("How would you like to help ?", comment: ""), message: currentInstitution?.title, preferredStyle: .actionSheet)
        
        if let phone = currentInstitution?.phone {
            let mainPhone = phone.components(separatedBy: "ou")[0]
            let phoneText = NSLocalizedString("Call to", comment: "") + " " + mainPhone
            let callAction = UIAlertAction(title: phoneText, style: .default) { (handler) in
                guard let number = URL(string: "tel://" + mainPhone.replacingOccurrences(of: " ", with: "")) else { return }
                UIApplication.shared.open(number)
            }
            alertController.addAction(callAction)
        }
        
        if let email = currentInstitution?.mail {
            let emailText = NSLocalizedString("Send an email", comment: "")
            let emailAction = UIAlertAction(title: emailText, style: .default) { (handler) in
                var mailSubject = ""
                if let donationDesc = currentDonation?.desc {
                    mailSubject = NSLocalizedString("Donation of", comment: "") + " " + donationDesc
                } else {
                    mailSubject = NSLocalizedString("Donation", comment: "")
                }
                self.sendEmailTo(recipients: [email], withSubject: mailSubject, message: NSLocalizedString("Hello, I would like to help with a donation.", comment: ""))
            }
            alertController.addAction(emailAction)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: nil)
        
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
