import XCTest
import RealmSwift

@testable import Blumenau_Social

class InstitutionDBTests: XCTestCase {

    var testRealm: Realm!
    var testHelper: TestHelper!
    
    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
        testHelper = TestHelper(realm: testRealm)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInstitutionInsertion() {
        var institutionCount = testRealm.objects(Institution.self).count
        XCTAssertEqual(institutionCount, 0, "Number of institutions should be zero")
        
        testHelper.createInstitution(id: 1, title: "Title")
        
        institutionCount = testRealm.objects(Institution.self).count
        XCTAssertEqual(institutionCount, 1, "Number of institutions should be one")
        
        var institutionRetrieved = testRealm.objects(Institution.self).first
        
        XCTAssertEqual(institutionRetrieved?.about.count, 2, "Number of abouts should be two")
        XCTAssertEqual(institutionRetrieved?.donations.count, 2, "Number of donations should be two")
        XCTAssertEqual(institutionRetrieved?.causes.count, 2, "Number of causes should be two")
        XCTAssertEqual(institutionRetrieved?.days.count, 2, "Number of days should be two")
        XCTAssertEqual(institutionRetrieved?.periods.count, 2, "Number of periods should be two")
        XCTAssertEqual(institutionRetrieved?.donationType.count, 2, "Number of donation types should be two")
        XCTAssertEqual(institutionRetrieved?.volunteerType.count, 2, "Number of volunteer types should be two")
        
        XCTAssertEqual(institutionRetrieved?.about[0].title, "Title A", "Title of first about is not the same")
        XCTAssertEqual(institutionRetrieved?.about[1].title, "Title B", "Title of second about is not the same")
        
        XCTAssertEqual(institutionRetrieved?.donations[0].desc, "Donation A", "Description of first donation is not the same")
        XCTAssertEqual(institutionRetrieved?.donations[1].desc, "Donation B", "Description of second donation is not the same")
        
        XCTAssertEqual(institutionRetrieved?.causes[0].id, 1, "ID of first cause is not the same")
        XCTAssertEqual(institutionRetrieved?.causes[1].id, 2, "ID of second cause is not the same")
        
        XCTAssertEqual(institutionRetrieved?.days[0].id, 1, "ID of first day is not the same")
        XCTAssertEqual(institutionRetrieved?.days[1].id, 2, "ID of second day is not the same")
        
        XCTAssertEqual(institutionRetrieved?.periods[0].id, 1, "ID of first period is not the same")
        XCTAssertEqual(institutionRetrieved?.periods[1].id, 2, "ID of second period is not the same")
        
        XCTAssertEqual(institutionRetrieved?.volunteerType[0].id, 1, "ID of first volunteer type is not the same")
        XCTAssertEqual(institutionRetrieved?.volunteerType[1].id, 2, "ID of second volunteer type is not the same")
        
        XCTAssertEqual(institutionRetrieved?.donationType[0].id, 1, "ID of first donation type is not the same")
        XCTAssertEqual(institutionRetrieved?.donationType[1].id, 2, "ID of second donation type is not the same")
        
        XCTAssertEqual(institutionRetrieved?.title, "Title", "Title should be the same")
        XCTAssertEqual(institutionRetrieved?.subtitle, "Subtitle", "Subtitle should be the same")
        XCTAssertEqual(institutionRetrieved?.address, "Address", "Address should be the same")
        XCTAssertEqual(institutionRetrieved?.phone, "Phone", "Phone should be the same")
        XCTAssertEqual(institutionRetrieved?.mail, "Mail", "Mail should be the same")
        XCTAssertEqual(institutionRetrieved?.responsible, "Responsible", "Responsible should be the same")
        XCTAssertEqual(institutionRetrieved?.workingHours, "Working hours", "Working hours should be the same")
        XCTAssertEqual(institutionRetrieved?.scope, "Scope", "Scope should be the same")
        XCTAssertEqual(institutionRetrieved?.volunteers, "Volunteers", "Volunteers should be the same")
        XCTAssertEqual(institutionRetrieved?.neighborhood, 1, "Neighborhood be the same")
        
        testHelper.createInstitution(id: 1, title: "Title X")
        
        institutionRetrieved = testRealm.objects(Institution.self).first
        XCTAssertEqual(institutionRetrieved?.title, "Title X", "The title now should be TitleX")
    }
    
