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
    func getInstitutions(forceSync: Bool) {
        delegate.showLoadingMessage(message: NSLocalizedString("Loading institutions...", comment: ""))
        
        if Utils.shared.shouldSyncInformation(information: Constants.INSTITUTIONS) || forceSync {
            InstitutionService.getInstitutions(delegate: self)
            
            delegate.onInstitutionSynchronizationFinish()
        } else {
            let institutions = self.institutionRepository.getAllInstitutions()
            
            self.delegate.showInstitutions(institutions: institutions)
            
            self.delegate.hideLoadingMessage()
        }
    }
    
}

extension InstitutionsPresenter: InstitutionsServiceDelegate {
    
    func onInstitutionSuccess() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            let institutions = self.institutionRepository.getAllInstitutions()
            
            self.delegate.showInstitutions(institutions: institutions)
            
            self.delegate.hideLoadingMessage()
        }
    }
    
    func onInstitutionFailure(errorMessage: String) {
        delegate.hideLoadingMessage()
        
        delegate.showErrorMessage(message: errorMessage)
    }
    
}
