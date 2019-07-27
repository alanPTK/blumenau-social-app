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
        
        let imageName = String(format: "atuacao_%d", area.id)
        ivIcon.image = UIImage(named: imageName)
                
        if selected {
            alpha = 1
        } else {
            alpha = 0.5
        }
    }
    
    func loadNeighborhoodInformation(neighborhood: Neighborhood, selected: Bool) {
        lbName.text = neighborhood.name
        
        let imageName = String(format: "bairro_%d", neighborhood.id)
        ivIcon.image = UIImage(named: imageName)
        
        if selected {
            alpha = 1
        } else {            
            alpha = 0.5
        }
    }
    
    func loadFilterInformation(filter: FilterOption) {
        lbName.text = filter.name
    }
    
}
