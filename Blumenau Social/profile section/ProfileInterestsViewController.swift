import UIKit
import RealmSwift

class ProfileInterestsViewController: UIViewController {
    
    private var areas: Results<Area>?
    private let filterOptionsRepository = FilterOptionsRepository()
    private var selectedAreas: [Area] = []
    private var preferences = Preferences.shared

    /* Initialize all the necessary information for the view and load the area information */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        areas = filterOptionsRepository.getAllAreas()
                                
        for areaId in preferences.userInterests {
            if let area = filterOptionsRepository.getAreaWithId(id: areaId) {
                selectedAreas.append(area)
            }
        }
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("What are your interests ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    /* When the user finishes the profile, save the information and show the match screen */
    @IBAction func finishProfile(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_VIEW_STORYBOARD_ID)
                
        let ids = selectedAreas.map { $0.id }
        
        preferences.userInterests = ids
        preferences.profileIsCreated = true
        
        if let tabBarController = appDelegate.window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

extension ProfileInterestsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* Return the number of cells that the collection view should show */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (areas?.count)!
    }
    
    /* Show the information in the cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FILTER_CELL_IDENTIFIER, for: indexPath) as! FilterCollectionViewCell
        let currentArea = areas![indexPath.row]
        
        filterCell.setupCell()
        
        let index = selectedAreas.firstIndex(of: currentArea)
        
        filterCell.loadAreaInformation(area: currentArea, selected: index != nil)
        
        return filterCell
    }
    
    /* The collection view should show three items side by side */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    /* Check if the cause is selected and highlight it to the user */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        let selectedArea = areas![indexPath.row]
        
        if selectedCell.alpha <= CGFloat(0.5) {
            selectedCell.alpha = 1.0
            
            selectedAreas.append(selectedArea)
            selectedCell.ivIcon.image = UIImage(named: "0xrosa")
        } else {
            selectedCell.alpha = 0.5
            
            let index = selectedAreas.firstIndex(of: selectedArea)
            if (index != nil) {
                selectedAreas.remove(at: index!)
            }
            
            selectedCell.ivIcon.image = UIImage(named: "0x")
        }
    }
    
}
