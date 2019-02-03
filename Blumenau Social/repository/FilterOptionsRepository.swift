import UIKit
import RealmSwift

class FilterOptionsRepository: NSObject {
    
    private var realm: Realm
    
    override init() {
        realm = try! Realm()
    }
    
    func getAllAreas() -> Results<Area> {
        return realm.objects(Area.self)
    }
    
    func getAllDonations() -> Results<Donation> {
        return realm.objects(Donation.self)
    }
    
    func getAllNeighborhoods() -> Results<Neighborhood> {
        return realm.objects(Neighborhood.self)
    }
    
    func getNeighborhoodWithId(id: Int) -> Neighborhood? {
        return realm.objects(Neighborhood.self).filter("id = \(id)").first
    }
    
    func getAreaWithId(id: Int) -> Area? {
        return realm.objects(Area.self).filter("id = \(id)").first
    }
    
    func getAllVolunteers() -> Results<Volunteer> {
        return realm.objects(Volunteer.self)
    }
    
    func createAreaWithId(id: Int, name: String) {
        let area = Area()
        area.id = id
        area.name = name
        
        saveArea(area)
    }
    
    func saveArea(_ area: Area) {
        try! realm.write {
            realm.add(area, update: true)
        }
    }
    
    func createDonationWithId(id: Int, name: String) {
        let donation = Donation()
        donation.id = id
        donation.name = name
        
        saveDonation(donation)
    }
    
    func saveDonation(_ donation: Donation) {
        try! realm.write {
            realm.add(donation, update: true)
        }
    }
    
    func createVolunteerWithId(id: Int, name: String) {
        let volunteer = Volunteer()
        volunteer.id = id
        volunteer.name = name
        
        saveVolunteer(volunteer)
    }
    
    func saveVolunteer(_ volunteer: Volunteer) {
        try! realm.write {
            realm.add(volunteer, update: true)
        }
    }
    
    func createNeighborhoodWithId(id: Int, name: String) {
        let neighborhood = Neighborhood()
        neighborhood.id = id
        neighborhood.name = name
        
        saveNeighborhood(neighborhood)
    }
    
    func saveNeighborhood(_ neighborhood: Neighborhood) {
        try! realm.write {
            realm.add(neighborhood, update: true)
        }
    }
    
}