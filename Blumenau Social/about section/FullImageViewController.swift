import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var ivClose: UIImageView!
    
    let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeScreenTap = UITapGestureRecognizer(target: self, action: #selector(closeScreen))
        ivClose.addGestureRecognizer(closeScreenTap)
    }
    
    @objc func closeScreen() {
        dismiss(animated: true, completion: nil)
    }

}

extension FullImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionImageCell", for: indexPath) as! ActionImageCollectionViewCell
        actionImageCell.ivAction.image = actionsImages[indexPath.row]
        
        return actionImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
