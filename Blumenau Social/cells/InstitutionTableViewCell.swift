import UIKit

class InstitutionTableViewCell: UITableViewCell {

    @IBOutlet weak var ivInstitutionImage: UIImageView!
    @IBOutlet weak var lbInstitutionName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
