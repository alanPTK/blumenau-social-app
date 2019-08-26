import Foundation

enum CacheIdentificationKeys: String {    
    case filterLastSync = "filterLastSync"
    case institutionLastSync = "institutionLastSync"
}

class Cache {
    
    let defaults = UserDefaults.standard
    static var shared: Cache = Cache()
    
    var filterLastSync: Date? {
        get {
            return defaults.object(forKey: "filterLastSync") as? Date
        }
        
        set {
            defaults.set(newValue, forKey: "filterLastSync")
        }
    }
    
    var institutionLastSync: Date? {
        get {
            return defaults.object(forKey: "institutionLastSync") as? Date
        }
        
        set {
            defaults.set(newValue, forKey: "institutionLastSync")
        }
    }    

}
