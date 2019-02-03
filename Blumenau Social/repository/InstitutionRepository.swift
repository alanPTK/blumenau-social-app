import UIKit
import RealmSwift

class InstitutionRepository: NSObject {
    
    private var realm: Realm
    let userRepository = UserRepository()
    
    override init() {
        realm = try! Realm()
    }

    func getAllInstitutions() -> Results<Institution> {
        return realm.objects(Institution.self)
    }
    
    func getInstitutionWithId(id: Int) -> Institution? {
        return realm.objects(Institution.self).filter("id = \(id)").first
    }
    
    func getAllEvents() -> [InstitutionEvent] {
        return Array(realm.objects(InstitutionEvent.self))
    }
    
    func createEventWithData(eventData: EventsDecodable) {
        for event in eventData.events {
            if let institution = getInstitutionWithId(id: event.institution_id) {
                let institutionEvent: InstitutionEvent = InstitutionEvent()
                
                institutionEvent.id = event.id
                institutionEvent.address = event.address
                institutionEvent.date = event.date
                institutionEvent.time = event.time
                institutionEvent.title = event.title
                institutionEvent.desc = event.desc
                institutionEvent.day = event.day
                institutionEvent.month = event.month
                institutionEvent.year = event.year
                institutionEvent.startHour = event.start_hour
                institutionEvent.endHour = event.end_hour
                
                //institution.events.append(institutionEvent)
                
                saveEvent(institutionEvent)
                userRepository.createUserEvent(event: institutionEvent, attendance: false)
                //saveInstitution(institution)
            }
        }
    }
    
    func createInstitutionWithData(institutionsData: InstitutionsDecodable) {
        for institutionData in institutionsData.institutions {
            let institution: Institution = Institution()
            
            institution.id = institutionData.id
            institution.title = institutionData.title
            institution.subtitle = institutionData.subtitle
            institution.address = institutionData.address
            institution.phone = institutionData.phone
            institution.mail = institutionData.mail
            institution.responsible = institutionData.responsible
            institution.workingHours = institutionData.working_hours
            institution.scope = institutionData.scope
            institution.volunteers = institutionData.volunteers
            institution.neighborhood = institutionData.neighborhood
            
            for donation in institutionData.donations {
                let institutionDonation = InstitutionDonation()
                
                institutionDonation.internalId = UUID().uuidString
                institutionDonation.desc = donation
                
                saveDonation(institutionDonation)
                
                institution.donations.append(institutionDonation)
            }
            
            for picture in institutionData.pictures {
                institution.pictures.append(picture)
            }
            
            for cause in institutionData.causes {
                let institutionCause = InstitutionCause()
                
                institutionCause.internalId = UUID().uuidString
                institutionCause.id = cause
                
                saveCause(institutionCause)
                
                institution.causes.append(institutionCause)
            }

            for aboutData in institutionData.about {
                let about = InstitutionAbout()

                about.id = institutionAboutNextID()
                about.title = aboutData.title
                about.information = aboutData.information

                institution.about.append(about)
                saveAbout(about)
            }
            
            for day in institutionData.days {
                let institutionWorkingDay = InstitutionWorkingDay()
                
                institutionWorkingDay.internalId = UUID().uuidString
                institutionWorkingDay.id = day
                
                institution.days.append(institutionWorkingDay)
                saveWorkingDay(institutionWorkingDay)
            }
            
            for period in institutionData.periods {
                let institutionWorkingPeriod = InstitutionWorkingPeriod()
                
                institutionWorkingPeriod.internalId = UUID().uuidString
                institutionWorkingPeriod.id = period
                
                institution.periods.append(institutionWorkingPeriod)
                saveWorkingPeriod(institutionWorkingPeriod)
            }
            
            for donationType in institutionData.donation_type {
                let institutionDonationType = InstitutionDonationType()
                
                institutionDonationType.internalId = UUID().uuidString
                institutionDonationType.id = donationType
                
                institution.donationType.append(institutionDonationType)
                saveDonationType(institutionDonationType)
            }
            
            for volunteerType in institutionData.volunteer_type {
                let institutionVolunteerType = InstitutionVolunteerType()
                
                institutionVolunteerType.internalId = UUID().uuidString
                institutionVolunteerType.id = volunteerType
                
                institution.volunteerType.append(institutionVolunteerType)
                saveVolunteerType(institutionVolunteerType)
            }
            
            saveInstitution(institution)
        }
    }
    
    func institutionAboutNextID() -> Int {
        return (realm.objects(InstitutionAbout.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    func saveInstitution(_ institution: Institution) {
        try! realm.write {
            realm.add(institution, update: true)
        }
    }
    
    func saveAbout(_ about: InstitutionAbout) {
        try! realm.write {
            realm.add(about, update: true)
        }
    }
    
    func saveCause(_ cause: InstitutionCause) {
        try! realm.write {
            realm.add(cause, update: true)
        }
    }
    
    func saveEvent(_ event: InstitutionEvent) {
        try! realm.write {
            realm.add(event, update: true)
        }
    }
    
    func saveVolunteerType(_ volunteerType: InstitutionVolunteerType) {
        try! realm.write {
            realm.add(volunteerType, update: true)
        }
    }
    
    func saveDonationType(_ donationType: InstitutionDonationType) {
        try! realm.write {
            realm.add(donationType, update: true)
        }
    }
    
    func saveDonation(_ donation: InstitutionDonation) {
        try! realm.write {
            realm.add(donation, update: true)
        }
    }
    
    func saveWorkingDay(_ workingDay: InstitutionWorkingDay) {
        try! realm.write {
            realm.add(workingDay, update: true)
        }
    }
    
    func saveWorkingPeriod(_ workingPeriod: InstitutionWorkingPeriod) {
        try! realm.write {
            realm.add(workingPeriod, update: true)
        }
    }
    
    func searchInstitutions(neighborhoods: [Int], causes: [Int], donationType: [Int], volunteerType: [Int], days: [Int], periods: [Int], limit: Int) -> [Institution] {
        let neighborhoodPredicate = NSPredicate(format: "neighborhood in %@", Array(neighborhoods))
        let causePredicate = NSPredicate(format: "ANY causes.id IN %@", causes)
        let donationPredicate = NSPredicate(format: "ANY donationType.id IN %@", donationType)
        let volunteerPredicate = NSPredicate(format: "ANY volunteerType.id IN %@", volunteerType)
        
        let daysPredicate = NSPredicate(format: "ANY days.id IN %@", days)
        let periodsPredicate = NSPredicate(format: "ANY periods.id IN %@", periods)
        let workingTimePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [daysPredicate, periodsPredicate])
        
        let fullPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [neighborhoodPredicate, causePredicate, donationPredicate, volunteerPredicate, workingTimePredicate])
        
        if limit == 0 {
            return Array(realm.objects(Institution.self).filter(fullPredicate))
        } else {
            let institutions = realm.objects(Institution.self).filter(fullPredicate)
            if institutions.count > limit {
                return Array(institutions[0..<limit])
            } else {
                return Array(institutions)
            }
        }
    }
    
    func searchInstitutions(text: String) -> Results<Institution> {
        let titlePredicate = NSPredicate(format: "title contains [c] %@", text)
        let volunteerPredicate = NSPredicate(format: "volunteers contains [c] %@", text)
        let scopePredicate = NSPredicate(format: "scope contains [c] %@", text)
        let donationPredicate = NSPredicate(format: "ANY donations.desc contains [c] %@", text)
        
        let fullPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, volunteerPredicate, donationPredicate, scopePredicate])
        
        return realm.objects(Institution.self).filter(fullPredicate)
    }

}