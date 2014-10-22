//
//  AppDelegate.swift
//  CheckedIn
//
//  Created by Ishmeet Singh on 10/12/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        customizeUI()

        return true
    }
    
    //App-wide UI customization (i.e. Navigation bar color, button color, etc
    func customizeUI(){
        
        //Navigation title font R:203 G:249 B:134
        let titleColorDictionary: NSDictionary = [NSForegroundColorAttributeName:UIColor(red: 203/255, green: 249/255, blue: 134/255, alpha: 1)]
        UINavigationBar.appearance().titleTextAttributes = titleColorDictionary
        //Navigation item font R:255 G:193 B:126
        UINavigationBar.appearance().tintColor = UIColor(red: 255/255, green: 193/255, blue: 126/255, alpha: 1)
        //Navigation bar R:108 G:122 B:137
        UINavigationBar.appearance().barTintColor = UIColor(red: 108/255, green: 122/255, blue: 137/255, alpha: 1)
        //Regular buttons background R:63 G:195 B:168
        UIButton.appearance().tintColor = UIColor.whiteColor()
        UIButton.appearance().backgroundColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)

        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

