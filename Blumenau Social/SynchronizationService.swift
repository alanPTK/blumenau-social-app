import UIKit

struct FilterDecodable: Decodable {
    let neighborhoods: [NeighborhoodDecodable]
    let areas: [AreaDecodable]
    let donations: [DonationDecodablex]
    let volunteers: [VolunteerDecodable]
}

struct NeighborhoodDecodable: Decodable {
    let id: Int
    let name: String
}

struct AreaDecodable: Decodable {
    let id: Int
    let name: String
}

struct DonationDecodablex: Decodable {
    let id: Int
    let name: String
}

struct VolunteerDecodable: Decodable {
    let id: Int
    let name: String
}

struct InstitutionsDecodable: Decodable {
    let institutions: [InstitutionDecodable]
}

struct InstitutionDecodable: Decodable {
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
    let about: [AboutDecodable]
}

struct DonationDecodable: Decodable {
    let id: Int
    let title: String
}

struct CauseDecodable: Decodable {
    let id: Int
}

struct PictureDecodable: Decodable {
    let id: Int
    let link: String
}

struct AboutDecodable: Decodable {
    let title: String
    let information: String
}

struct EventsDecodable: Decodable {
    let events: [EventDecodable]
}

struct EventDecodable: Decodable {
    let id: Int
    let desc: String
    let title: String
    let address: String
    let time: String
    let date: String
    let institution_id: Int
    let day: Int
    let month: Int
    let year: Int
    let start_hour: Int
    let end_hour: Int
}

class SynchronizationService: NSObject {
    
    let configuration = URLSessionConfiguration.default
    
    /* Synchronize the institutions from the Api */
    func synchronizeInstitutions(completion: @escaping (_ result: Bool) -> ()) {
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
                
                completion(true)
            }
            
            task.resume()
        }
    }
    
    /* Synchronize the events from the Api */
    func synchronizeEvents(completion: @escaping (_ result: Bool) -> ()) {
        let session = URLSession(configuration: configuration)
        
        if let url = URL(string: Constants.EVENTS_DOWNLOAD_LINK) {
            let task = session.dataTask(with: url) {(data, response, error) in
                let institutionRepository = InstitutionRepository()
                
                guard let data = data else {
                    return
                }
                
                guard let events = try? JSONDecoder().decode(EventsDecodable.self, from: data) else {
                    return
                }
                
                institutionRepository.createEventWithData(eventData: events)                                
                
                completion(true)
            }
            
            task.resume()
        }
    }
    
    /* Synchronize the filter options from the Api */
    func synchronizeFilterOptions(completion: @escaping (_ result: Bool) -> ()) {
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
