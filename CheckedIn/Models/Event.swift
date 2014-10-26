//
//  Event.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/19/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

class Event: NSObject {
    var title: String?
    var eventId: String?
    var logo: String? //URL
    var time: String? //Need to convert?
    var eventDescription: String?
    var iBeacons: [String]?
    var maxParticipant: Int?
    var schedule: String?
    var userIds: [String]?
    var dictionary: NSDictionary
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        title = dictionary["title"] as? String
        eventId = dictionary["id"] as? String
        logo = dictionary["logo"] as? String
        time = dictionary["time"] as? String
        eventDescription = dictionary["description"] as? String
        iBeacons = dictionary["iBeacons"] as? [String]
        maxParticipant = dictionary["max_participant"] as? Int
        schedule = dictionary["schedule"] as? String
        userIds = dictionary["participant_ids"] as? [String]
        
    }
    
    //Create an array of Events
    class func eventsWithArray(array: [NSDictionary])->[Event]{
        var events = [Event]()
        
        for dictionary in array{
            events.append(Event(dictionary: dictionary))
        }
        return events
    }
    
}