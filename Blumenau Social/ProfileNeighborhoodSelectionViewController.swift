import UIKit
import RealmSwift

class ProfileNeighborhoodSelectionViewController: UIViewController {
    
    var neighborhoods: Results<Neighborhood>?
    let filterOptionsRepository = FilterOptionsRepository()
    var selectedNeighborhood: Neighborhood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        neighborhoods = filterOptionsRepository.getAllNeighborhoods()
        selectedNeighborhood = filterOptionsRepository.getNeighborhoodWithId(id: Preferences.shared.userNeighborhood)
        
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("In which neighborhood do you live ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension ProfileNeighborhoodSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (neighborhoods?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        let currentNeighborhood = neighborhoods![indexPath.row]
        
        filterCell.lbName.text = currentNeighborhood.name
        
        filterCell.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        filterCell.layer.borderWidth = 2.0
        filterCell.layer.cornerRadius = 8
        
        //if selectedNeighborhood == currentNeighborhood || Preferences.shared.userNeighborhood == currentNeighborhood.id {
        if Preferences.shared.userNeighborhood == currentNeighborhood.id {
            filterCell.ivIcon.image = UIImage(named: "0zrosa")
            filterCell.alpha = 1
        } else {
            filterCell.ivIcon.image = UIImage(named: "0z")
            filterCell.alpha = 0.5
        }
        
        
        return filterCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProfileAvailability" {
            if selectedNeighborhood == nil {
                showMissingNeighborhood()
            }
        }
    }
    
    func showMissingNeighborhood() {
        let alertController = UIAlertController(title: NSLocalizedString("Attention", comment: ""), message: NSLocalizedString("Please, select your neighborhood before continuing", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .destructive, handler: nil)
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        
        for indexPath in collectionView.indexPathsForVisibleItems {
            let selectedCell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            
            selectedCell.ivIcon.image = UIImage(named: "0z")
            selectedCell.alpha = 0.5
        }
        
        if selectedCell.alpha <= CGFloat(0.5) {
            selectedCell.alpha = 1.0
            
            selectedNeighborhood = neighborhoods![indexPath.row]
            selectedCell.ivIcon.image = UIImage(named: "0zrosa")
            
            Preferences.shared.userNeighborhood = (selectedNeighborhood?.id)!
        } else {
            selectedCell.alpha = 0.5
            selectedCell.ivIcon.image = UIImage(named: "0z")
        }
    }
    
    
}
