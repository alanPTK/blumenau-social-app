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

struct InstitutionX: Decodable {
    let id: Int
    let title: String
    let subtitle: String
    let address: String
    let phone: String
    let mail: String
    let responsible: String
    let working_hours: String
    let donations: [DonationZ]
    let causes: [CauseZ]
    let scope: String
    let volunteers: String
    let pictures: [PictureZ]
    let about: [AboutZ]
}

struct DonationZ: Decodable {
    let id: Int
    let title: String
}

struct CauseZ: Decodable {
    let id: Int
    let title: String
}

struct PictureZ: Decodable {
    let id: Int
    let link: String
}

struct AboutZ: Decodable {
    let id: Int
    let title: String
    let information: String
}

class SynchronizationService: NSObject {
    
    let configuration = URLSessionConfiguration.default
    
    func synchronizeInstitutions(completion: @escaping (_ result: Bool) -> ()) {
        let session = URLSession(configuration: configuration)
        
        if let url = URL(string: "https://dl.dropboxusercontent.com/s/gm3fhkh8lvwrp43/institutions.json") {
            let task = session.dataTask(with: url) {(data, response, error) in
                let institutionRepository = InstitutionRepository()
                
                guard let data = data else {
                    return
                }
                
                guard let institutions = try? JSONDecoder().decode(InstitutionX.self, from: data) else {
                    return
                }
                
                let institution: Institution = Institution()
                institution.id = institutions.id
                institution.title = institutions.title
                institution.subtitle = institutions.subtitle
                institution.address = institutions.address
                institution.phone = institutions.phone
                institution.mail = institutions.mail
                institution.responsible = institutions.responsible
                institution.workingHours = institutions.working_hours
                institution.scope = institutions.scope
                institution.volunteers = institutions.volunteers
                
                for donationResponse in institutions.donations {
                    let donation = InstitutionDonation()
                    donation.id = donationResponse.id
                    donation.title = donationResponse.title
                    
                    institution.donations.append(donation)
                }
                
                for causeResponse in institutions.causes {
                    let cause = InstitutionCause()
                    cause.id = causeResponse.id
                    cause.title = causeResponse.title
                    
                    institution.causes.append(cause)
                }
                
                for pictureResponse in institutions.pictures {
                    let picture = InstitutionPicture()
                    picture.id = pictureResponse.id
                    picture.link = pictureResponse.link
                    
                    institution.pictures.append(picture)
                }
                
                for aboutResponse in institutions.about {
                    let about = InstitutionAbout()
                    about.id = aboutResponse.id
                    about.title = aboutResponse.title
                    about.information = aboutResponse.information
                    
                    institution.about.append(about)
                }
                
                institutionRepository.saveInstitution(institution)
                
                completion(true)
            }
            
            task.resume()
        }
    }
    
    func synchronizeFilterOptions(completion: @escaping (_ result: Bool) -> ()) {
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://dl.dropboxusercontent.com/s/dse0ddxn7ebd910/filters.json")
        
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
