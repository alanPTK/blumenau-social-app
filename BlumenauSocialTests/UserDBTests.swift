import XCTest
import RealmSwift

@testable import Blumenau_Social

class UserDBTests: XCTestCase {

    var testRealm: Realm!
    var testHelper: TestHelper!
    
    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
        testHelper = TestHelper(realm: testRealm)
    }

    func testUserEventInsertion() {
        var eventUserCount = testRealm.objects(UserEvent.self).count
        XCTAssertEqual(eventUserCount, 0, "Number of user events should be 0")
        
        testHelper.createInstitution(id: 1, title: "Title")
        let institution = testRealm.objects(Institution.self).first
        
        testHelper.createEvent(id: 1, institution: institution!)
        let event = testRealm.objects(InstitutionEvent.self).first
        
        testHelper.createUserEvent(event: event!, attendance: true)
        let userEvent = testRealm.objects(UserEvent.self).first
        
        eventUserCount = testRealm.objects(UserEvent.self).count
        XCTAssertEqual(eventUserCount, 1, "Number of user events should be 1")
        
        XCTAssertEqual(userEvent?.confirmed, true, "User should be confirmed in the event")
        XCTAssertEqual(userEvent?.event?.id, 1, "Event id should be 1")
    }

}
