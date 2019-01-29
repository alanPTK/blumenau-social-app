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
            lbHighlightedInstitutions.text = String(format: NSLocalizedString("These are the institutions that fit your profile", comment: ""), Preferences.shared.userName)
        }
        
        lbMoreHighlightedInstitutions.text = NSLocalizedString("Events from the institutions that we think you would like", comment: "")
        
        let createProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        lbInfo.addGestureRecognizer(createProfileTapGesture)
        
        lbInfo.text = NSLocalizedString("Touch here to create a profile and find out which institutions that fit it", comment: "")        
    }
    
    @objc func showProfile() {
        let initialProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialProfileViewController")
        
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
        
        let institutionInformationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        institutionInformationViewController.currentInstitution = i.getAllInstitutions().first
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    @objc func showEvent() {
        let eventViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventViewController") as! EventViewController
        
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
            return 10
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "institutionCell", for: indexPath) as! InstitutionCollectionViewCell
                
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
