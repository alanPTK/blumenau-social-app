import UIKit

class InstitutionCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btSeeInfo: UIButton!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var tvAbout: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var vContainer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        vContainer.layer.cornerRadius = 8
    }
    
    func loadInformation(institution: Institution) {
        lbTitle.text = institution.title
        lbEmail.text = institution.mail
        lbAddress.text = institution.address
        lbPhone.text = institution.phone
        tvAbout.text = institution.about.first!.information
        btSeeInfo.setTitle(NSLocalizedString("Show more info", comment: ""), for: .normal)
    }
}
