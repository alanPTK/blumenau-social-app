import UIKit

class InstitutionsPresenter {
    
    private var delegate: InstitutionsDelegate
    private let institutionRepository = InstitutionRepository()
    
    init(delegate: InstitutionsDelegate) {
        self.delegate = delegate
    }
    
    func getAllInstitutions() {
        let institutions = Array(institutionRepository.getAllInstitutions())
        delegate.showInstitutions(institutions: institutions)
    }
    
    func searchInstitutions(text: String) {
        let institutions = Array(institutionRepository.searchInstitutions(text: text))
        delegate.showInstitutions(institutions: institutions)
    }
    
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
    
}
