import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 8                
    }
    
    func setupFilterOptionsCell() {
        layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 8
        alpha = 0.5
    }
    
    func loadAreaInformation(area: Area, selected: Bool) {
        lbName.text = area.name
        
        //TODO, pegar os ícones certos
        if selected {
            ivIcon.image = UIImage(named: "0xrosa")
            alpha = 1
        } else {
            ivIcon.image = UIImage(named: "0x")
            alpha = 0.5
        }
    }
    
    func loadNeighborhoodInformation(neighborhood: Neighborhood, selected: Bool) {
        lbName.text = neighborhood.name
        
        //TODO, pegar os ícones certos
        if selected {
            ivIcon.image = UIImage(named: "0zrosa")
            alpha = 1
        } else {
            ivIcon.image = UIImage(named: "0z")
            alpha = 0.5
        }
    }
    
    func loadFilterInformation(filter: FilterOption) {
        lbName.text = filter.name
    }
    
}
