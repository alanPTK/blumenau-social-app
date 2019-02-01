import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var tvAbout: UITextView!
    let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension ActionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionImageCell", for: indexPath) as! ActionImageCollectionViewCell
        actionImageCell.ivAction.image = actionsImages[indexPath.row]
        
        actionImageCell.ivAction.layer.masksToBounds = true
        actionImageCell.ivAction.layer.cornerRadius = 8
        actionImageCell.ivAction.clipsToBounds = true
        
        return actionImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullImageViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.FULL_IMAGE_VIEW_STORYBOARD_ID)
        present(fullImageViewController, animated: true, completion: nil)
    }


}
