import Foundation

protocol InstitutionsDelegate {
    
    func showLoadingMessage(message: String)
    func hideLoadingMessage()
    func showErrorMessage(message: String)
    func showInstitutions(institutions: [Institution])
    func showInstitutionsFromFilter(institutions: [Institution])
    func onInstitutionSynchronizationFinish()
    
}
