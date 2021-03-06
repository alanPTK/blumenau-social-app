import XCTest
import RealmSwift

@testable import Blumenau_Social

class UserRepositoryTests: XCTestCase {
    
    var testRealm: Realm!
    var institutionRepository: InstitutionRepository!
    var userRepository: UserRepository!
    let institutionDBTests = InstitutionDBTests()
    var testHelper: TestHelper!

    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
        institutionRepository = InstitutionRepository(realm: testRealm)
        userRepository = UserRepository(realm: testRealm)
        testHelper = TestHelper(realm: testRealm)
    }    

    func testInstitutionFetch() {
        var userEvents = userRepository.getUserEvents()
        XCTAssertEqual(userEvents.count, 0, "Number of user events should be 0")
        
        testHelper.createInstitution(id: 1, title: "Title 1")
        let institution = testRealm.objects(Institution.self).first
        
        testHelper.createEvent(id: 1, institution: institution!)
        let event = testRealm.objects(InstitutionEvent.self).first
        
        userRepository.createUserEvent(event: event!, attendance: true)
        
        userEvents = userRepository.getUserEvents()
        XCTAssertEqual(userEvents.count, 1, "Number of user events should be 1")
        
        var userEvent = userRepository.getUserEvent(event!)
        XCTAssertEqual(userEvent?.confirmed, true, "User should be confirmed in the event")
        
        userRepository.changeAttendanceStatusForEvent(event: event!, attendance: false)
        
        userEvent = userRepository.getUserEvent(event!)
        XCTAssertEqual(userEvent?.confirmed, false, "User should not be confirmed in the event")
    }

}
