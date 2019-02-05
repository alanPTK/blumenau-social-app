import UIKit

class EventCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ivEvent: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbEventDetail: UILabel!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var vInfoContainer: UIView!
    
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
        
        lbTitle.text = event.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let date = Utils.shared.createDateWithValues(day: event.day, month: event.month, year: event.year, hour: 0)
        let month = dateFormatter.string(from: date)
        let fullEventDetail = String(format: "%@ - %d de %@ de %d", "Lar Bethel", event.day, month, event.year)
        
        lbEventDetail.text = fullEventDetail
    }
}
