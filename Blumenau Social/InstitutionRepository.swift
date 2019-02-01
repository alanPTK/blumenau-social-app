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
    
    func createInstitutionWithData(institutionsData: Institutions) {
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
                institution.donations.append(donation)
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
    
    func searchInstitutions(neighborhoods: [Int], causes: [Int], donationType: [Int], volunteerType: [Int], days: [Int], periods: [Int]) -> Results<Institution> {
        let neighborhoodPredicate = NSPredicate(format: "neighborhood in %@", Array(neighborhoods))
        let causePredicate = NSPredicate(format: "ANY causes.id IN %@", causes)
        let donationPredicate = NSPredicate(format: "ANY donationType.id IN %@", donationType)
        let volunteerPredicate = NSPredicate(format: "ANY volunteerType.id IN %@", volunteerType)
        
        let daysPredicate = NSPredicate(format: "ANY days.id IN %@", days)
        let periodsPredicate = NSPredicate(format: "ANY periods.id IN %@", periods)
        let workingTimePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [daysPredicate, periodsPredicate])
        
        let fullPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [neighborhoodPredicate, causePredicate, donationPredicate, volunteerPredicate, workingTimePredicate])
        
        return realm.objects(Institution.self).filter(fullPredicate)
    }
    
    func searchInstitutions(text: String) -> Results<Institution> {
        let predicate = NSPredicate(format: "title contains [c] %@", text)
        
        return realm.objects(Institution.self).filter(predicate)
    }

}
