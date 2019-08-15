import UIKit

protocol InstitutionsServiceDelegate {
    
    func onInstitutionSuccess()
    func onInstitutionFailure(errorMessage: String)
    
}

class InstitutionService: NSObject {
    
    static private let preferences = Preferences.shared
    
    class func getInstitutions(delegate: InstitutionsServiceDelegate) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        
        if let url = URL(string: Constants.INSTITUTIONS_DOWNLOAD_LINK) {
            let task = session.dataTask(with: url) {(data, response, error) in
                let institutionRepository = InstitutionRepository()
                
                guard let data = data else {
                    return
                }
                
                guard let institutions = try? JSONDecoder().decode(InstitutionsDecodable.self, from: data) else {
                    return
                }
                
                institutionRepository.createInstitutionWithData(institutionsData: institutions)
                
                delegate.onInstitutionSuccess()
            }
            
            task.resume()
        }
    }

}
