import UIKit
import RealmSwift

struct MatchedInstitution {
    var institution: Institution
    var points: Int
}

class InstitutionRepository: NSObject {
    
    private var realm: Realm
    let userRepository = UserRepository()
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    override init() {
        realm = try! Realm()
    }

    /* Get all the institutions from the database */
    func getAllInstitutions() -> Array<Institution> {
        return Array(realm.objects(Institution.self))
    }
    
    /* Get a institution with the id from the database */
    func getInstitutionWithId(id: Int) -> Institution? {
        return realm.objects(Institution.self).filter("id = \(id)").first
    }
    
    /* Get all institutions with the ids from the database */
    func getInstitutionsWithIds(ids: [Int]) -> [Institution] {
        let predicate = NSPredicate(format: "id IN %@", ids)
        
        return Array(realm.objects(Institution.self).filter(predicate))
    }
    
    /* Get all the events from the database */
    func getAllEvents() -> [InstitutionEvent] {
        return Array(realm.objects(InstitutionEvent.self))
    }
    
    /* Get all the events from the institituions passed as parameter from the database */
    func getAllEventsFromInstitutions(institutions: [Institution]) -> Array<InstitutionEvent> {
        let ids = institutions.map { $0.id }
        
        return Array(realm.objects(InstitutionEvent.self).filter("id IN %@", ids))
    }
    
    /* Create a new event and save it in the database */
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
                institutionEvent.institutions.append(institution)
                
                saveEvent(institutionEvent)                
                
                try! realm.write {
                    institution.events.append(institutionEvent)
                }
                
                userRepository.createUserEvent(event: institutionEvent, attendance: false)
                saveInstitution(institution)
            }
        }
    }
    
    /* Create a new institution and save it in the database */
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
            institution.whatsapp = institutionData.whatsapp
            institution.workingHours = institutionData.working_hours
            institution.scope = institutionData.scope
            institution.volunteers = institutionData.volunteers
            institution.neighborhood = institutionData.neighborhood
            institution.logo = institutionData.logo
            institution.latitude = institutionData.latitude
            institution.longitude = institutionData.longitude

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
                about.title = "Sobre" //aboutData.title
                about.information = aboutData //aboutData.information

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
    
    /* Get the next ID for institution about */
    func institutionAboutNextID() -> Int {
        return (realm.objects(InstitutionAbout.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    /* Save or update the institution in the database */
    func saveInstitution(_ institution: Institution) {
        try! realm.write {
            realm.add(institution, update: .all)
        }
    }
    
    /* Save or update the about in the database */
    func saveAbout(_ about: InstitutionAbout) {
        try! realm.write {
            realm.add(about, update: .all)
        }
    }
    
    /* Save or update the cause in the database */
    func saveCause(_ cause: InstitutionCause) {
        try! realm.write {
            realm.add(cause, update: .all)
        }
    }
    
    /* Save or update the event in the database */
    func saveEvent(_ event: InstitutionEvent) {
        try! realm.write {
            realm.add(event, update: .all)
        }
    }
    
    /* Save or update the volunteer type in the database */
    func saveVolunteerType(_ volunteerType: InstitutionVolunteerType) {
        try! realm.write {
            realm.add(volunteerType, update: .all)
        }
    }
    
    /* Save or update the donation type in the database */
    func saveDonationType(_ donationType: InstitutionDonationType) {
        try! realm.write {
            realm.add(donationType, update: .all)
        }
    }
    
    /* Save or update the donation in the database */
    func saveDonation(_ donation: InstitutionDonation) {
        try! realm.write {
            realm.add(donation, update: .all)
        }
    }
    
    /* Save or update the working day in the database */
    func saveWorkingDay(_ workingDay: InstitutionWorkingDay) {
        try! realm.write {
            realm.add(workingDay, update: .all)
        }
    }
    
    /* Save or update the working period in the database */
    func saveWorkingPeriod(_ workingPeriod: InstitutionWorkingPeriod) {
        try! realm.write {
            realm.add(workingPeriod, update: .all)
        }
    }
    
    /* Search institutions with the neighborhoods, causes, donation type, volunteer type, days or periods */
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
    
    /* Search institutions that match the user profile */
    func searchInstitutionsForMatch(neighborhoods: [Int], causes: [Int], days: [Int], periods: [Int], limit: Int) -> [Institution] {
        let institutions = Array(realm.objects(Institution.self))
        var matchedInstitutions: [MatchedInstitution] = []
        var institutionsToReturn: [Institution] = []
                        
        let causePredicate = NSPredicate(format: "id IN %@", causes)
        //let daysPredicate = NSPredicate(format: "id IN %@", days)
        //let periodsPredicate = NSPredicate(format: "id IN %@", periods)
        
        for institution in institutions {
            var points = 0
            
            let causes = institution.causes.filter(causePredicate)
            points += causes.count * 5
            
            if neighborhoods.contains(institution.neighborhood) {
                points += 2
            }                        
                            
            //let days = institution.days.filter(daysPredicate)
            //points += Int(days.count / 2)
            
            //let periods = institution.periods.filter(periodsPredicate)
            //points += Int(periods.count / 2)
                        
            matchedInstitutions.append(MatchedInstitution(institution: institution, points: points))
        }
        
        matchedInstitutions.sort {
            $0.points > $1.points
        }
        
        for matchedInstitution in matchedInstitutions {
            institutionsToReturn.append(matchedInstitution.institution)
        }
        
        if institutionsToReturn.count > 5 {
            institutionsToReturn = Array(institutionsToReturn[0..<5])
        }
                                
        return institutionsToReturn
    }
    
    /* Search institutions with the title, donation, volunteers that are in the text parameter */
    func searchInstitutions(text: String) -> Array<Institution> {
        let titlePredicate = NSPredicate(format: "title contains [cd] %@", text)
        let volunteerPredicate = NSPredicate(format: "volunteers contains [cd] %@", text)
        let scopePredicate = NSPredicate(format: "scope contains [cd] %@", text)
        let donationPredicate = NSPredicate(format: "ANY donations.desc contains [cd] %@", text)
        
        let fullPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, volunteerPredicate, donationPredicate, scopePredicate])
        
        return Array(realm.objects(Institution.self).filter(fullPredicate))
    }

}
