import UIKit

class FilterOptionsViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btFinishSelection: UIButton!
    @IBOutlet weak var vBottomBar: UIView!
    @IBOutlet weak var cvFilterOptions: UICollectionView!
    var filterOptions: [FilterOption] = []
    var selectedOption: Int = 0
    private var selectedFiltersOptions: [FilterOption] = []
    
    var onDone:((_ selectedFilterOptions: [FilterOption], _ selectedOption: Int) -> ())?
    
    /* Initialize all the necessary information for the view */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        btFinishSelection.titleLabel?.adjustsFontSizeToFitWidth = true
        
        switch selectedOption {
            case FilterConstants.NEIGHBORHOODS:
                lbTitle.text = NSLocalizedString("Blumenau neighborhoods", comment: "")
            case FilterConstants.AREAS:
                lbTitle.text = NSLocalizedString("Areas of activity", comment: "")
            case FilterConstants.DONATIONS:
                lbTitle.text = NSLocalizedString("Donations", comment: "")
            case FilterConstants.VOLUNTEERS:
                lbTitle.text = NSLocalizedString("Volunteers", comment: "")
            default:
                break
        }
    }
    
    /* When the user finishes the filter selection, call the method to pass the information to the previous view */
    @IBAction func finishSelection(_ sender: Any) {
        onDone?(selectedFiltersOptions, selectedOption)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(UIColor.backgroundColor())
    }
    
    func setStatusBarBackgroundColor(_ color: UIColor) {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
    }
}

extension FilterOptionsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /* Returns the number of cells that the collection view should show */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    /* Show the information in the cell */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.FILTER_CELL_IDENTIFIER, for: indexPath) as! FilterCollectionViewCell
        
        let currentFilterOption = filterOptions[indexPath.row]
        
        let filterImage = UIImage(named: currentFilterOption.image)
        
        filterCell.setupFilterOptionsCell()
        filterCell.loadFilterInformation(filter: currentFilterOption)
        filterCell.ivIcon.image = filterImage
        
        return filterCell
    }
    
    /* The collection view should show three items side by side */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    /* When the user selects a cell, highlight it to the user and change the image accordingly */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        let selectedFilterOption = filterOptions[indexPath.row]
        
        if selectedCell.alpha <= CGFloat(0.5) {
            let index = selectedFiltersOptions.firstIndex(of: selectedFilterOption)
            if index == nil {
                selectedFiltersOptions.append(selectedFilterOption)
            }
            selectedCell.alpha = 1.0
        } else {
            let index = selectedFiltersOptions.firstIndex(of: selectedFilterOption)
            if index != nil {
                selectedFiltersOptions.remove(at: index!)
            }                        
            selectedCell.alpha = 0.5
        }
    }
    
}
