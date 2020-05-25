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
        layer.borderColor = UIColor.titleColor().cgColor
        layer.borderWidth = 0.0
        layer.cornerRadius = 8                
    }
    
    func setupFilterOptionsCell() {
        lbName.textColor = UIColor.titleColor()
        
        layer.borderColor = UIColor.titleColor().cgColor
        layer.borderWidth = 0.0
        layer.cornerRadius = 8
        alpha = 0.5
    }
    
    func loadAreaInformation(area: Area, selected: Bool) {
        lbName.text = area.name
                
        ivIcon.image = UIImage(named: area.image)
                
        if selected {
            ivIcon.alpha = 1
        } else {
            ivIcon.alpha = 0.3
        }
    }
    
    func loadNeighborhoodInformation(neighborhood: Neighborhood, selected: Bool) {
        if neighborhood.name == "Sem endereço físico" {
            lbName.text = "Outro"
        } else {
            lbName.text = neighborhood.name
        }
        
        ivIcon.image = UIImage(named: neighborhood.image)
        
        if selected {
            ivIcon.alpha = 1
        } else {            
            ivIcon.alpha = 0.3
        }
    }
    
    func loadFilterInformation(filter: FilterOption) {
        lbName.text = filter.name
    }
    
}
