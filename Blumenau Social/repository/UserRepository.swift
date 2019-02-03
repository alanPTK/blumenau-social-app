import UIKit
import RealmSwift

class UserRepository: NSObject {
    
    private var realm: Realm
    
    override init() {
        realm = try! Realm()
    }
    
    func changeAttendanceStatusForEvent(event: InstitutionEvent, attendance: Bool) {
        let userEvent = getUserEvent(event)
        
        if userEvent != nil {
            try! realm.write {
                userEvent?.confirmed = attendance
            }
            saveUserEvent(userEvent!)
        }
    }
    
    func createUserEvent(event: InstitutionEvent, attendance: Bool) {
        if getUserEvent(event) == nil {
            let userEvent = UserEvent()
            
            userEvent.id = UUID().uuidString
            userEvent.event = event
            userEvent.confirmed = attendance
            
            saveUserEvent(userEvent)
        }
    }
    
    func saveUserEvent(_ userEvent: UserEvent) {
        try! realm.write {
            realm.add(userEvent, update: true)
        }
    }
    
    func getUserEvent(_ event: InstitutionEvent) -> UserEvent? {
        return realm.objects(UserEvent.self).filter("event.id = \(event.id)").first
    }
    
    func getUserEvents() -> Results<UserEvent> {
        return realm.objects(UserEvent.self)
    }

}
