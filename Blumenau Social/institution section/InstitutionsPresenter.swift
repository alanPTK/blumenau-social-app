import UIKit
import RealmSwift

class InstitutionsPresenter {
    
    private var delegate: InstitutionsDelegate
    private var institutionRepository = InstitutionRepository()
    private let synchronizationService = SynchronizationService()
    private let preferences = Preferences.shared
    
    init(institutionRepository: InstitutionRepository, delegate: InstitutionsDelegate) {
        self.delegate = delegate
        self.institutionRepository = institutionRepository
    }
    
    init(delegate: InstitutionsDelegate) {
        self.delegate = delegate
    }
    
    /* Get all the institutions */
    func getAllInstitutions() {
        let institutions = institutionRepository.getAllInstitutions()
        delegate.showInstitutions(institutions: institutions)
    }
    
    /* Search institutions by title, donation needs, volunteers needs, etc */
    func searchInstitutions(text: String) {
        let institutions = institutionRepository.searchInstitutions(text: text)
        delegate.showInstitutionsFromFilter(institutions: institutions)
    }
    
    /* Search institutions by neighborhoods, causes, donations, available days and available periods */
    func searchInstitutions(selectedNeighborhoods: [FilterOption], selectedAreas: [FilterOption], selectedDonations: [FilterOption], selectedVolunteers: [FilterOption], days: [Int], periods: [Int], limit: Int) {
        
        let neighborhoodsToFilter = selectedNeighborhoods.map { $0.id }
        let volunteersToFilter = selectedVolunteers.map { $0.id }
        let donationsToFilter = selectedDonations.map { $0.id }
        let areasToFilter = selectedAreas.map { $0.id }
        
        if neighborhoodsToFilter.count > 0 || volunteersToFilter.count > 0 || donationsToFilter.count > 0 || areasToFilter.count > 0 {
            let institutions = institutionRepository.searchInstitutions(neighborhoods: neighborhoodsToFilter, causes: areasToFilter, donationType: donationsToFilter, volunteerType: volunteersToFilter, days: [], periods: [], limit: 0)
            delegate.showInstitutions(institutions: institutions)
        }
    }
    
    /* Load institutions from the web api */
    func getInstitutionsFromApi() {
        //if !preferences.institutionsAreSynchronized {
        if true {
            if Reachability.isConnectedToNetwork() {
                synchronizationService.synchronizeInstitutions { (result) in
                    if result {
                        Preferences.shared.institutionsAreSynchronized = true
                        
                        DispatchQueue.main.async {
                            self.getAllInstitutions()
                            //self.getEventsFromApi()
                            self.delegate.hideProgressHud()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Without internet connection we can't synchronize the information.", comment: ""), viewController: nil)
                    self.delegate.hideProgressHud()
                }
            }
        }
    }
    
    /* Load filters from the web api */
    func getFiltersFromApi() {
        if !preferences.filtersAreSynchronized {
            if Reachability.isConnectedToNetwork() {
                synchronizationService.synchronizeFilterOptions { (result) in
                    if result {
                        DispatchQueue.main.async {
                            self.delegate.hideProgressHud()
                        }
                        self.preferences.filtersAreSynchronized = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    Utils.shared.showDefaultAlertWithMessage(message: NSLocalizedString("Without internet connection we can't synchronize the information.", comment: ""), viewController: nil)
                    self.delegate.hideProgressHud()
                }
            }            
        }
    }
    
    /* Load events from the web */
    func getEventsFromApi() {
        if !preferences.eventsAreSynchronized {
            synchronizationService.synchronizeEvents(completion: { (result) in
                if result {
                    self.preferences.eventsAreSynchronized = true
                }
            })
        }
    }
    
}
