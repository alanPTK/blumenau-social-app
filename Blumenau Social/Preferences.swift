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
    
    var userAge: Int {
        get {
            return defaults.integer(forKey: "userAge")
        }
        set {
            defaults.setValue(newValue, forKey: "userAge")
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
    
    var userDays: [Int]? {
        get {
            return defaults.array(forKey: "userDays") as? [Int]
        }
        set {
            defaults.setValue(newValue, forKey: "userDays")
        }
    }
    
    var userPeriods: [Int]? {
        get {
            return defaults.array(forKey: "userPeriods") as? [Int]
        }
        set {
            defaults.setValue(newValue, forKey: "userPeriods")
        }
    }
    
    var userInterests: [Int]? {
        get {
            return defaults.array(forKey: "userInterests") as? [Int]
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
}
