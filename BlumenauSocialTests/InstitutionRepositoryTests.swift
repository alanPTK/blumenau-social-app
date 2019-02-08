import XCTest
import RealmSwift

@testable import Blumenau_Social

class InstitutionRepositoryTests: XCTestCase {
    
    var testRealm: Realm!
    var institutionRepository: InstitutionRepository!
    let institutionDBTests = InstitutionDBTests()
    var testHelper: TestHelper!

    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
        institutionRepository = InstitutionRepository(realm: testRealm)
        testHelper = TestHelper(realm: testRealm)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInstitutionFetch() {
        var institutions = institutionRepository.getAllInstitutions()
        XCTAssertEqual(institutions.count, 0, "Number of institutions should be zero")
        
        testHelper.createInstitution(id: 1, title: "Title 1")
        
        institutions = institutionRepository.getAllInstitutions()
        XCTAssertEqual(institutions.count, 1, "Number of institutions should be one")
        
        testHelper.createInstitution(id: 2, title: "Title 2")
        
        institutions = institutionRepository.getAllInstitutions()
        XCTAssertEqual(institutions.count, 2, "Number of institutions should be two")
        
        var institution = institutionRepository.getInstitutionWithId(id: 1)
        XCTAssertNotNil(institution, "The institution with id 1 should not be nil")
        
        institution = institutionRepository.getInstitutionWithId(id: 3)
        XCTAssertNil(institution, "The institution with id 3 should be nil")
        
        institutions = institutionRepository.searchInstitutions(text: "Title 1")
        XCTAssertEqual(institutions.count, 1, "Number of institutions with Title 1 should be one")
        
        institutions = institutionRepository.searchInstitutions(text: "Title X")
        XCTAssertEqual(institutions.count, 0, "Number of institutions with Title X should be zero")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
