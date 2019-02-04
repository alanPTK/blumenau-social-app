import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var tvAbout: UITextView!
    private let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ActionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Return the amount of cells that the collection view should show */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsImages.count
    }

    /* Show the information in the cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ACTION_IMAGE_CELL_IDENTIFIER, for: indexPath) as! ActionImageCollectionViewCell
        
        actionImageCell.setupCell()
        actionImageCell.loadInformation(image: actionsImages[indexPath.row])                
        
        return actionImageCell
    }
    
    /* When the user selects an image, show the images in full screen */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullImageViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.FULL_IMAGE_VIEW_STORYBOARD_ID)
        present(fullImageViewController, animated: true, completion: nil)
    }


}
