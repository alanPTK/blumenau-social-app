import UIKit

class AboutTableViewCell: UITableViewCell {

    @IBOutlet weak var tvDesc: UITextView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lcAboutHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
