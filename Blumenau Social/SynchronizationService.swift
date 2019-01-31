import UIKit

struct FilterX: Decodable {
    let neighborhoods: [NeighborhoodX]
    let areas: [AreaX]
    let donations: [DonationX]
    let volunteers: [VolunteerX]
}

struct NeighborhoodX: Decodable {
    let id: Int
    let name: String
}

struct AreaX: Decodable {
    let id: Int
    let name: String
}

struct DonationX: Decodable {
    let id: Int
    let name: String
}

struct VolunteerX: Decodable {
    let id: Int
    let name: String
}

struct Institutions: Decodable {
    let institutions: [InstitutionX]
}

struct InstitutionX: Decodable {
    let id: Int
    let title: String
    let subtitle: String
    let address: String
    let phone: String
    let mail: String
    let responsible: String
    let working_hours: String
    let days: [Int]
    let periods: [Int]
    let causes: [Int]
    let donation_type: [Int]
    let volunteer_type: [Int]
    let neighborhood: Int
    let scope: String
    let donations: [String]
    let volunteers: String
    let pictures: [String]
    let about: [AboutZ]
}

struct DonationZ: Decodable {
    let id: Int
    let title: String
}

struct CauseZ: Decodable {
    let id: Int
}

struct PictureZ: Decodable {
    let id: Int
    let link: String
}

struct AboutZ: Decodable {
    let title: String
    let information: String
}

class SynchronizationService: NSObject {
    
    let configuration = URLSessionConfiguration.default
    
    func synchronizeInstitutions(completion: @escaping (_ result: Bool) -> ()) {
        let session = URLSession(configuration: configuration)
        
        if let url = URL(string: Constants.INSTITUTIONS_DOWNLOAD_LINK) {
            let task = session.dataTask(with: url) {(data, response, error) in
                let institutionRepository = InstitutionRepository()
                
                guard let data = data else {
                    return
                }
                
                guard let institutions = try? JSONDecoder().decode(Institutions.self, from: data) else {
                    return
                }
                
                institutionRepository.createInstitutionWithData(institutionsData: institutions)
                
                completion(true)
            }
            
            task.resume()
        }
    }
    
    func synchronizeFilterOptions(completion: @escaping (_ result: Bool) -> ()) {
        let session = URLSession(configuration: configuration)
        let url = URL(string: Constants.FILTERS_DOWNLOAD_LINK)
        
        let task = session.dataTask(with: url!) {(data, response, error) in
            let filterOptionsRepository = FilterOptionsRepository()
            
            guard let data = data else {
                return
            }
            
            guard let filters = try? JSONDecoder().decode(FilterX.self, from: data) else {
                return
            }
            
            for neighborhoodResponse in filters.neighborhoods {
                filterOptionsRepository.createNeighborhoodWithId(id: neighborhoodResponse.id, name: neighborhoodResponse.name)                                
            }
            
            for areaResponse in filters.areas {
                filterOptionsRepository.createAreaWithId(id: areaResponse.id, name: areaResponse.name)
            }

            for donationResponse in filters.donations {
                filterOptionsRepository.createDonationWithId(id: donationResponse.id, name: donationResponse.name)
            }

            for volunteersResponse in filters.volunteers {
                filterOptionsRepository.createVolunteerWithId(id: volunteersResponse.id, name: volunteersResponse.name)                
            }
            
            completion(true)
        }
        
        task.resume()
    }

}
