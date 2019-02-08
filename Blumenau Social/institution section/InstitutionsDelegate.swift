import Foundation

protocol InstitutionsDelegate {
    func showInstitutions(institutions: [Institution])
    func showInstitutionsFromFilter(institutions: [Institution])
    func hideProgressHud()
}
