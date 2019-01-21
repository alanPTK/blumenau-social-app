import UIKit

class MatchViewController: UIViewController {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var btUpdateProfile: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vTopBar.backgroundColor = UIColor.backgroundColor()
        vTopBar.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        vTopBar.layer.borderWidth = 2.0
        vTopBar.layer.cornerRadius = 8
        
        btUpdateProfile.titleLabel?.adjustsFontSizeToFitWidth = true
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
