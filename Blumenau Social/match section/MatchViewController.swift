import UIKit
import MSPeekCollectionViewDelegateImplementation


struct MatchConstants {
    static let MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER = 0
    static let EVENT_COLLECTION_VIEW_IDENTIFIER = 1
}
//TODO, comentar

class MatchViewController: UIViewController {
    
    @IBOutlet weak var cvHighlightedInstitutions: UICollectionView!
    @IBOutlet weak var cvMoreHighlightedInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var btUpdateProfile: UIButton!
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbHighlightedInstitutions: UILabel!
    @IBOutlet weak var lbMoreHighlightedInstitutions: UILabel!
    @IBOutlet weak var vInfo: UIView!
    @IBOutlet weak var lbInfo: UILabel!
    
    var peekImplementation: MSPeekCollectionViewDelegateImplementation!
    var matchingInstitutions: [Institution] = []
    var events: [InstitutionEvent] = []
    let institutionRepository = InstitutionRepository()
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        setupView()
        
        peekImplementation = CustomPeekCollectionView()
        
        cvHighlightedInstitutions.configureForPeekingDelegate()
        cvHighlightedInstitutions.delegate = peekImplementation
        cvHighlightedInstitutions.dataSource = self
        
        cvMoreHighlightedInstitutions.configureForPeekingDelegate()
        cvMoreHighlightedInstitutions.delegate = peekImplementation
        cvMoreHighlightedInstitutions.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInstitution), name: Notification.Name(rawValue: "showInstitution"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEvent), name: Notification.Name(rawValue: "showEvent"), object: nil)
        
        matchingInstitutions = institutionRepository.searchInstitutions(neighborhoods: [preferences.userNeighborhood], causes: preferences.userInterests, donationType: [], volunteerType: [], days: preferences.userDays, periods: preferences.userPeriods, limit: 5)
        
        events = institutionRepository.getAllEvents()
        
        setupView()
    }
    
    /* Initialize the view components */
    func setupView() {
        let showProfileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        ivProfile.addGestureRecognizer(showProfileTapRecognizer)
        ivProfile.isUserInteractionEnabled = true
        
        lbMoreHighlightedInstitutions.text = NSLocalizedString("Events from the institutions that we think you would like", comment: "")
        
        lbInfo.text = NSLocalizedString("Touch here to create a profile and find out which institutions that fit it", comment: "")
        lbInfo.isUserInteractionEnabled = true
        
        let createProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        lbInfo.addGestureRecognizer(createProfileTapGesture)
        
        if !preferences.userName.isEmpty {
            let firstNameIndex = preferences.userName.firstIndex(of: " ")
            var firstName = ""
            if firstNameIndex != nil {
                firstName = String(preferences.userName.prefix(upTo: firstNameIndex!))
            } else {
                firstName = preferences.userName
            }
            lbHighlightedInstitutions.text = String(format: NSLocalizedString("These are the institutions that fit your profile", comment: ""), String(firstName))
        }
    }
    
    /* Show the profile screen */
    @objc func showProfile() {
        let initialProfileViewController = UIStoryboard(name: Constants.PROFILE_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_PROFILE_VIEW_STORYBOARD_ID)
        
        let navigationController = UINavigationController(rootViewController: initialProfileViewController)
        present(navigationController, animated: true, completion: nil)                
    }
    
    /* When the view appears, hide the info view if the profile is already created */
    override func viewWillAppear(_ animated: Bool) {
        if preferences.profileIsCreated {
            vInfo.isHidden = true
        }
    }
    
    /* Show the institution screen with the selected institution */
    @objc func showInstitution(notification: Notification) {
        let indexPath = notification.object as! IndexPath
        let selectedInstitution = matchingInstitutions[indexPath.row]
        
        let institutionInformationViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        institutionInformationViewController.currentInstitution = selectedInstitution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    /* Show the event screen with the selected event */
    @objc func showEvent(notification: Notification) {
        let indexPath = notification.object as! IndexPath
        let selectedEvent = events[indexPath.row]
        
        let eventViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.EVENT_VIEW_STORYBOARD_ID) as! EventViewController
        eventViewController.selectedEvent = selectedEvent
        
        present(eventViewController, animated: true, completion: nil)
    }

}

class CustomPeekCollectionView: MSPeekCollectionViewDelegateImplementation {
    
    /* When the user selects an item in the collectionview, show the event or the institution accordingly */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var notificationName = ""
        
        if collectionView.tag == MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            notificationName = Constants.SHOW_INSTITUTION_NOTIFICATION_NAME
        } else {
            notificationName = Constants.SHOW_EVENT_NOTIFICATION_NAME
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: indexPath)
    }
    
}

extension MatchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //TODO
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
    
    /* Return the number of sections that the collection view should show */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_MATCH_CELL_IDENTIFIER, for: indexPath) as! InstitutionCollectionViewCell
        
        if collectionView.tag == MatchConstants.MATCH_INSTITUTION_COLLECTION_VIEW_IDENTIFIER {
            let currentInstitution = matchingInstitutions[indexPath.row]
            
            institutionCell.loadInformation(institution: currentInstitution)
            
            return institutionCell
        } else {
            let currentEvent = events[indexPath.row]
            
            institutionCell.loadEvent(event: currentEvent)
            
            return institutionCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width / 2)-5), height: collectionView.frame.size.height)
    }
    
}
