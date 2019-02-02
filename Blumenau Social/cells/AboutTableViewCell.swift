import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lcAboutHeight: NSLayoutConstraint!
    @IBOutlet weak var btToggleVisibility: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func toggleAboutVisibility(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("toggleAboutVisibility"), object: sender)
    }
}
