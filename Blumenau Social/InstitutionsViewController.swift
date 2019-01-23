import UIKit
import MSPeekCollectionViewDelegateImplementation

class InstitutionsViewController: UIViewController {

    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var vContainer: UIView!    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var cvHighlightedInstitutions: UICollectionView!
    @IBOutlet weak var tvInstitutions: UITableView!
    var peekImplementation: MSPeekCollectionViewDelegateImplementation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showInstitution), name: Notification.Name(rawValue: "showInstitution"), object: nil)
        
        peekImplementation = XXX()
        
        cvHighlightedInstitutions.configureForPeekingDelegate()
        cvHighlightedInstitutions.delegate = peekImplementation
        cvHighlightedInstitutions.dataSource = self
        
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
    }
    
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
    }
    
    @objc func showInstitution() {
        let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        present(info, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Preferences.shared.profileCreationWasOpened {
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialProfileViewController") as! InitialProfileViewController
            present(profileViewController, animated: true, completion: nil)
            
            Preferences.shared.profileCreationWasOpened = true
        }
    }

}

extension InstitutionsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "institutionCell", for: indexPath) as! InstitutionCollectionViewCell
        
        institutionCell.ivInstitution.image = UIImage(named: "01")
        institutionCell.ivInstitution.layer.cornerRadius = 8
//        institutionCell.layer.cornerRadius = 8
//        institutionCell.layer.borderWidth = 0.4
//        institutionCell.layer.borderColor = UIColor.titleColor().cgColor
//        institutionCell.layer.borderWidth = 2.0
        
        return institutionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: ((collectionView.frame.size.width / 2)-5), height: collectionView.frame.size.height)
        }
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
}

extension InstitutionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "institutionCell", for: indexPath) as! InstitutionTableViewCell
        return cell
    }
    
}

class XXX: MSPeekCollectionViewDelegateImplementation {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showInstitution"), object: nil)
    }
    
}
