import UIKit
import RealmSwift

struct FilterOption {
    var name: String = ""
    var id: Int = 0
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var btShowInstitutions: UIButton!
    @IBOutlet weak var vBottomBar: UIView!
    
    let filterOptionsRepository = FilterOptionsRepository()
    var selectedOption: Int = 0
    var filterOptions: [FilterOption] = []
    var areas: [FilterOption] = []
    var donations: [FilterOption] = []
    var volunteers: [FilterOption] = []
    var neighborhoods: [FilterOption] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btShowInstitutions.titleLabel?.adjustsFontSizeToFitWidth = true
        
        for area in filterOptionsRepository.getAllAreas() {
            areas.append(FilterOption(name: area.name, id: area.id))
        }
        
        for donation in filterOptionsRepository.getAllDonations() {
            donations.append(FilterOption(name: donation.name, id: donation.id))
        }
        
        for volunteer in filterOptionsRepository.getAllVolunteers() {
            volunteers.append(FilterOption(name: volunteer.name, id: volunteer.id))
        }
        
        for neighborhood in filterOptionsRepository.getAllNeighborhoods() {
            neighborhoods.append(FilterOption(name: neighborhood.name, id: neighborhood.id))
        }
    }

    @IBAction func showInstitutions(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filterOptionsViewController = segue.destination as! FilterOptionsViewController
        
        filterOptionsViewController.filterOptions = filterOptions
        filterOptionsViewController.selectedOption = selectedOption
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {                
        if indexPath.row == 2 {
            let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeMoreCell", for: indexPath) as! SeeMoreCollectionViewCell
            
            filterCell.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
            filterCell.layer.borderWidth = 2.0
            filterCell.layer.cornerRadius = 8
            filterCell.lbTitle.text = "Veja \n mais"
            
            return filterCell
        } else {
            let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
            var filterOption: FilterOption?
            
            switch collectionView.tag {
                case 0:
                    filterOption = neighborhoods[indexPath.row]
                case 1:
                    filterOption = areas[indexPath.row]
                case 2:
                    filterOption = donations[indexPath.row]
                case 3:
                    filterOption = volunteers[indexPath.row]
                default:
                    print("hm")
            }
            
            switch collectionView.tag {
                case 0:
                    filterCell.ivIcon.image = UIImage(named: "0z")
                case 1:
                    filterCell.ivIcon.image = UIImage(named: "0x")
                case 2:
                    filterCell.ivIcon.image = UIImage(named: "0y")
                case 3:
                    filterCell.ivIcon.image = UIImage(named: "0y")
                default:
                    print("hm")
            }
            
            filterCell.lbName.text = filterOption?.name
            filterCell.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
            filterCell.layer.borderWidth = 2.0
            filterCell.layer.cornerRadius = 8
            
            return filterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterOptions = []
        selectedOption = collectionView.tag
        
        switch collectionView.tag {
            case 0:
                filterOptions = neighborhoods
            case 1:
                filterOptions = areas
            case 2:
                filterOptions = donations
            case 3:
                filterOptions = areas
            default:
                print("hm")
            }
        
        performSegue(withIdentifier: "segueToShowMoreOptions", sender: nil)
    }
    
}
