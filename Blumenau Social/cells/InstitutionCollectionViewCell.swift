import UIKit

class InstitutionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lbInstitutionName: UILabel!
    @IBOutlet weak var ivInstitution: UIImageView!
    
    func loadInformation(institution: Institution) {
        lbInstitutionName.text = institution.title
        ivInstitution.image = UIImage(named: "01") //TODO
    }
    
    func loadEvent(event: InstitutionEvent) {
        //lbInstitutionName.text = event.title
        ivInstitution.image = UIImage(named: "01") //TODO
    }
}
