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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared().isEnabled = true
        
        //window?.rootViewController
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        let url = URL(string: "https://dl.dropboxusercontent.com/s/dse0ddxn7ebd910/filters.json")
            
        let task = session.dataTask(with: url!) {(data, response, error) in
            let realm = try! Realm()
            
            guard let data = data else {
                return
            }
            
            if let result = String(data: data, encoding: .utf8) {
                print(result)
            }
            
            guard let filters = try? JSONDecoder().decode(FilterX.self, from: data) else {
                print("Error: Couldn't decode data into Blog")
                return
            }
            
            for neighborhoodResponse in filters.neighborhoods {
                let neighborhood = Neighborhood()
                neighborhood.id = neighborhoodResponse.id
                neighborhood.name = neighborhoodResponse.name
                self.saveNeighborhood(neighborhood, realm: realm)
            }
            
            for areaResponse in filters.areas {
                let area = Area()
                area.id = areaResponse.id
                area.name = areaResponse.name
                self.saveArea(area, realm: realm)
            }
            
            for donationResponse in filters.donations {
                let donation = Donation()
                donation.id = donationResponse.id
                donation.name = donationResponse.name
                self.saveDonation(donation, realm: realm)
            }
            
            for volunteersResponse in filters.volunteers {
                let volunteer = Volunteer()
                volunteer.id = volunteersResponse.id
                volunteer.name = volunteersResponse.name
                self.saveVolunteer(volunteer, realm: realm)
            }
        }
        
        //task.resume()
        
        let filterOptionsRepository = FilterOptionsRepository()
        
        let areas = filterOptionsRepository.getAllAreas()
        let donations = filterOptionsRepository.getAllDonations()
        let volunteers = filterOptionsRepository.getAllVolunteers()
        let neighborhoods = filterOptionsRepository.getAllNeighborhoods()
        
        for area in areas {
            print(area.name)
        }
        
        for donation in donations {
            print(donation.name)
        }
        
        for volunteer in volunteers {
            print(volunteer.name)
        }
        
        for neighborhood in neighborhoods {
            print(neighborhood.name)
        }                
        
        return true
    }
    
    func saveArea(_ area: Area, realm: Realm) {
        try! realm.write {
            realm.add(area)
        }
    }
    
    func saveDonation(_ donation: Donation, realm: Realm) {
        try! realm.write {
            realm.add(donation)
        }
    }
    
    func saveVolunteer(_ volunteer: Volunteer, realm: Realm) {
        try! realm.write {
            realm.add(volunteer)
        }
    }
    
    func saveNeighborhood(_ neighborhood: Neighborhood, realm: Realm) {
        try! realm.write {
            realm.add(neighborhood)
        }
    }


}
