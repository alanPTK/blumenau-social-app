import XCTest

@testable import Blumenau_Social

class UserPreferencesTests: XCTestCase {
    
    private var preferences = Preferences.shared    

    func testPreference() {
        preferences.userName = "Alan"
        preferences.userAge = 28
        preferences.profileCreationWasOpened = true
        preferences.institutionsAreSynchronized = false
        preferences.filtersAreSynchronized = true
        preferences.eventsAreSynchronized = false
        preferences.userNeighborhood = 1
        preferences.userDays = [1, 2, 3, 4]
        preferences.userPeriods = [1, 2, 3]
        preferences.userInterests = [9, 10, 11, 12]
        preferences.profileIsCreated = true
        preferences.eventRouteTipViewWasShown = false
        
        XCTAssertEqual(preferences.userName, "Alan", "Name from preferences should be Alan")
        XCTAssertEqual(preferences.userAge, 28, "Age from preferences should be 28")
        XCTAssertEqual(preferences.profileCreationWasOpened, true, "Profile creation was opened from preferences should be true")
        XCTAssertEqual(preferences.institutionsAreSynchronized, false, "Institutions are synchronized from preferences should be false")
        XCTAssertEqual(preferences.filtersAreSynchronized, true, "Filters are synchronized from preferences should be true")
        XCTAssertEqual(preferences.eventsAreSynchronized, false, "Events are synchronized from preferences should be false")
        XCTAssertEqual(preferences.userNeighborhood, 1, "User neighborhood from preferences should be 1")
        XCTAssertEqual(preferences.userDays, [1, 2, 3, 4], "User days from preferences should be 1, 2, 3 and 4")
        XCTAssertEqual(preferences.userPeriods, [1, 2, 3], "User periods from preferences should be 1, 2 and 3")
        XCTAssertEqual(preferences.userInterests, [9, 10, 11, 12], "User interests from preferences should be 9, 10, 11, 12")
        XCTAssertEqual(preferences.profileIsCreated, true, "Profile is created from preferences should be true")
        XCTAssertEqual(preferences.eventRouteTipViewWasShown, false, "Event tip view was shown from preferences should be false")
        
        preferences.userName = "Filipe"
        preferences.userAge = 29
        preferences.profileCreationWasOpened = false
        preferences.institutionsAreSynchronized = true
        preferences.filtersAreSynchronized = false
        preferences.eventsAreSynchronized = true
        preferences.userNeighborhood = 2
        preferences.userDays = [1, 2]
        preferences.userPeriods = [1]
        preferences.userInterests = [9, 10, 11]
        preferences.profileIsCreated = false
        preferences.eventRouteTipViewWasShown = true
        
        XCTAssertEqual(preferences.userName, "Filipe", "Name from preferences should be Filipe")
        XCTAssertEqual(preferences.userAge, 29, "Age from preferences should be 29")
        XCTAssertEqual(preferences.profileCreationWasOpened, false, "Profile creation was opened from preferences should be false")
        XCTAssertEqual(preferences.institutionsAreSynchronized, true, "Institutions are synchronized from preferences should be true")
        XCTAssertEqual(preferences.filtersAreSynchronized, false, "Filters are synchronized from preferences should be false")
        XCTAssertEqual(preferences.eventsAreSynchronized, true, "Events are synchronized from preferences should be true")
        XCTAssertEqual(preferences.userNeighborhood, 2, "User neighborhood from preferences should be 2")
        XCTAssertEqual(preferences.userDays, [1, 2], "User days from preferences should be 1, 2")
        XCTAssertEqual(preferences.userPeriods, [1], "User periods from preferences should be 1")
        XCTAssertEqual(preferences.userInterests, [9, 10, 11], "User interests from preferences should be 9, 10, 11")
        XCTAssertEqual(preferences.profileIsCreated, false, "Profile is created from preferences should be false")
        XCTAssertEqual(preferences.eventRouteTipViewWasShown, true, "Event tip view was shown from preferences should be true")
    }

}
