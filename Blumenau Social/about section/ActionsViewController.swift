import UIKit

class ActionsViewController: UIViewController {

    @IBOutlet weak var tvAbout: UITextView!
    let actionsImages: [UIImage] = [UIImage(named: "01")!, UIImage(named: "02")!, UIImage(named: "03")!, UIImage(named: "04")!, UIImage(named: "05")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //https://dl.dropboxusercontent.com/s/owjvi419ou8cisq/01.png
    //https://dl.dropboxusercontent.com/s/1cs8yxksscrksq6/02.png
    //https://dl.dropboxusercontent.com/s/dtgq3wt2seawu14/03.png
    //https://dl.dropboxusercontent.com/s/6lcbmuwqimn9f6c/04.png
    //https://dl.dropboxusercontent.com/s/l2jvxi7ieplf0zl/05.png
}

extension ActionsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionsImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let actionImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "actionImageCell", for: indexPath) as! ActionImageCollectionViewCell
        actionImageCell.ivAction.image = actionsImages[indexPath.row]
        
        return actionImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullImageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullImageViewController")
        present(fullImageViewController, animated: true, completion: nil)
    }


}
