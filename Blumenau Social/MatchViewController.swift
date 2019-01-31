import UIKit
import MSPeekCollectionViewDelegateImplementation

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
    let institutionRepository = InstitutionRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        let showProfileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        ivProfile.addGestureRecognizer(showProfileTapRecognizer)
        ivProfile.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInstitution), name: Notification.Name(rawValue: "showInstitution"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showEvent), name: Notification.Name(rawValue: "showEvent"), object: nil)
        
        peekImplementation = CustomPeekCollectionView()
        
        cvHighlightedInstitutions.configureForPeekingDelegate()
        cvHighlightedInstitutions.delegate = peekImplementation
        cvHighlightedInstitutions.dataSource = self
        
        cvMoreHighlightedInstitutions.configureForPeekingDelegate()
        cvMoreHighlightedInstitutions.delegate = peekImplementation
        cvMoreHighlightedInstitutions.dataSource = self
        
        lbInfo.isUserInteractionEnabled = true
        
        if !Preferences.shared.userName.isEmpty {
            let firstNameIndex = Preferences.shared.userName.firstIndex(of: " ")
            let firstName = Preferences.shared.userName.prefix(upTo: firstNameIndex!)
            lbHighlightedInstitutions.text = String(format: NSLocalizedString("These are the institutions that fit your profile", comment: ""), String(firstName))
        }
        
        lbMoreHighlightedInstitutions.text = NSLocalizedString("Events from the institutions that we think you would like", comment: "")
        
        let createProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        lbInfo.addGestureRecognizer(createProfileTapGesture)
        
        lbInfo.text = NSLocalizedString("Touch here to create a profile and find out which institutions that fit it", comment: "")
        
        print(Preferences.shared.userNeighborhood)
        print(Preferences.shared.userInterests!)
        
        matchingInstitutions = Array(institutionRepository.searchInstitutions(neighborhoods: [Preferences.shared.userNeighborhood], causes: Preferences.shared.userInterests!, donationType: [], volunteerType: [], days: [], periods: []))
    }
    
    @objc func showProfile() {
        let initialProfileViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_PROFILE_VIEW_STORYBOARD_ID)
        
        let navigationController = UINavigationController(rootViewController: initialProfileViewController)
        present(navigationController, animated: true, completion: nil)                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Preferences.shared.profileIsCreated {
            vInfo.isHidden = true
        }
    }
    
    @objc func showInstitution() {
        let i = InstitutionRepository()
        
        let institutionInformationViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        institutionInformationViewController.currentInstitution = i.getAllInstitutions().first
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    @objc func showEvent() {
        let eventViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.EVENT_VIEW_STORYBOARD_ID) as! EventViewController                
        
        present(eventViewController, animated: true, completion: nil)
    }

}

class CustomPeekCollectionView: MSPeekCollectionViewDelegateImplementation {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showInstitution"), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "showEvent"), object: nil)
        }
    }
    
}


extension MatchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Preferences.shared.profileIsCreated {
            return matchingInstitutions.count
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_CELL_IDENTIFIER, for: indexPath) as! InstitutionCollectionViewCell
        let currentInstitution = matchingInstitutions[indexPath.row]
        
        institutionCell.lbInstitutionName.text = currentInstitution.title
        institutionCell.ivInstitution.image = UIImage(named: "01")
        
        return institutionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.size.width / 2)-5), height: collectionView.frame.size.height)
    }
    
}
