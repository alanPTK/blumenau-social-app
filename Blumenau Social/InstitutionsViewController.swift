import UIKit
import JGProgressHUD
import RealmSwift

class InstitutionsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var ivSearch: UIImageView!
    @IBOutlet weak var tfSearchInstitutes: UITextField!
    
    var synchronizationService = SynchronizationService()
    let institutionRepository = InstitutionRepository()
    var institutions: [Institution] = []
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("reload"), object: nil)
        
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
        
        tfSearchInstitutes.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search institutions", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        tfSearchInstitutes.delegate = self
        
        if !Preferences.shared.institutionsAreSynchronized || !Preferences.shared.filtersAreSynchronized {
            hud.textLabel.text = NSLocalizedString("Loading information, please wait...", comment: "")
            hud.show(in: self.view)
        }
        
        if !Preferences.shared.institutionsAreSynchronized {
            synchronizationService.synchronizeInstitutions { (result) in
                if result {
                    let i = InstitutionRepository()
                    for ix in i.getAllInstitutions() {
                        for d in ix.days {
                            print(d)
                        }
                    }
                    Preferences.shared.institutionsAreSynchronized = true
                    
                    DispatchQueue.main.async {
                        self.hud.dismiss(afterDelay: 1.0)
                        self.institutions = Array(self.institutionRepository.getAllInstitutions())
                        self.cvInstitutions.reloadData()
                    }
                }
            }
        }
        
        if !Preferences.shared.filtersAreSynchronized {
            synchronizationService.synchronizeFilterOptions { (result) in
                if result {
                    let filterOptionsRepository = FilterOptionsRepository()
                    
                    let neighborhoods = filterOptionsRepository.getAllNeighborhoods()
                    let areas = filterOptionsRepository.getAllAreas()
                    let donations = filterOptionsRepository.getAllDonations()
                    let volunteers = filterOptionsRepository.getAllVolunteers()
                    
                    for neighborhood in neighborhoods {
                        print(neighborhood.name)
                    }
                    
                    for area in areas {
                        print(area.name)
                    }
                    
                    for donation in donations {
                        print(donation.name)
                    }
                    
                    for volunteer in volunteers {
                        print(volunteer.name)
                    }
                    
                    self.hud.dismiss(afterDelay: 3.0)
                    Preferences.shared.filtersAreSynchronized = true
                    
                    
                    //NotificationCenter.default.post(name: NSNotification.Name("reload"), object: nil)
                }
            }
        }
        
        institutions = Array(institutionRepository.getAllInstitutions())
//        institutions = Array(institutionRepository.searchInstitutions(neighborhoods: [1], causes: [1], donationType: [1], volunteerType: [1], days: [1], periods: [1]))
//        for i in institutions {
//            print(i.title)
//        }
    }
    
    @objc func reload() {
        institutions = Array(institutionRepository.getAllInstitutions())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
    
    func reloadInstitutions() {
        cvInstitutions.reloadData()
    }
    
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
        
        filterViewController.onDone = {(selectedNeighborhoods: [FilterOption], selectedVolunteers: [FilterOption], selectedDonations: [FilterOption], selectedAreas: [FilterOption]) -> () in                        
            
            let neighborhoodsToFilter = selectedNeighborhoods.map{ $0.id }
            let volunteersToFilter = selectedVolunteers.map{ $0.id }
            let donationsToFilter = selectedDonations.map{ $0.id }
            let areasToFilter = selectedAreas.map{ $0.id }
            
            self.institutions = Array(self.institutionRepository.searchInstitutions(neighborhoods: neighborhoodsToFilter, causes: areasToFilter, donationType: donationsToFilter, volunteerType: volunteersToFilter, days: [1], periods: [1]))
            self.cvInstitutions.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !Preferences.shared.profileCreationWasOpened {
            let profileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InitialProfileViewController") as! InitialProfileViewController
            present(profileViewController, animated: true, completion: nil)

            Preferences.shared.profileCreationWasOpened = true
        }
    }

}

extension InstitutionsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return institutions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "institutionCell", for: indexPath) as! InstitutionXCollectionViewCell
        let currentInstitution = institutions[indexPath.row]
        
        cell.layer.cornerRadius = 8
        
        cell.lbInstitutionName.text = currentInstitution.title
        cell.lbInstitutionPhone.text = currentInstitution.phone
        cell.lbInstitutionAddress.text = currentInstitution.address        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let institutionInformationViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstitutionViewController") as! InstitutionViewController
        let selectedInstitution = institutions[indexPath.row]
        
        institutionInformationViewController.currentInstitution = selectedInstitution
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    
}
