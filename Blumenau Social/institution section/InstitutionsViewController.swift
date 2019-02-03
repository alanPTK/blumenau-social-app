import UIKit
import JGProgressHUD
import RealmSwift

class InstitutionsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var tfSearchInstitutes: UITextField!
    
    var presenter: InstitutionsPresenter?
    var synchronizationService = SynchronizationService()
    var institutions: [Institution] = []
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = InstitutionsPresenter(delegate: self)
        
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
        
        tfSearchInstitutes.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search institutions, necessary donations, necessary volunteers, etc", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        tfSearchInstitutes.delegate = self
        tfSearchInstitutes.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        if !Preferences.shared.institutionsAreSynchronized || !Preferences.shared.filtersAreSynchronized {
            hud.textLabel.text = NSLocalizedString("Loading information, please wait...", comment: "")
            hud.show(in: self.view)
        }
        
        if !Preferences.shared.institutionsAreSynchronized {
            synchronizationService.synchronizeInstitutions { (result) in
                if result {
                    Preferences.shared.institutionsAreSynchronized = true
                    
                    DispatchQueue.main.async {
                        self.hud.dismiss(afterDelay: 1.0)
                        self.presenter?.getAllInstitutions()
                    }
                }
            }
        }
        
        if !Preferences.shared.filtersAreSynchronized {
            synchronizationService.synchronizeFilterOptions { (result) in
                if result {
                    DispatchQueue.main.async {
                        self.hud.dismiss(afterDelay: 1.0)
                    }
                    Preferences.shared.filtersAreSynchronized = true
                }
            }
        }
        
        synchronizationService.synchronizeEvents(completion: { (result) in
            if result {
                DispatchQueue.main.async {
                    self.hud.dismiss(afterDelay: 1.0)
                }
                Preferences.shared.eventsAreSynchronized = true
            }
        })
                
        presenter?.getAllInstitutions()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
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
    
    @IBAction func cleanFilters(_ sender: Any) {
        tfSearchInstitutes.text = ""
        presenter?.getAllInstitutions()
    }
    
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.FILTER_VIEW_STORYBOARD_ID) as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
        
        filterViewController.onDone = {(selectedNeighborhoods: [FilterOption], selectedVolunteers: [FilterOption], selectedDonations: [FilterOption], selectedAreas: [FilterOption]) -> () in
            
            self.presenter?.searchInstitutions(selectedNeighborhoods: selectedNeighborhoods, selectedAreas: selectedAreas, selectedDonations: selectedDonations, selectedVolunteers: selectedVolunteers, days: [], periods: [], limit: 0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Preferences.shared.profileCreationWasOpened {
            if Preferences.shared.institutionsAreSynchronized {
                let profileViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INITIAL_PROFILE_VIEW_STORYBOARD_ID) as! InitialProfileViewController
                present(profileViewController, animated: true, completion: nil)
                
                Preferences.shared.profileCreationWasOpened = true
            }
        }
    }

}

extension InstitutionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (institutions.count == 0) {
            cvInstitutions.setEmptyMessage(NSLocalizedString("No institution found", comment: ""))            
        } else {
            cvInstitutions.restore()
        }
        
        return institutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.INSTITUTION_CELL_IDENTIFIER, for: indexPath) as! InstitutionXCollectionViewCell
        let currentInstitution = institutions[indexPath.row]
        
        cell.layer.cornerRadius = 8
        
        cell.lbInstitutionName.text = currentInstitution.title
        cell.lbInstitutionPhone.text = currentInstitution.phone
        cell.lbInstitutionAddress.text = currentInstitution.address        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let institutionInformationViewController = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.INSTITUTION_VIEW_STORYBOARD_ID) as! InstitutionViewController
        let selectedInstitution = institutions[indexPath.row]
        
        institutionInformationViewController.currentInstitution = selectedInstitution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
}

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.titleColor()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}

extension InstitutionsViewController: InstitutionsDelegate {
    
    func showInstitutions(institutions: [Institution]) {
        self.institutions = institutions
        cvInstitutions.reloadData()
    }
    
}
