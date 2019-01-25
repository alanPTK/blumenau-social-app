import UIKit
import RealmSwift

class InstitutionRepository: NSObject {
    
    private var realm: Realm    
    
    override init() {
        realm = try! Realm()
    }

    func getAllInstitutions() -> Results<Institution> {
        return realm.objects(Institution.self)
    }
    
    func saveInstitution(_ institution: Institution) {
        try! realm.write {
            realm.add(institution, update: true)
        }
    }        
}
