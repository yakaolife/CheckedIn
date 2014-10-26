//
//  User.swift
//  CheckedIn
//
//  Created by Cindy Zheng on 10/19/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "CurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"


class User: NSObject {
    
    var dictionary: NSDictionary
    var displayname: String? //userid
    var email: String?
    var firstname: String?
    var lastname: String?
    //var events: Event[] //Do we store them here? We didn't inside the User/TweetProject
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        displayname = dictionary["displayname"] as? String
        email = dictionary["email"] as? String
        firstname = dictionary["firstname"] as? String
        lastname = dictionary["lastname"] as? String
        
    }
    
    func logout(){
        
    }
    
    class var currentUser: User?{
        
        get{
            if _currentUser == nil{
                
            }
            return _currentUser
        }
        
        set(user){
            _currentUser = user
            //persistence
            if _currentUser != nil{
                
            }else{
                
            }
        }
    }
}