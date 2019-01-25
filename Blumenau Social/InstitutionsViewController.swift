import UIKit
import JGProgressHUD
import RealmSwift

class InstitutionsViewController: UIViewController {
    
    @IBOutlet weak var cvInstitutions: UICollectionView!
    @IBOutlet weak var ivSearch: UIImageView!
    
    var synchronizationService = SynchronizationService()
    let institutionRepository = InstitutionRepository()
    var institutions: [Institution] = []
    let hud = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchInstitutionsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchInstitutions))
        ivSearch.addGestureRecognizer(searchInstitutionsTapRecognizer)
        ivSearch.isUserInteractionEnabled = true
        
        if !Preferences.shared.institutionsAreSynchronized || !Preferences.shared.filtersAreSynchronized {
            hud.textLabel.text = NSLocalizedString("Loading information, please wait...", comment: "")
            hud.show(in: self.view)
        }
        
        if !Preferences.shared.institutionsAreSynchronized {
            synchronizationService.synchronizeInstitutions { (result) in
                if result {
                    self.hud.dismiss(afterDelay: 3.0)
                    Preferences.shared.institutionsAreSynchronized = true
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
                }
            }
        }
        
        institutions = Array(institutionRepository.getAllInstitutions())
    }
    
    @objc func searchInstitutions() {
        let filterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        present(filterViewController, animated: true, completion: nil)
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
        
        present(institutionInformationViewController, animated: true, completion: nil)
    }
    
    
}
