import UIKit
import RealmSwift

struct FilterConstants {
    static let NEIGHBORHOODS = 0
    static let AREAS = 1
    static let DONATIONS = 2
    static let VOLUNTEERS = 3
}

struct FilterOption {
    var name: String = ""
    var id: Int = 0
    var image: String = ""
}

extension FilterOption: Equatable {}

func ==(lhs: FilterOption, rhs: FilterOption) -> Bool {
    let areEqual = lhs.id == rhs.id
    
    return areEqual
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var btShowInstitutions: UIButton!
    @IBOutlet weak var vBottomBar: UIView!
    
    private let filterOptionsRepository = FilterOptionsRepository()
    private var selectedOption: Int = 0
    private var filterOptions: [FilterOption] = []
    private var areas: [FilterOption] = []
    private var donations: [FilterOption] = []
    private var volunteers: [FilterOption] = []
    private var neighborhoods: [FilterOption] = []
    private var selectedAreas: [FilterOption] = []
    private var selectedDonations: [FilterOption] = []
    private var selectedVolunteers: [FilterOption] = []
    private var selectedNeighborhoods: [FilterOption] = []
    private var filterOptionsViewController: FilterOptionsViewController?
    private var preferences = Preferences.shared
    
    public var onDone:((_ selectedNeighborhoods: [FilterOption], _ selectedVolunteers: [FilterOption], _ selectedDonations: [FilterOption], _ selectedAreas: [FilterOption]) -> ())?

    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        for area in filterOptionsRepository.getAllAreas() {
            areas.append(FilterOption(name: area.name, id: area.id, image: area.image))
        }
        
        for donation in filterOptionsRepository.getAllDonations() {
            donations.append(FilterOption(name: donation.name, id: donation.id, image: donation.image))
        }
        
        for volunteer in filterOptionsRepository.getAllVolunteers() {
            volunteers.append(FilterOption(name: volunteer.name, id: volunteer.id, image: volunteer.image))
        }
        
        for neighborhood in filterOptionsRepository.getAllNeighborhoods() {
            neighborhoods.append(FilterOption(name: neighborhood.name, id: neighborhood.id, image: neighborhood.image))
        }
        
        preferences.showNeighborhoodsView = true
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        btShowInstitutions.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    /* When the user touches the button to finish the filtering calls the method onDone to pass the information */
    @IBAction func showInstitutions(_ sender: Any) {
        onDone?(selectedNeighborhoods, selectedVolunteers, selectedDonations, selectedAreas)
        
        dismiss(animated: true, completion: nil)
    }
    
    /* Before going to the next screen, set the selected filter options for the view */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        filterOptionsViewController = segue.destination as? FilterOptionsViewController
        
        filterOptionsViewController?.filterOptions = filterOptions
        filterOptionsViewController?.selectedOption = selectedOption
        
        filterOptionsViewController?.onDone = {(selectedFilterOptions: [FilterOption], selectedOption: Int) -> () in
            switch selectedOption {
                case FilterConstants.NEIGHBORHOODS:
                    self.selectedNeighborhoods = selectedFilterOptions
                case FilterConstants.AREAS:
                    self.selectedAreas = selectedFilterOptions
                case FilterConstants.DONATIONS:
                    self.selectedDonations = selectedFilterOptions
                case FilterConstants.VOLUNTEERS:
                    self.selectedVolunteers = selectedFilterOptions
                default:
                    break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(UIColor.backgroundColor())
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
}

extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /* The collection view should show only three items */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    /* Show the cell information, if it's the third cell, show the label "See More" */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {                
        if indexPath.row == 2 {
            let seeMoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.SEE_MORE_CELL_IDENTIFIER, for: indexPath) as! SeeMoreCollectionViewCell
            
            seeMoreCell.setupCell()
            seeMoreCell.loadInformation()
            
            return seeMoreCell
        } else {
            let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FILTER_CELL_IDENTIFIER, for: indexPath) as! FilterCollectionViewCell
            
            var filterOption: FilterOption!            
            
            filterCell.setupCell()
            
            switch collectionView.tag {
                case FilterConstants.NEIGHBORHOODS:
                    filterOption = neighborhoods[indexPath.row]
                case FilterConstants.AREAS:
                    filterOption = areas[indexPath.row]
                case FilterConstants.DONATIONS:
                    filterOption = donations[indexPath.row]
                case FilterConstants.VOLUNTEERS:
                    filterOption = volunteers[indexPath.row]
                default:
                    break
            }
            
            let filterImage = UIImage(named: filterOption.image)
            filterCell.ivIcon.image = filterImage
            
            filterCell.loadFilterInformation(filter: filterOption!)
            
            return filterCell
        }
    }
    
    /* The collection view should show three items side by side */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    /* Show more filter options when the user selects an item */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filterOptions = []
        selectedOption = collectionView.tag
        
        switch collectionView.tag {
            case FilterConstants.NEIGHBORHOODS:
                filterOptions = neighborhoods
            case FilterConstants.AREAS:
                filterOptions = areas
            case FilterConstants.DONATIONS:
                filterOptions = donations
            case FilterConstants.VOLUNTEERS:
                filterOptions = volunteers
            default:
                break
        }
        
        performSegue(withIdentifier: "segueToShowMoreOptions", sender: nil)
    }
    
}
