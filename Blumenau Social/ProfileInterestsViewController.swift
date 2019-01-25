import UIKit
import RealmSwift

class ProfileInterestsViewController: UIViewController {
    
    var areas: Results<Area>?
    let filterOptionsRepository = FilterOptionsRepository()
    var selectedAreas: [Area] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        areas = filterOptionsRepository.getAllAreas()
        
        UINavigationBar.appearance().barTintColor = UIColor.backgroundColor()
        
        let titleAttribute = [NSAttributedString.Key.foregroundColor: UIColor.titleColor()]
        
        navigationItem.title = NSLocalizedString("What are your interests ?", comment: "")
        navigationController?.navigationBar.titleTextAttributes = titleAttribute
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if let interests = Preferences.shared.userInterests {
            for areaId in interests {
                if let area = filterOptionsRepository.getAreaWithId(id: areaId) {
                    selectedAreas.append(area)
                }
            }
        }
    }

    @IBAction func finishProfile(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "initialViewController")
                
        let ids = selectedAreas.map { $0.id }
        
        Preferences.shared.userInterests = ids
    }
}

extension ProfileInterestsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (areas?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        let currentArea = areas![indexPath.row]
        
        filterCell.lbName.text = currentArea.name
        
        filterCell.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        filterCell.layer.borderWidth = 2.0
        filterCell.layer.cornerRadius = 8
        
        let index = selectedAreas.firstIndex(of: currentArea)
        
        if (index != nil) {
            filterCell.ivIcon.image = UIImage(named: "0xrosa")
            filterCell.alpha = 1
        } else {
            filterCell.ivIcon.image = UIImage(named: "0x")
            filterCell.alpha = 0.5
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
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
            selectedAreas.remove(at: index!)
            
            selectedCell.ivIcon.image = UIImage(named: "0x")
        }
    }
    
}
