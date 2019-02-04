import UIKit
import RealmSwift

class FullImageViewController: UIViewController {

    @IBOutlet weak var ivClose: UIImageView!
    
    let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    var institutionPictures: List<String>?
    var showInstitutionPictures: Bool = false
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeScreenTap = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        ivClose.addGestureRecognizer(closeScreenTap)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeScreen))
        swipeDownGestureRecognizer.direction = .down
        
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }        
    
    /* Dismiss the view when the user touches the close image */
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }

}

extension FullImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* Return the amount of cells that the collection view should show. */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if showInstitutionPictures {
            return (institutionPictures?.count)!
        } else {
            return actionsImages.count
        }
    }
    
    /* Show the information on the cell. If it is images from the institutions load using the Nuke library, else, load from the resources */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ACTION_IMAGE_CELL_IDENTIFIER, for: indexPath) as! ActionImageCollectionViewCell
        
        if showInstitutionPictures {
            if let pictures = institutionPictures {
                actionImageCell.loadInformationFromWeb(image: pictures[indexPath.row])                
            }
        } else {
            actionImageCell.loadInformation(image: actionsImages[indexPath.row])
        }
        
        return actionImageCell
    }
    
    /* The cell should occupy the whole collection view */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
        
}
