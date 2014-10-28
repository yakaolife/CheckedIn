//
//  ParseUser.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/27/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class ParseUser:  PFUser,PFSubclassing {
    
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
    
    var rsvpEvents: [ParseEvent] {
        get {return objectForKey("rsvped") as [ParseEvent]}
        set {setObject(newValue, forKey: "rsvped")}
    }
    
    var userImage:PFFile? {
        get {return objectForKey("userImage") as? PFFile}
        set {setObject(newValue, forKey: "userImage")}
    }
}

