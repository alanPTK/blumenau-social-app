import UIKit

class SeeMoreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        layer.borderColor = UIColor(red: 0, green: 138.0/255.0, blue: 186.0/255.0, alpha: 1).cgColor
        layer.borderWidth = 0.0
        layer.cornerRadius = 8
    }
    
    func loadInformation() {
        lbTitle.text = NSLocalizedString("See more", comment: "")
    }
}
