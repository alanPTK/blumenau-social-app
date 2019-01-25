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
    
}
