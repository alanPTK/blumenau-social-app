import RealmSwift

@testable import Blumenau_Social

class TestHelper {
    
    var testRealm: Realm!
    
    init(realm: Realm) {
        self.testRealm = realm
    }
    
    func createEvent(id: Int, institution: Institution) {
        let institutionEvent = InstitutionEvent()
        institutionEvent.id = id
        institutionEvent.address = "Address"
        institutionEvent.date = "01/01/2019"
        institutionEvent.time = "17h"
        institutionEvent.title = "Title"
        institutionEvent.desc = "Desc"
        institutionEvent.day = 1
        institutionEvent.month = 1
        institutionEvent.year = 2019
        institutionEvent.startHour = 17
        institutionEvent.endHour = 18
        institutionEvent.institutions.append(institution)
        
        try! testRealm.write {
            testRealm.add(institutionEvent, update: true)
        }
        
        try! testRealm.write {
            institution.events.append(institutionEvent)
            testRealm.add(institution, update: true)
        }                
    }
    
    func createUserEvent(event: InstitutionEvent, attendance: Bool) {
        let userEvent = UserEvent()
        
        userEvent.id = UUID().uuidString
        userEvent.event = event
        userEvent.confirmed = attendance
        
        try! testRealm.write {
            testRealm.add(userEvent, update: true)
        }
    }
    
    func createInstitution(id: Int, title: String) {
        let institution = Institution()
        institution.id = id
        institution.title = title
        institution.subtitle = "Subtitle"
        institution.address = "Address"
        institution.phone = "Phone"
        institution.mail = "Mail"
        institution.responsible = "Responsible"
        institution.workingHours = "Working hours"
        institution.scope = "Scope"
        institution.volunteers = "Volunteers"
        institution.neighborhood = 1
        
        let donationA = InstitutionDonation()
        donationA.internalId = UUID().uuidString
        donationA.desc = "Donation A"
        
        let donationB = InstitutionDonation()
        donationB.internalId = UUID().uuidString
        donationB.desc = "Donation B"
        
        institution.donations.append(donationA)
        institution.donations.append(donationB)
        
        let causeA = InstitutionCause()
        causeA.internalId = UUID().uuidString
        causeA.id = 1
        
        let causeB = InstitutionCause()
        causeB.internalId = UUID().uuidString
        causeB.id = 2
        
        institution.causes.append(causeA)
        institution.causes.append(causeB)
        
        let aboutA = InstitutionAbout()
        aboutA.id = 1
        aboutA.title = "Title A"
        aboutA.information = "Information A"
        
        let aboutB = InstitutionAbout()
        aboutB.id = 2
        aboutB.title = "Title B"
        aboutB.information = "Information B"
        
        institution.about.append(aboutA)
        institution.about.append(aboutB)
        
        let workingDayA = InstitutionWorkingDay()
        workingDayA.internalId = UUID().uuidString
        workingDayA.id = 1
        
        let workingDayB = InstitutionWorkingDay()
        workingDayB.internalId = UUID().uuidString
        workingDayB.id = 2
        
        institution.days.append(workingDayA)
        institution.days.append(workingDayB)
        
        let workingPeriodA = InstitutionWorkingPeriod()
        workingPeriodA.internalId = UUID().uuidString
        workingPeriodA.id = 1
        
        let workingPeriodB = InstitutionWorkingPeriod()
        workingPeriodB.internalId = UUID().uuidString
        workingPeriodB.id = 2
        
        institution.periods.append(workingPeriodA)
        institution.periods.append(workingPeriodB)
        
        let donationTypeA = InstitutionDonationType()
        donationTypeA.internalId = UUID().uuidString
        donationTypeA.id = 1
        
        let donationTypeB = InstitutionDonationType()
        donationTypeB.internalId = UUID().uuidString
        donationTypeB.id = 2
        
        institution.donationType.append(donationTypeA)
        institution.donationType.append(donationTypeB)
        
        let volunteerTypeA = InstitutionVolunteerType()
        volunteerTypeA.internalId = UUID().uuidString
        volunteerTypeA.id = 1
        
        let volunteerTypeB = InstitutionVolunteerType()
        volunteerTypeB.internalId = UUID().uuidString
        volunteerTypeB.id = 2
        
        institution.volunteerType.append(volunteerTypeA)
        institution.volunteerType.append(volunteerTypeB)
        
        try! testRealm.write {
            testRealm.add(institution, update: true)
        }                
    }

}
