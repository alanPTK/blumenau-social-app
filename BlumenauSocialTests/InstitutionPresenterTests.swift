import XCTest
import RealmSwift

@testable import Blumenau_Social

class InstitutionPresenterTests: XCTestCase {
    
    var testRealm: Realm!
    var institutionRepository: InstitutionRepository!
    var institutionPresenter: InstitutionsPresenter!
    let institutionDBTests = InstitutionDBTests()
    let mockInstitutionViewController = MockInstitutionsViewController()
    var testHelper: TestHelper!
    
    override func setUp() {
        let configuration = Realm.Configuration.init(fileURL: nil, inMemoryIdentifier: UUID().uuidString, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: 1, migrationBlock: nil, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        
        testRealm = try! Realm(configuration: configuration)
        institutionRepository = InstitutionRepository(realm: testRealm)
        
        institutionPresenter = InstitutionsPresenter(institutionRepository: institutionRepository, delegate: mockInstitutionViewController)
        testHelper = TestHelper(realm: testRealm)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInstitutionAll() {
        testHelper.createInstitution(id: 1, title: "Title")
        testHelper.createInstitution(id: 2, title: "Title X")
        testHelper.createInstitution(id: 3, title: "Title Y")        
        
        institutionPresenter.getAllInstitutions()
    }
    
    func testInstitutionFilter() {
        //tenho que passar o Realm como parametro na criação do repository, passar do presentar para o repository
        
        testHelper.createInstitution(id: 1, title: "Title")
        testHelper.createInstitution(id: 2, title: "Title X")
        testHelper.createInstitution(id: 3, title: "Title Y")
        
        institutionPresenter.searchInstitutions(text: "Title X")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class MockInstitutionsViewController: InstitutionsDelegate {
    
    func showInstitutionsFromFilter(institutions: [Institution]) {
        XCTAssertEqual(institutions.count, 1, "The number of institutions in the view controller should be one")
    }
    
    func showInstitutions(institutions: [Institution]) {
        XCTAssertEqual(institutions.count, 3, "The number of institutions in the view controller should be three")
    }
    
    func hideProgressHud() {
        
    }
    
    
}
