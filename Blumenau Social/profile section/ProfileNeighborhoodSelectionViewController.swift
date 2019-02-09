import UIKit
import RealmSwift

class ProfileNeighborhoodSelectionViewController: UIViewController {
    
    private var neighborhoods: Results<Neighborhood>?
    private let filterOptionsRepository = FilterOptionsRepository()
    private var selectedNeighborhood: Neighborhood?
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        neighborhoods = filterOptionsRepository.getAllNeighborhoods()
        selectedNeighborhood = filterOptionsRepository.getNeighborhoodWithId(id: Preferences.shared.userNeighborhood)
    }
    
    /* Go to the next screen */
    @IBAction func showProfileAvailability(_ sender: Any) {
        if neighborhoodIsSelected() {
            performSegue(withIdentifier: "showProfileAvailability", sender: nil)
        } else {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, select your neighborhood before continuing", comment: ""), viewController: self)
        }
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("In which neighborhood do you live ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

}

extension ProfileNeighborhoodSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* Returns the number of cells that the collection view should show */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (neighborhoods?.count)!
    }
    
    /* Show the cell information */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FILTER_CELL_IDENTIFIER, for: indexPath) as! FilterCollectionViewCell
        let currentNeighborhood = neighborhoods![indexPath.row]
        
        filterCell.setupCell()
        
        filterCell.loadNeighborhoodInformation(neighborhood: currentNeighborhood, selected: preferences.userNeighborhood == currentNeighborhood.id)
        
        return filterCell
    }
    
    /* Before going to the next screen, check if a neighborhood is selected */
    func neighborhoodIsSelected() -> Bool  {
        if selectedNeighborhood == nil {
            return false
        }
        return true
    }
    
    /* The collection view should show three items side by side */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    /* Check if the neighborhood is selected and highlight it to the user */
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
            
            preferences.userNeighborhood = (selectedNeighborhood?.id)!
        } else {
            selectedCell.alpha = 0.5
            selectedCell.ivIcon.image = UIImage(named: "0z")
        }
    }    
    
}
