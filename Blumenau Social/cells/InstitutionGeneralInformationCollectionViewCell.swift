import UIKit

class InstitutionGeneralInformationCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var lbInstitutionAddress: UILabel!
    @IBOutlet weak var lbInstitutionPhone: UILabel!
    @IBOutlet weak var lbInstitutionName: UILabel!
    @IBOutlet weak var ivInstitutionImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupCell() {
        layer.cornerRadius = 8
    }
    
    func loadInformation(institution: Institution) {
        ivInstitutionImage.image = UIImage(named: institution.logo)
        lbInstitutionName.text = institution.title
        lbInstitutionPhone.text = institution.phone
        lbInstitutionAddress.text = institution.address
    }
    
}
