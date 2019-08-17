import UIKit

class FiltersPresenter: NSObject {
    
    private var delegate: FiltersDelegate
    
    init(delegate: FiltersDelegate) {
        self.delegate = delegate
    }
    
    func getFilters() {
        delegate.showLoadingMessage(message: NSLocalizedString("Loading filters...", comment: ""))
        
        if Utils.shared.shouldSyncInformation(information: Constants.FILTERS) {
            FilterService.getFilters(delegate: self)
        } else {
            delegate.hideLoadingMessage()
        }        
    }
    
}

extension FiltersPresenter: FiltersServiceDelegate {
    
    func onFilterSuccess() {
        delegate.hideLoadingMessage()
    }
    
    func onFilterFailure(errorMessage: String) {
        delegate.hideLoadingMessage()
        
        delegate.showErrorMessage(message: errorMessage)
    }
    
}