    func testAboutInsertion() {
        var aboutCount = testRealm.objects(InstitutionAbout.self).count
        XCTAssertEqual(aboutCount, 0, "Number of abouts should be zero")
        
        let about = InstitutionAbout()
        about.id = 1
        about.title = "Title"
        about.information = "Information"
        
        try! testRealm.write {
            testRealm.add(about, update: true)
        }
        
        aboutCount = testRealm.objects(InstitutionAbout.self).count
        XCTAssertEqual(aboutCount, 1, "Number of abouts should be one")
        
        let aboutA = InstitutionAbout()
        aboutA.id = 2
        aboutA.title = "Title A"
        aboutA.information = "Information A"
        
        try! testRealm.write {
            testRealm.add(aboutA, update: true)
        }
        
        aboutCount = testRealm.objects(InstitutionAbout.self).count
        XCTAssertEqual(aboutCount, 2, "Number of abouts should be two")
    }
    
    func testCauseInsertion() {
        var causeCount = testRealm.objects(InstitutionCause.self).count
        XCTAssertEqual(causeCount, 0, "Number of causes should be zero")
        
        let cause = InstitutionCause()
        cause.internalId = UUID().uuidString
        cause.id = 1
        
        try! testRealm.write {
            testRealm.add(cause, update: true)
        }
        
        causeCount = testRealm.objects(InstitutionCause.self).count
        XCTAssertEqual(causeCount, 1, "Number of causes should be one")
        
        let causeA = InstitutionCause()
        causeA.internalId = UUID().uuidString
        causeA.id = 2
        
        try! testRealm.write {
            testRealm.add(causeA, update: true)
        }
        
        causeCount = testRealm.objects(InstitutionCause.self).count
        XCTAssertEqual(causeCount, 2, "Number of causes should be two")
    }
    
    func testVolunteerTypeInsertion() {
        var volunteerTypeCount = testRealm.objects(InstitutionVolunteerType.self).count
        XCTAssertEqual(volunteerTypeCount, 0, "Number of volunteers types should be zero")
        
        let volunteerType = InstitutionVolunteerType()
        volunteerType.internalId = UUID().uuidString
        volunteerType.id = 1
        
        try! testRealm.write {
            testRealm.add(volunteerType, update: true)
        }
        
        volunteerTypeCount = testRealm.objects(InstitutionVolunteerType.self).count
        XCTAssertEqual(volunteerTypeCount, 1, "Number of volunteers types should be one")
        
        let volunteerTypeA = InstitutionVolunteerType()
        volunteerTypeA.internalId = UUID().uuidString
        volunteerTypeA.id = 2
        
        try! testRealm.write {
            testRealm.add(volunteerTypeA, update: true)
        }
        
        volunteerTypeCount = testRealm.objects(InstitutionVolunteerType.self).count
        XCTAssertEqual(volunteerTypeCount, 2, "Number of volunteers types should be two")
    }
    
    func testDonationInsertion() {
        var donationCount = testRealm.objects(InstitutionDonation.self).count
        XCTAssertEqual(donationCount, 0, "Number of donations should be zero")
        
        let donation = InstitutionDonation()
        donation.internalId = UUID().uuidString
        donation.desc = "Donation A"
        
        try! testRealm.write {
            testRealm.add(donation, update: true)
        }
        
        donationCount = testRealm.objects(InstitutionDonation.self).count
        XCTAssertEqual(donationCount, 1, "Number of donations should be one")
        
        let donationA = InstitutionDonation()
        donationA.internalId = UUID().uuidString
        donationA.desc = "Donation B"
        
        try! testRealm.write {
            testRealm.add(donationA, update: true)
        }
        
        donationCount = testRealm.objects(InstitutionDonation.self).count
        XCTAssertEqual(donationCount, 2, "Number of donations should be two")
    }
    
    func testDonationTypeInsertion() {
        var donationTypeCount = testRealm.objects(InstitutionDonationType.self).count
        XCTAssertEqual(donationTypeCount, 0, "Number of donation types should be zero")
        
        let donationType = InstitutionDonationType()
        donationType.internalId = UUID().uuidString
        donationType.id = 1
        
        try! testRealm.write {
            testRealm.add(donationType, update: true)
        }
        
        donationTypeCount = testRealm.objects(InstitutionDonationType.self).count
        XCTAssertEqual(donationTypeCount, 1, "Number of donation types should be one")
        
        let donationTypeA = InstitutionDonationType()
        donationTypeA.internalId = UUID().uuidString
        donationTypeA.id = 2
        
        try! testRealm.write {
            testRealm.add(donationTypeA, update: true)
        }
        
        donationTypeCount = testRealm.objects(InstitutionDonationType.self).count
        XCTAssertEqual(donationTypeCount, 2, "Number of donation types should be two")
    }
    
