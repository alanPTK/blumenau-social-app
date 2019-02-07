import XCTest
import RealmSwift

@testable import Blumenau_Social

class InstitutionRepositoryTests: XCTestCase {
    
    var testRealm: Realm!
    var institutionRepository: InstitutionRepository!

    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
