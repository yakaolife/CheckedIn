//
//  ParseEvent.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/27/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class ParseEvent: PFObject,PFSubclassing {
    
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
    var state:String? {
        get {return objectForKey("State") as String?}
        set {setObject(newValue, forKey: "State")}
    }
    var tagLine:String? {
        get {return objectForKey("tagLine") as String?}
        set {setObject(newValue, forKey: "tagLine")}
    }
    var rsvpMax:NSNumber? {
        get {return objectForKey("rsvpMax") as NSNumber?}
        set {setObject(newValue, forKey: "rsvpMax")}
    }
    var eventDate:NSDate? {
        get {return objectForKey("EventDate") as NSDate?}
        set {setObject(newValue, forKey: "EventDate")}
    }
    
    
    
    
}