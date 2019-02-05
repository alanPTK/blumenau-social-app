import UIKit

class EventCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivEvent: UIImageView!
    @IBOutlet weak var vContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        vContainer.layer.cornerRadius = 8
        ivEvent.layer.cornerRadius = 8
        ivEvent.layer.borderWidth = 1.0
        ivEvent.layer.borderColor = UIColor.clear.cgColor
        ivEvent.layer.masksToBounds = true;
    }
    
    func loadEventInformation(event: InstitutionEvent) {
        ivEvent.image = UIImage(named: "01")
    }
}
