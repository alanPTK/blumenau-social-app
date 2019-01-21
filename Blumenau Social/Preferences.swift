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
}
