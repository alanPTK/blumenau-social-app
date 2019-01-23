import UIKit

class MatchViewController: UIViewController {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var btUpdateProfile: UIButton!
    @IBOutlet weak var ivProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()                
        
        let showProfileTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showProfile))
        ivProfile.addGestureRecognizer(showProfileTapRecognizer)
        ivProfile.isUserInteractionEnabled = true
    }
    
    @objc func showProfile() {
        let initialProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialProfileViewController")
        present(initialProfileViewController, animated: true, completion: nil)
    }

}

extension MatchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "institutionCell", for: indexPath) as! InstitutionCollectionViewCell
        
        institutionCell.ivInstitution.image = UIImage(named: "01")
        institutionCell.ivInstitution.layer.cornerRadius = 8
        
        institutionCell.layer.cornerRadius = 8
        institutionCell.layer.borderWidth = 0.4
        institutionCell.layer.borderColor = UIColor.titleColor().cgColor
        institutionCell.layer.borderWidth = 2.0
        
        return institutionCell
    }
    
}
