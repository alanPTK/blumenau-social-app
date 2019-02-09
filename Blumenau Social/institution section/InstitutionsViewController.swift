import UIKit
import JGProgressHUD
import RealmSwift

class InstitutionsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var tfSearchInstitutes: UITextField!
    
    private let preferences = Preferences.shared
    private var presenter: InstitutionsPresenter?
    private var institutions: [Institution] = []
    private let hud = JGProgressHUD(style: .dark)
    
    /* Initialize all the necessary information for the view and load the information from the Api */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        presenter = InstitutionsPresenter(delegate: self)
        
        if !preferences.institutionsAreSynchronized || !preferences.filtersAreSynchronized {
            hud.textLabel.text = NSLocalizedString("Loading information, please wait...", comment: "")
            hud.show(in: view)
        }
        
        presenter?.getInstitutionsFromApi()
        presenter?.getFiltersFromApi()
        
        presenter?.getAllInstitutions()                
    }
    
    /* Configure the visual aspects of the view components */
    func setupView() {
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
        
        tfSearchInstitutes.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search institutions, necessary donations, necessary volunteers, etc", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        tfSearchInstitutes.delegate = self
        tfSearchInstitutes.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    /* Hide the keyboard when the user press the return button */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
    /* When the user types something in the textfield, search institutions that matches the criteria */
    @objc func textDidChange(textField: UITextField) {
        if (textField.text?.isEmpty)! {
            presenter?.getAllInstitutions()
            
            view.endEditing(true)
        } else {
            if let text = textField.text {
                presenter?.searchInstitutions(text: text)
            }
        }
    }
    
    /* Clean the filters and reload all institutions */
    @IBAction func cleanFilters(_ sender: Any) {
        tfSearchInstitutes.text = ""
        presenter?.getAllInstitutions()
    }
    
    /* Presents the institution search view */
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: Constants.FILTER_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.FILTER_VIEW_STORYBOARD_ID) as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
        
        filterViewController.onDone = {(selectedNeighborhoods: [FilterOption], selectedVolunteers: [FilterOption], selectedDonations: [FilterOption], selectedAreas: [FilterOption]) -> () in
            
            self.presenter?.searchInstitutions(selectedNeighborhoods: selectedNeighborhoods, selectedAreas: selectedAreas, selectedDonations: selectedDonations, selectedVolunteers: selectedVolunteers, days: [], periods: [], limit: 0)
        }
    }

}

extension InstitutionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /* If there ano institutions, show a view with the information for the user */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if institutions.count == 0 {
            cvInstitutions.setEmptyMessage(NSLocalizedString("No institution found", comment: ""))            
        } else {
            cvInstitutions.restore()
        }
        
        return institutions.count
    }
    
    /* Load the cells with the institution information */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_GENERAL_INFORMATION_CELL_IDENTIFIER, for: indexPath) as! InstitutionGeneralInformationCollectionViewCell
        
        let currentInstitution = institutions[indexPath.row]
        
        cell.setupCell()
        cell.loadInformation(institution: currentInstitution)
        
        return cell
    }
    
    /* When the user selects an institution, show the institution profile view */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let institutionInformationViewController = UIStoryboard(name: Constants.INSTITUTION_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        let selectedInstitution = institutions[indexPath.row]
        
        institutionInformationViewController.currentInstitution = selectedInstitution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
}

extension UICollectionView {
    
    /* Create a background view with a label to show to the user that there are no institutions */
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.font = UIFont.boldSystemFont(ofSize: 15)
        messageLabel.textColor = UIColor.titleColor()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    /* Hides the background view from the collection view */
    func restore() {
        self.backgroundView = nil
    }
    
}

extension InstitutionsViewController: InstitutionsDelegate {
            
    func showInstitutionsFromFilter(institutions: [Institution]) {
        self.institutions = institutions
        cvInstitutions.reloadData()
    }
        
    /* Hides the progress hud */
    func hideProgressHud() {
        hud.dismiss(afterDelay: 1.0, animated: true)
    }
    
    /* Reload the collection view to show all the institutions found */
    func showInstitutions(institutions: [Institution]) {
        self.institutions = institutions
        cvInstitutions.reloadData()
    }
    
}
