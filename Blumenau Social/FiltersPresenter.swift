import UIKit

class FiltersPresenter: NSObject {
    
    private var delegate: FiltersDelegate
    
    init(delegate: FiltersDelegate) {
        self.delegate = delegate
    }
    
    func getFilters() {
        if Reachability.isConnectedToNetwork() {
            delegate.showLoadingMessage(message: NSLocalizedString("Loading filters...", comment: ""))
            
            FilterService.getFilters(delegate: self)
        } else {
            delegate.hideLoadingMessage()
            
            delegate.showErrorMessage(message: NSLocalizedString("Without internet connection we can't synchronize the information.", comment: ""))
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
