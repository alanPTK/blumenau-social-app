import UIKit

class FilterOptionsViewController: UIViewController {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var btFinishSelection: UIButton!
    @IBOutlet weak var vBottomBar: UIView!
    @IBOutlet weak var cvFilterOptions: UICollectionView!
    var filterOptions: [FilterOption] = []
    var selectedOption: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btFinishSelection.titleLabel?.adjustsFontSizeToFitWidth = true
        
        switch selectedOption {
            case 0:
                lbTitle.text = NSLocalizedString("Blumenau neighborhoods", comment: "")
            case 1:
                lbTitle.text = NSLocalizedString("Areas of activity", comment: "")
            case 2:
                lbTitle.text = NSLocalizedString("Donations", comment: "")
            case 3:
                lbTitle.text = NSLocalizedString("Volunteers", comment: "")
            default:
                lbTitle.text = ""
        }
    }
    
    @IBAction func finishSelection(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension FilterOptionsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        
        let currentFilterOption = filterOptions[indexPath.row]
        
        //filterCell.ivIcon.image = UIImage(named: "icon")
        filterCell.lbName.text = currentFilterOption.name
        filterCell.lbName.isHidden = true
        filterCell.layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        filterCell.layer.borderWidth = 2.0
        filterCell.layer.cornerRadius = 8
        filterCell.alpha = 0.5
        
        switch indexPath.row {
            case 0:
                filterCell.ivIcon.image = UIImage(named: "0x")
            case 1:
                filterCell.ivIcon.image = UIImage(named: "0z")
            case 2:
                filterCell.ivIcon.image = UIImage(named: "0y")
            default:
                print("")
        }
        
        return filterCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((collectionView.frame.width / 3) - 10), height: ((collectionView.frame.width / 3) - 10))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        
        switch indexPath.row {
            case 0:
                selectedCell.ivIcon.image = UIImage(named: "0xrosa")
            case 1:
                selectedCell.ivIcon.image = UIImage(named: "0zrosa")
            case 2:
                selectedCell.ivIcon.image = UIImage(named: "0yrosa")
            default:
                print("")
        }
        
        
        if selectedCell.alpha <= CGFloat(0.5) {
            selectedCell.alpha = 1.0
        } else {
            selectedCell.alpha = 0.5
        }
    }
    
}
