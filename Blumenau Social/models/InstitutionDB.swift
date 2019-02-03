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
    @objc dynamic var neighborhood: Int = 0
    var days = List<InstitutionWorkingDay>()
    var periods = List<InstitutionWorkingPeriod>()
    var donations = List<InstitutionDonation>()
    var donationType = List<InstitutionDonationType>()
    var pictures = List<String>()
    var causes = List<InstitutionCause>()
    var events = List<InstitutionEvent>()
    var volunteerType = List<InstitutionVolunteerType>()
    var about = List<InstitutionAbout>()
    
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

class InstitutionCause: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionVolunteerType: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionDonation: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var desc: String = ""
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionDonationType: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionWorkingDay: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionWorkingPeriod: Object {
    @objc dynamic var internalId: String = ""
    @objc dynamic var id: Int = 0
    
    override static func primaryKey() -> String? {
        return "internalId"
    }
}

class InstitutionEvent: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var desc: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var time: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var day: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var year: Int = 0    
    @objc dynamic var startHour: Int = 0
    @objc dynamic var endHour: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
