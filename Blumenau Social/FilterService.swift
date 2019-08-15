import UIKit

protocol FiltersServiceDelegate {
    
    func onFilterSuccess()
    func onFilterFailure(errorMessage: String)
    
}

class FilterService: NSObject {
    
    static private let preferences = Preferences.shared
    
    class func getFilters(delegate: FiltersServiceDelegate) {
        let configuration = URLSessionConfiguration.default
        
        let session = URLSession(configuration: configuration)
        let url = URL(string: Constants.FILTERS_DOWNLOAD_LINK)
        
        let task = session.dataTask(with: url!) {(data, response, error) in
            let filterOptionsRepository = FilterOptionsRepository()
            
            guard let data = data else {
                return
            }
            
            guard let filters = try? JSONDecoder().decode(FilterDecodable.self, from: data) else {
                return
            }
            
            for neighborhoodResponse in filters.neighborhoods {
                filterOptionsRepository.createNeighborhoodWithId(id: neighborhoodResponse.id, name: neighborhoodResponse.name, image: neighborhoodResponse.image)
            }
            
            for areaResponse in filters.areas {
                filterOptionsRepository.createAreaWithId(id: areaResponse.id, name: areaResponse.name, image: areaResponse.image)
            }
            
            for donationResponse in filters.donations {
                filterOptionsRepository.createDonationWithId(id: donationResponse.id, name: donationResponse.name, image: donationResponse.image)
            }
            
            for volunteersResponse in filters.volunteers {
                filterOptionsRepository.createVolunteerWithId(id: volunteersResponse.id, name: volunteersResponse.name, image: volunteersResponse.image)
            }
            
            delegate.onFilterSuccess()
        }
        
        task.resume()
    }
    
}
