import Foundation

class parseUser :PFUser,PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    var zipcode:String? {
        get {return objectForKey("zipcode") as String?}
        set {setObject(newValue, forKey: "zipcode")}
    }
    var screenName:String? {
        get {return objectForKey("screenName") as String?}
        set {setObject(newValue, forKey: "screenName")}
    }
  
    var rsvpEvents: [parseEvent] {
        get {return objectForKey("rsvped") as [parseEvent]}
        set {setObject(newValue, forKey: "rsvped")}
    }
 
}

 