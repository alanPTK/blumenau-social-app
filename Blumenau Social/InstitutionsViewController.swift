import UIKit
import MSPeekCollectionViewDelegateImplementation

class InstitutionsViewController: UIViewController {

    @IBOutlet weak var btFilter: UIButton!
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var cvHighlightedInstitutions: UICollectionView!
    
    var peekImplementation: MSPeekCollectionViewDelegateImplementation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vTopBar.backgroundColor = UIColor.backgroundColor()
        vTopBar.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        vTopBar.layer.borderWidth = 2.0
        vTopBar.layer.cornerRadius = 8
        
        btFilter.titleLabel?.adjustsFontSizeToFitWidth = true
        
        peekImplementation = MSPeekCollectionViewDelegateImplementation()
//        peekImplementation.delegate = self
        
        cvHighlightedInstitutions.configureForPeekingDelegate()
        cvHighlightedInstitutions.delegate = peekImplementation
        cvHighlightedInstitutions.dataSource = self
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
        let info = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        present(info, animated: true, completion: nil)
    }
    
}

//class TestViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MSPeekImplementationDelegate {
//
//    @IBOutlet weak var cvStuff: UICollectionView!
//
//
//    func peekImplementation(_ peekImplementation: MSPeekCollectionViewDelegateImplementation, didChangeActiveIndexTo activeIndex: Int) {
//        print("ok")
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
//        let value =  (180 + CGFloat(indexPath.row)*20) / 255
//        cell.contentView.backgroundColor = UIColor(red: value, green: value, blue: value, alpha: 1)
//        return cell
//    }
//}
