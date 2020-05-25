import UIKit
import RealmSwift

class ProfileNeighborhoodSelectionViewController: UIViewController {
    
    private var neighborhoods: Results<Neighborhood>?
    private let filterOptionsRepository = FilterOptionsRepository()    
    private var selectedNeighborhoods: [Neighborhood] = []
    private var preferences = Preferences.shared
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        neighborhoods = filterOptionsRepository.getAllNeighborhoods()
        
        for neighborhoodId in preferences.userNeighborhoods {
            if let neighborhood = filterOptionsRepository.getNeighborhoodWithId(id: neighborhoodId) {
                selectedNeighborhoods.append(neighborhood)
            }
        }                
    }
    
    /* Go to the next screen */
    @IBAction func showProfileAvailability(_ sender: Any) {
        if neighborhoodsAreSelected() {
            let ids = selectedNeighborhoods.map { $0.id }            
            preferences.userNeighborhoods = ids
            
            performSegue(withIdentifier: "showProfileInterests", sender: nil)
            preferences.showNeighborhoodsView = true
        } else {
            Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Please, select your neighborhood before continuing", comment: ""), viewController: self)
        }
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("In which neighborhoods would you like to help ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }


    override func viewDidAppear(_ animated: Bool) {
        if preferences.showNeighborhoodsView {
            let alertController = UIAlertController(title: NSLocalizedString("Atenção", comment: ""), message: NSLocalizedString("Ficou em dúvida sobre as regiões ?", comment: ""), preferredStyle: .alert)
            let yesAction = UIAlertAction(title: NSLocalizedString("Sim", comment: ""), style: .default) { (action) in
                let neighborhoodsViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.NEIGHBORHOODS_VIEW_STORYBOARD_ID) as! NeighborhoodsViewController
                neighborhoodsViewController.modalPresentationStyle = .fullScreen
                
                self.present(neighborhoodsViewController, animated: true, completion: nil)
            }
            
            let noAction = UIAlertAction(title: NSLocalizedString("Não", comment: ""), style: .destructive, handler: nil)
            
            alertController.addAction(yesAction)
            alertController.addAction(noAction)
            
            present(alertController, animated: true, completion: nil)
            
            preferences.showNeighborhoodsView = false
        }
    }

}

extension ProfileNeighborhoodSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* Returns the number of cells that the collection view should show */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return neighborhoods?.count ?? 0
    }
    
    /* Show the cell information */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FILTER_CELL_IDENTIFIER, for: indexPath) as! FilterCollectionViewCell
        let currentNeighborhood = neighborhoods![indexPath.row]
        
        filterCell.setupCell()
        
        let index = selectedNeighborhoods.firstIndex(of: currentNeighborhood)
        
        filterCell.loadNeighborhoodInformation(neighborhood: currentNeighborhood, selected: index != nil)
        
        return filterCell                                
    }
    
    /* Before going to the next screen, check if a neighborhood is selected */
    func neighborhoodsAreSelected() -> Bool  {
        if selectedNeighborhoods.count == 0 {
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
        let selectedNeighborhood = neighborhoods![indexPath.row]
        
        let index = selectedNeighborhoods.firstIndex(of: selectedNeighborhood)
        if index == nil {
            selectedCell.ivIcon.alpha = 1.0            
            selectedNeighborhoods.append(selectedNeighborhood)
        } else {
            selectedCell.ivIcon.alpha = 0.3
            selectedNeighborhoods.remove(at: index!)
        }
    }    
    
}
