import Foundation

class Preferences {
    
    let defaults = UserDefaults.standard
    static var shared: Preferences = Preferences()        
    
    var profileCreationWasOpened: Bool {
        get {
            return defaults.bool(forKey: "profileCreationWasOpened")
        }
        set {
            defaults.set(newValue, forKey: "profileCreationWasOpened")
        }
    }
    
    var institutionsAreSynchronized: Bool {
        get {
            return defaults.bool(forKey: "institutionsAreSynchronized")
        }
        set {
            defaults.set(newValue, forKey: "institutionsAreSynchronized")
        }
    }
    
    var filtersAreSynchronized: Bool {
        get {
            return defaults.bool(forKey: "filtersAreSynchronized")
        }
        set {
            defaults.set(newValue, forKey: "filtersAreSynchronized")
        }
    }
    
    var eventsAreSynchronized: Bool {
        get {
            return defaults.bool(forKey: "eventsAreSynchronized")
        }
        set {
            defaults.set(newValue, forKey: "eventsAreSynchronized")
        }
    }
    
    var userName: String {
        get {
            if let userName = defaults.string(forKey: "userName") {
                return userName
            }
            return ""
        }
        set {
            defaults.setValue(newValue, forKey: "userName")
        }
    }
    
    var userNeighborhood: Int {
        get {
            return defaults.integer(forKey: "userNeighborhood")
        }
        set {
            defaults.setValue(newValue, forKey: "userNeighborhood")
        }
    }
    
    var userDays: [Int] {
        get {
            if let userDays = defaults.array(forKey: "userDays") {
                return userDays as! [Int]
            }
            return []
        }
        set {
            defaults.setValue(newValue, forKey: "userDays")
        }
    }
    
    var userPeriods: [Int] {
        get {
            if let userPeriods = defaults.array(forKey: "userPeriods") {
                return userPeriods as! [Int]
            }
            return []
        }
        set {
            defaults.setValue(newValue, forKey: "userPeriods")
        }
    }
    
    var userInterests: [Int] {
        get {
            if let userInterests = defaults.array(forKey: "userInterests") {
                return userInterests as! [Int]
            }
            return []            
        }
        set {
            defaults.setValue(newValue, forKey: "userInterests")
        }
    }
    
    var profileIsCreated: Bool {
        get {
            return defaults.bool(forKey: "profileIsCreated")
        }
        set {
            defaults.set(newValue, forKey: "profileIsCreated")
        }
    }
    
    var eventRouteTipViewWasShown: Bool {
        get {
            return defaults.bool(forKey: "eventRouteTipViewWasShown")
        }
        set {
            defaults.set(newValue, forKey: "eventRouteTipViewWasShown")
        }
    }
}
