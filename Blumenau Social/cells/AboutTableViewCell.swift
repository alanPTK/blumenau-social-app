import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lcAboutHeight: NSLayoutConstraint!
    @IBOutlet weak var btToggleVisibility: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell() {
        lbTitle.adjustsFontSizeToFitWidth = true
        lbTitle.minimumScaleFactor = 0.5                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func toggleAboutVisibility(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toggleAboutVisibility"), object: sender)
    }
    
    func loadInformation(about: InstitutionAbout, indexPath: IndexPath) {
        lbTitle.text = about.title
        tvDesc.text = about.information
        
        tvDesc.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        lcAboutHeight.constant = Utils.shared.resizeTextView(textView: tvDesc).height
        
        if indexPath.row == 0 {
            btToggleVisibility.isHidden = false
        } else {
            btToggleVisibility.isHidden = true
        }
    }
}
