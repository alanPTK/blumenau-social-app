import UIKit
import RealmSwift
import Nuke

class FullImageViewController: UIViewController {

    @IBOutlet weak var ivClose: UIImageView!
    
    let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    var institutionPictures: List<String>?
    var showInstitutionPictures: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeScreenTap = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        ivClose.addGestureRecognizer(closeScreenTap)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeScreen))
        swipeDownGestureRecognizer.direction = .down
        
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }

}

extension FullImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showInstitutionPictures {
            return (institutionPictures?.count)!
        } else {
            return actionsImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ACTION_IMAGE_CELL_IDENTIFIER, for: indexPath) as! ActionImageCollectionViewCell
        if showInstitutionPictures {
            if let pictures = institutionPictures {
                let currentPicture = pictures[indexPath.row]
                if let pictureUrl = URL(string: currentPicture) {
                    Nuke.loadImage(with: pictureUrl, into: actionImageCell.ivAction)
                }
            }
        } else {
            actionImageCell.ivAction.image = actionsImages[indexPath.row]
        }
        
        return actionImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
