import UIKit
import RealmSwift

class FilterOptionsRepository: NSObject {
    
    private var realm: Realm
    
    override init() {
        realm = try! Realm()
    }
    
    /* Get all the areas from the database */
    func getAllAreas() -> Results<Area> {
        return realm.objects(Area.self)
    }
    
    /* Get all the donations from the database */
    func getAllDonations() -> Results<Donation> {
        return realm.objects(Donation.self)
    }
    
    /* Get all the neighborhood from the database */
    func getAllNeighborhoods() -> Results<Neighborhood> {
        return realm.objects(Neighborhood.self)
    }
    
    /* Get a neighborhood from the database with the id */
    func getNeighborhoodWithId(id: Int) -> Neighborhood? {
        return realm.objects(Neighborhood.self).filter("id = \(id)").first
    }
    
    /* Get a area from the database with the id */
    func getAreaWithId(id: Int) -> Area? {
        return realm.objects(Area.self).filter("id = \(id)").first
    }
    
    /* Get all the volunteers from the database */
    func getAllVolunteers() -> Results<Volunteer> {
        return realm.objects(Volunteer.self)
    }
    
    /* Save or update the area in the database */
    func saveArea(_ area: Area) {
        try! realm.write {
            realm.add(area, update: true)
        }
    }
    
    /* Save or update the donation in the database */
    func saveDonation(_ donation: Donation) {
        try! realm.write {
            realm.add(donation, update: true)
        }
    }
    
    /* Save or update the volunteer in the database */
    func saveVolunteer(_ volunteer: Volunteer) {
        try! realm.write {
            realm.add(volunteer, update: true)
        }
    }
    
    /* Save or update the neighborhood in the database */
    func saveNeighborhood(_ neighborhood: Neighborhood) {
        try! realm.write {
            realm.add(neighborhood, update: true)
        }
    }
    
    /* Create a new volunteer and save it in the database */
    func createVolunteerWithId(id: Int, name: String, image: String) {
        let volunteer = Volunteer()
        volunteer.id = id
        volunteer.name = name
        volunteer.image = image
        
        saveVolunteer(volunteer)
    }
    
    /* Create a new neighborhood and save it in the database */
    func createNeighborhoodWithId(id: Int, name: String, image: String) {
        let neighborhood = Neighborhood()
        neighborhood.id = id
        neighborhood.name = name
        neighborhood.image = image
        
        saveNeighborhood(neighborhood)
    }
    
    /* Create a new donation and save it in the database */
    func createDonationWithId(id: Int, name: String, image: String) {
        let donation = Donation()
        donation.id = id
        donation.name = name
        donation.image = image
        
        saveDonation(donation)
    }
    
    /* Create a new area and save it in the database */
    func createAreaWithId(id: Int, name: String, image: String) {
        let area = Area()
        area.id = id
        area.name = name
        area.image = image
        
        saveArea(area)
    }
    
}
