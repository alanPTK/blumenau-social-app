import UIKit
import RealmSwift

class UserRepository: NSObject {
    
    private var realm: Realm
    
    override init() {
        realm = try! Realm()
    }
    
    /* Change the attendance status in the selected event */
    func changeAttendanceStatusForEvent(event: InstitutionEvent, attendance: Bool) {
        let userEvent = getUserEvent(event)
        
        if userEvent != nil {
            try! realm.write {
                userEvent?.confirmed = attendance
            }
            saveUserEvent(userEvent!)
        }
    }
    
    /* Create a new user event and save it in the database */
    func createUserEvent(event: InstitutionEvent, attendance: Bool) {
        if getUserEvent(event) == nil {
            let userEvent = UserEvent()
            
            userEvent.id = UUID().uuidString
            userEvent.event = event
            userEvent.confirmed = attendance
            
            saveUserEvent(userEvent)
        }
    }
    
    /* Save or update the user event in the database */
    func saveUserEvent(_ userEvent: UserEvent) {
        try! realm.write {
            realm.add(userEvent, update: true)
        }
    }
    
    /* Get the user event with the event parameters from the database */
    func getUserEvent(_ event: InstitutionEvent) -> UserEvent? {
        return realm.objects(UserEvent.self).filter("event.id = \(event.id)").first
    }
    
    /* Get all the user events from the database */
    func getUserEvents() -> Results<UserEvent> {
        return realm.objects(UserEvent.self)
    }

}
