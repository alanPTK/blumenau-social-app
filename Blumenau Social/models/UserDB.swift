import RealmSwift

class UserEvent: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var event: InstitutionEvent?
    @objc dynamic var confirmed: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
