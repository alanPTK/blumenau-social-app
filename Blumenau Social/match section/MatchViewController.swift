import UIKit

struct MatchConstants {
    static let MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER = 0
    static let EVENT_COLLECTION_VIEW_IDENTIFIER = 1
}

class MatchViewController: UIViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var pcMatchingInstitutions: UIPageControl!
    @IBOutlet weak var cvMatchingInstitutions: UICollectionView!
    @IBOutlet weak var cvEvents: UICollectionView!
    @IBOutlet weak var pcEvents: UIPageControl!
    @IBOutlet weak var vInfo: UIView!
    
    private var currentPage = 0
    private var currentEventPage = 0
    private var matchingInstitutions: [Institution] = []
    private var events: [InstitutionEvent] = []
    private let institutionRepository = InstitutionRepository()
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
                
        NotificationCenter.default.addObserver(self, selector: #selector(showMoreInfo), name: NSNotification.Name("showMoreInfo"), object: nil)
        
        //matchingInstitutions = institutionRepository.searchInstitutions(neighborhoods: [preferences.userNeighborhood], causes: preferences.userInterests, donationType: [], volunteerType: [], days: preferences.userDays, periods: preferences.userPeriods, limit: 5)
        matchingInstitutions = Array(institutionRepository.getAllInstitutions())
        
        events = institutionRepository.getAllEvents()
        
        setupView()
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
        
        if events.count < 2 {
            pcEvents.isHidden = true
        }
        
        pcMatchingInstitutions.numberOfPages = matchingInstitutions.count
        pcMatchingInstitutions.pageIndicatorTintColor = UIColor.descColor()
        pcMatchingInstitutions.currentPageIndicatorTintColor = UIColor.titleColor()
        
//        pcEvents.numberOfPages = matchingInstitutions.count
//        pcEvents.pageIndicatorTintColor = UIColor.descColor()
//        pcEvents.currentPageIndicatorTintColor = UIColor.titleColor()
        
        lbTitle.text = NSLocalizedString("Institutions and events", comment: "")
        
        cvMatchingInstitutions.layer.cornerRadius = 8
    }
    
    /* When the scrolling is finished, update the page control */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == cvMatchingInstitutions {
            currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        }
        
        if scrollView == cvEvents {
            currentEventPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        }
        
        pcMatchingInstitutions.currentPage = currentPage
        //pcEvents.currentPage = currentEventPage
    }

    /* Show the profile screen */
    @IBAction func showProfile(_ sender: Any) {
        let initialProfileViewController = UIStoryboard(name: Constants.PROFILE_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_PROFILE_VIEW_STORYBOARD_ID)
        
        let navigationController = UINavigationController(rootViewController: initialProfileViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    /* When the view appears, hide the info view if the profile is already created */
    override func viewWillAppear(_ animated: Bool) {
        if preferences.profileIsCreated {
            //vInfo.isHidden = true
        }
    }
    
    func showInstitution(institution: Institution) {
        let institutionInformationViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        institutionInformationViewController.currentInstitution = institution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
}

extension MatchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Returns the number of items that the collection view should show. If there is no profile, the number is zero */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            if preferences.profileIsCreated {
                return matchingInstitutions.count
            }
        } else {
            return events.count
        }
        
        return 0
    }
    
    /* Returns the cell content */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstitutionCardCell", for: indexPath) as! InstitutionCardCollectionViewCell
            
            let currentInstitution = matchingInstitutions[indexPath.row]
            
            cell.setupCell()
            cell.loadInformation(institution: currentInstitution)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCardCell", for: indexPath) as! InstitutionCardCollectionViewCell
            
            let currentEvent = events[indexPath.row]
            
            cell.setupCell()
            cell.loadEventInformation(event: currentEvent)
            
            return cell
        }
    }
    
    /* Show the institution screen with the selected institution */
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
