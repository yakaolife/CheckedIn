import Foundation


class parseEvent : PFObject,PFSubclassing {
    
    override class func load() {
        self.registerSubclass()
    }
    
    class  func  parseClassName() -> String! {
        return "Event"
    }
    override class func query() -> PFQuery! {
        return PFQuery(className: "Event")
    }
    
     
    var EventName:String? {
        get {return objectForKey("EventName") as String? }
        set {setObject(newValue, forKey: "EventName") }
    }
    var cityName:String? {
        get {return objectForKey("cityName") as String?}
        set {setObject(newValue, forKey: "cityName")}
    }
    
    var tagLine:String? {
        get {return objectForKey("tagLine") as String?}
        set {setObject(newValue, forKey: "tagLine")}
    }
    var rsvpMax:NSNumber? {
        get {return objectForKey("rsvpMax") as NSNumber?}
        set {setObject(newValue, forKey: "rsvpMax")}
    }
    

    
}