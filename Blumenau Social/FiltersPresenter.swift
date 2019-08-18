import UIKit

class FiltersPresenter: NSObject {
    
    private var delegate: FiltersDelegate
    
    init(delegate: FiltersDelegate) {
        self.delegate = delegate
    }
    
    func getFilters() {
        if Utils.shared.shouldSyncInformation(information: Constants.FILTERS) {
            FilterService.getFilters(delegate: self)
        }
    }
    
}

extension FiltersPresenter: FiltersServiceDelegate {
    
    func onFilterSuccess() {
        
    }
    
    func onFilterFailure(errorMessage: String) {                
        delegate.showErrorMessage(message: errorMessage)
    }
    
}