    func testWorkingDayInsertion() {
        var workingDayCount = testRealm.objects(InstitutionWorkingDay.self).count
        XCTAssertEqual(workingDayCount, 0, "Number of working days should be zero")
        
        let workingDay = InstitutionWorkingDay()
        workingDay.internalId = UUID().uuidString
        workingDay.id = 1
        
        try! testRealm.write {
            testRealm.add(workingDay, update: true)
        }
        
        workingDayCount = testRealm.objects(InstitutionWorkingDay.self).count
        XCTAssertEqual(workingDayCount, 1, "Number of working days should be one")
        
        let workingDayA = InstitutionWorkingDay()
        workingDayA.internalId = UUID().uuidString
        workingDayA.id = 2
        
        try! testRealm.write {
            testRealm.add(workingDayA, update: true)
        }
        
        workingDayCount = testRealm.objects(InstitutionWorkingDay.self).count
        XCTAssertEqual(workingDayCount, 2, "Number of working days should be zero")
    }
    
    func testWorkingPeriodInsertion() {
        var workingPeriodCount = testRealm.objects(InstitutionWorkingPeriod.self).count
        XCTAssertEqual(workingPeriodCount, 0, "Number of working periods should be zero")
        
        let workingPeriod = InstitutionWorkingPeriod()
        workingPeriod.internalId = UUID().uuidString
        workingPeriod.id = 1
        
        try! testRealm.write {
            testRealm.add(workingPeriod, update: true)
        }
        
        workingPeriodCount = testRealm.objects(InstitutionWorkingPeriod.self).count
        XCTAssertEqual(workingPeriodCount, 1, "Number of working periods should be one")
        
        let workingPeriodA = InstitutionWorkingPeriod()
        workingPeriodA.internalId = UUID().uuidString
        workingPeriodA.id = 2
        
        try! testRealm.write {
            testRealm.add(workingPeriodA, update: true)
        }
        
        workingPeriodCount = testRealm.objects(InstitutionWorkingPeriod.self).count
        XCTAssertEqual(workingPeriodCount, 2, "Number of working periods should be two")
    }
    
    func testInstitutionEventInsertion() {
        var eventCount = testRealm.objects(InstitutionEvent.self).count
        XCTAssertEqual(eventCount, 0, "Number of events should be zero")
        
        testHelper.createInstitution(id: 1, title: "Title")
        
        let institution = testRealm.objects(Institution.self).first
        testHelper.createEvent(id: 1, institution: institution!)
        
        eventCount = testRealm.objects(InstitutionEvent.self).count
        XCTAssertEqual(eventCount, 1, "Number of events should be one")
        
        let eventRetrieved = testRealm.objects(InstitutionEvent.self).first
        
        XCTAssertEqual(eventRetrieved?.title, "Title", "Title should be the same")
        XCTAssertEqual(eventRetrieved?.address, "Address", "Address should be the same")
        XCTAssertEqual(eventRetrieved?.day, 1, "Day should be the same")
        XCTAssertEqual(eventRetrieved?.month, 1, "Month should be the same")
        XCTAssertEqual(eventRetrieved?.year, 2019, "Year should be the same")
        XCTAssertEqual(eventRetrieved?.startHour, 17, "Start hour should be the same")
        XCTAssertEqual(eventRetrieved?.endHour, 18, "End hour should be the same")
        XCTAssertEqual(eventRetrieved?.desc, "Desc", "Desc should be the same")
        XCTAssertEqual(eventRetrieved?.time, "17h", "Time should be the same")
        XCTAssertEqual(eventRetrieved?.date, "01/01/2019", "Date should be the same")
        XCTAssertEqual(eventRetrieved?.institutions.count, 1, "Number of institutions should be the same")
        XCTAssertEqual(eventRetrieved?.institutions.first?.id, 1, "Institution of the event should have the id one")
    }

}
