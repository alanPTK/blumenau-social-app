import UIKit

class InstitutionViewController: UIViewController {

    @IBOutlet weak var lcVolunteersHeight: NSLayoutConstraint!
    @IBOutlet weak var lcDonationsHeight: NSLayoutConstraint!
    @IBOutlet weak var lcScopeHeight: NSLayoutConstraint!
    @IBOutlet weak var lcWorkingHoursHeight: NSLayoutConstraint!
    @IBOutlet weak var vWorkingHours: UIView!
    @IBOutlet weak var vMainInformation: UIView!
    @IBOutlet weak var vContactInformation: UIView!
    @IBOutlet weak var tvWorkingHours: UITextView!
    @IBOutlet weak var tvScope: UITextView!
    @IBOutlet weak var vScope: UIView!
    @IBOutlet weak var vDonations: UIView!
    @IBOutlet weak var tvDonations: UITableView!
    @IBOutlet weak var vVolunteers: UIView!
    @IBOutlet weak var tvVolunteers: UITextView!
    @IBOutlet weak var vPictures: UIView!
    @IBOutlet weak var pcInstitutionPictures: UIPageControl!
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vMainInformation.layer.cornerRadius = 8
        vContactInformation.layer.cornerRadius = 8
        vWorkingHours.layer.cornerRadius = 8
        vScope.layer.cornerRadius = 8
        vDonations.layer.cornerRadius = 8
        vVolunteers.layer.cornerRadius = 8
        vPictures.layer.cornerRadius = 8
        
        tvWorkingHours.text = NSLocalizedString("about", comment: "")
        tvWorkingHours.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0);
        
        tvScope.text = NSLocalizedString("about", comment: "")
        tvScope.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0);
        
        tvVolunteers.text = NSLocalizedString("about", comment: "")
        tvVolunteers.textContainerInset = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        pcInstitutionPictures.pageIndicatorTintColor = UIColor.descColor()
        pcInstitutionPictures.currentPageIndicatorTintColor = UIColor.titleColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tvWorkingHours.setContentOffset(.zero, animated: false)
        tvWorkingHours.scrollRangeToVisible(NSRange(location:0, length:0))
        tvWorkingHours.isScrollEnabled = true
        
        tvScope.setContentOffset(.zero, animated: false)
        tvScope.scrollRangeToVisible(NSRange(location:0, length:0))
        tvScope.isScrollEnabled = true
        
        tvVolunteers.setContentOffset(.zero, animated: false)
        tvVolunteers.scrollRangeToVisible(NSRange(location:0, length:0))
        tvVolunteers.isScrollEnabled = true
        
        resizeTextView(textView: tvWorkingHours)
        resizeTextView(textView: tvScope)
        resizeTextView(textView: tvVolunteers)
        
        lcWorkingHoursHeight.constant = tvWorkingHours.frame.size.height + tvWorkingHours.frame.origin.y + 16
        lcScopeHeight.constant = tvScope.frame.size.height + tvScope.frame.origin.y + 16
        lcDonationsHeight.constant = tvDonations.contentSize.height + tvDonations.frame.origin.y + 16
        lcVolunteersHeight.constant = tvVolunteers.contentSize.height + tvVolunteers.frame.origin.y + 16
        
        UIView.animate(withDuration: 1.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        currentPage = Int(round(scrollView.contentOffset.x / view.frame.width))
        
        pcInstitutionPictures.currentPage = currentPage
    }
    
    func resizeTextView(textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    @IBAction func grow(_ sender: Any) {
        lcWorkingHoursHeight.constant += 1
    }
}

extension InstitutionViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.titleColor()
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.textLabel?.text = "Calçados"
        cell.textLabel?.backgroundColor = .clear
        cell.textLabel?.textAlignment = .center
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.titleColor().cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
    
}

extension InstitutionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ActionImageCollectionViewCell        
        imageCell.ivAction.image = UIImage(named: "01")
        
        return imageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }

}
