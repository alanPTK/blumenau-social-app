import UIKit
import MSPeekCollectionViewDelegateImplementation
import AVFoundation

class InstitutionsViewController: UIViewController {

    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var vContainer: UIView!    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var vTopBar: UIView!
    @IBOutlet weak var cvHighlightedInstitutions: UICollectionView!
    @IBOutlet weak var tvInstitutions: UITableView!
    @IBOutlet weak var tvInstitutions2: UICollectionView!
    var currentLayout: MyCollectionViewLayout? = nil
    let images = ["aLogo", "bLogo", "cLogo", "dLogo", "aLogo", "bLogo", "cLogo", "dLogo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
        
        if let layout = tvInstitutions2?.collectionViewLayout as? MyCollectionViewLayout {
            layout.delegate = self
            currentLayout = layout
        }
    }
    
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
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
        return images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let institutionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ActionImageCollectionViewCell
        
        institutionImageCell.layer.cornerRadius = 4
        institutionImageCell.layer.borderColor = UIColor.titleColor().cgColor
        institutionImageCell.layer.borderWidth = 2
        
        if let image = UIImage(named: images[indexPath.row]) {
            institutionImageCell.ivAction.image = image
            institutionImageCell.ivAction.layer.borderColor = UIColor.titleColor().cgColor
            institutionImageCell.ivAction.layer.cornerRadius = 8.0
        }
        
        return institutionImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let institutionInformationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
}

extension InstitutionsViewController : MyCollectionViewLayoutDelegate {
    
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let photo: UIImage = UIImage(named: images[indexPath.row])!
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: photo.size, insideRect: boundingRect)
        
        return rect.size.height
    }
}
