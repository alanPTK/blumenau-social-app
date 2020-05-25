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
    
    var showNeighborhoodsView: Bool {
        get {
            return defaults.bool(forKey: "showNeighborhoodsView")
        }
        set {
            defaults.set(newValue, forKey: "showNeighborhoodsView")
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
    
    var userNeighborhoods: [Int] {
        get {
            if let userNeighborhoods = defaults.array(forKey: "userNeighborhoods") {
                return userNeighborhoods as! [Int]
            }
            return []
        }
        set {
            defaults.setValue(newValue, forKey: "userNeighborhoods")
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
    
    var institutionMapTipViewWasShown: Bool {
        get {
            return defaults.bool(forKey: "institutionMapTipViewWasShown")
        }
        set {
            defaults.set(newValue, forKey: "institutionMapTipViewWasShown")
        }
    }
}
