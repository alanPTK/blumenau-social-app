import UIKit
import RealmSwift
import IQKeyboardManager

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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        
        //window?.rootViewController
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        //let url = URL(string: "https://dl.dropboxusercontent.com/s/dse0ddxn7ebd910/filters.json")
        let url = URL(string: "https://dl.dropboxusercontent.com/s/gm3fhkh8lvwrp43/institutions.json")
        
        let task = session.dataTask(with: url!) {(data, response, error) in
            guard let data = data else {
                return
            }
            
            if let result = String(data: data, encoding: .utf8) {
                print(result)
            }
            
            guard let filters = try? JSONDecoder().decode(InstitutionX.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            
            let realm = try! Realm()
            
            let institution: Institution = Institution()
            institution.id = filters.id
            institution.title = filters.title
            institution.subtitle = filters.subtitle
            institution.address = filters.address
            institution.phone = filters.phone
            institution.mail = filters.mail
            institution.responsible = filters.responsible
            institution.workingHours = filters.working_hours
            institution.scope = filters.scope
            institution.volunteers = filters.volunteers
            
            print("id \(filters.id)")
            print("title \(filters.title)")
            print("subtitle \(filters.subtitle)")
            print("address \(filters.address)")
            print("phone \(filters.phone)")
            print("mail \(filters.mail)")
            print("responsible \(filters.responsible)")
            print("workingHours \(filters.working_hours)")
            print("scope \(filters.scope)")
            print("volunteers \(filters.volunteers)")

            for donationResponse in filters.donations {
                let donation = InstitutionDonation()
                donation.id = donationResponse.id
                donation.title = donationResponse.title
                
                institution.donations.append(donation)
                
                print("donationResponse.id \(donationResponse.id)")
                print("donationResponse.title \(donationResponse.title)")
            }

            for causeResponse in filters.causes {
                let cause = InstitutionCause()
                cause.id = causeResponse.id
                cause.title = causeResponse.title
                
                institution.causes.append(cause)
                
                print("causeResponse.id \(causeResponse.id)")
                print("causeResponse.title \(causeResponse.title)")
            }

            for pictureResponse in filters.pictures {
                let picture = InstitutionPicture()
                picture.id = pictureResponse.id
                picture.link = pictureResponse.link
                
                institution.pictures.append(picture)
                
                print("pictureResponse.id \(pictureResponse.id)")
                print("pictureResponse.link \(pictureResponse.link)")
            }

            for aboutResponse in filters.about {
                let about = InstitutionAbout()
                about.id = aboutResponse.id
                about.title = aboutResponse.title
                about.information = aboutResponse.information
                
                institution.about.append(about)
                
                print("aboutResponse.id \(aboutResponse.id)")
                print("aboutResponse.title \(aboutResponse.title)")
                print("aboutResponse.information \(aboutResponse.information)")
            }
            
            self.saveInstitution(institution, realm: realm)
            
//            for neighborhoodResponse in filters.neighborhoods {
//                let neighborhood = Neighborhood()
//                neighborhood.id = neighborhoodResponse.id
//                neighborhood.name = neighborhoodResponse.name
//                self.saveNeighborhood(neighborhood, realm: realm)
//            }
//
//            for areaResponse in filters.areas {
//                let area = Area()
//                area.id = areaResponse.id
//                area.name = areaResponse.name
//                self.saveArea(area, realm: realm)
//            }
//
//            for donationResponse in filters.donations {
//                let donation = Donation()
//                donation.id = donationResponse.id
//                donation.name = donationResponse.name
//                self.saveDonation(donation, realm: realm)
//            }
//
//            for volunteersResponse in filters.volunteers {
//                let volunteer = Volunteer()
//                volunteer.id = volunteersResponse.id
//                volunteer.name = volunteersResponse.name
//                self.saveVolunteer(volunteer, realm: realm)
//            }
        }
        
        task.resume()
            
//        let task = session.dataTask(with: url!) {(data, response, error) in
//            let realm = try! Realm()
//
//            guard let data = data else {
//                return
//            }
//
//            if let result = String(data: data, encoding: .utf8) {
//                print(result)
//            }
//
//            guard let filters = try? JSONDecoder().decode(FilterX.self, from: data) else {
//                print("Error: Couldn't decode data into Blog")
//                return
//            }
//
//            for neighborhoodResponse in filters.neighborhoods {
//                let neighborhood = Neighborhood()
//                neighborhood.id = neighborhoodResponse.id
//                neighborhood.name = neighborhoodResponse.name
//                self.saveNeighborhood(neighborhood, realm: realm)
//            }
//
//            for areaResponse in filters.areas {
//                let area = Area()
//                area.id = areaResponse.id
//                area.name = areaResponse.name
//                self.saveArea(area, realm: realm)
//            }
//
//            for donationResponse in filters.donations {
//                let donation = Donation()
//                donation.id = donationResponse.id
//                donation.name = donationResponse.name
//                self.saveDonation(donation, realm: realm)
//            }
//
//            for volunteersResponse in filters.volunteers {
//                let volunteer = Volunteer()
//                volunteer.id = volunteersResponse.id
//                volunteer.name = volunteersResponse.name
//                self.saveVolunteer(volunteer, realm: realm)
//            }
//        }
        
        //task.resume()
        
//        let filterOptionsRepository = FilterOptionsRepository()
//
//        let areas = filterOptionsRepository.getAllAreas()
//        let donations = filterOptionsRepository.getAllDonations()
//        let volunteers = filterOptionsRepository.getAllVolunteers()
//        let neighborhoods = filterOptionsRepository.getAllNeighborhoods()
//
//        for area in areas {
//            print(area.name)
//        }
//
//        for donation in donations {
//            print(donation.name)
//        }
//
//        for volunteer in volunteers {
//            print(volunteer.name)
//        }
//
//        for neighborhood in neighborhoods {
//            print(neighborhood.name)
//        }
        
        return true
    }
    
    func saveInstitution(_ institution: Institution, realm: Realm) {
        try! realm.write {            
            realm.add(institution, update: true)
        }
    }
    
    func saveArea(_ area: Area, realm: Realm) {
        try! realm.write {
            realm.add(area, update: true)
        }
    }
    
    func saveDonation(_ donation: Donation, realm: Realm) {
        try! realm.write {
            realm.add(donation, update: true)
        }
    }
    
    func saveVolunteer(_ volunteer: Volunteer, realm: Realm) {
        try! realm.write {
            realm.add(volunteer, update: true)
        }
    }
    
    func saveNeighborhood(_ neighborhood: Neighborhood, realm: Realm) {
        try! realm.write {
            realm.add(neighborhood, update: true)
        }
    }


}
