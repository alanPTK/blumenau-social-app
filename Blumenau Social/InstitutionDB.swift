import RealmSwift

class Institution: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var mail: String = ""
    @objc dynamic var responsible: String = ""
    @objc dynamic var workingHours: String = ""
    @objc dynamic var scope: String = ""
    @objc dynamic var volunteers: String = ""
    var donations = List<InstitutionDonation>()
    var causes = List<InstitutionCause>()
    var pictures = List<InstitutionPicture>()
    var about = List<InstitutionAbout>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class InstitutionDonation: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class InstitutionCause: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class InstitutionPicture: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var link: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class InstitutionAbout: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var information: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
