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
}
