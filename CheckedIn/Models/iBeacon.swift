import Foundation

class iBeacon :PFObject,PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class  func  parseClassName() -> String! {
        return "iBeacon"
    }
    override class func query() -> PFQuery! {
        return PFQuery(className: "iBeacon")
    }
    
    var UUID:String? {
        get {return objectForKey("UUID") as String?}
        set {setObject(newValue, forKey: "UUID")}
        
    }
    var Greeting:String? {
        get {return objectForKey("Greeting") as String?}
        set {setObject(newValue, forKey: "Greeting")}
        
    }
    
}

 