import UIKit

class ActionImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivAction: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {        
        ivAction.layer.masksToBounds = true
        ivAction.layer.cornerRadius = 8
        ivAction.clipsToBounds = true
    }
    
    func loadInformation(image: UIImage) {
        ivAction.image = image
    }
}
