//
//  AppDelegate.swift
//  CheckedIn
//
//  Created by Ishmeet Singh on 10/12/14.
//  Copyright (c) 2014 Group6. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var storyboard = UIStoryboard (name: "Main", bundle: nil)
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let uuidString = "EBEFD083-70A2-47C8-9837-E7B5634DF524"
        let beaconIdentifier = "CheckedIn"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)

        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
//        locationManager!.startRangingBeaconsInRegion(beaconRegion)
//        locationManager!.startUpdatingLocation()
        
         Parse.setApplicationId("flC9eMzZehG2eu0TBYUn6JqiIvw0maaJn7FEWOsH", clientKey: "ioAQpL7FN7aNagtmxhWCc0xdqJOuofhMdHF0Ftvb")
        
        //Set up UI
        customizeUI()
        if PFUser.currentUser() != nil   {
            //go to logged in view
            println ("current is logged in as \(PFUser.currentUser().username!)")
            var nvc = storyboard.instantiateViewControllerWithIdentifier("UserProfileNavigation") as UINavigationController
            window?.rootViewController = nvc
        } else {
            println("no current user")
        }
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
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
        
        UISegmentedControl.appearance().tintColor = UIColor(red: 63/255, green: 195/255, blue: 168/255, alpha: 1)
        //Which background with some transparency
        UISegmentedControl.appearance().backgroundColor = UIColor(red: 255/255, green:255/255, blue:255/255, alpha: 0.85)
        
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
        // Called when the applicatzion is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


      func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if PFUser.currentUser() != nil   {
            //go to logged in view
            println ("current is logged in as \(PFUser.currentUser().username!)")
            var nvc = storyboard.instantiateViewControllerWithIdentifier("UserProfileNavigation") as UINavigationController
            window?.rootViewController = nvc
        } else {
            println("no current user")
        }
        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
            sendLocalNotificationWithMessage("Welcome to CodePath Demo Day!")
            
            if PFUser.currentUser() != nil  {
                println ("iBeaconNotification current user logged in as \(PFUser.currentUser().username!)")
                
                var nvc = storyboard.instantiateViewControllerWithIdentifier("UserProfileNavigation") as UINavigationController
                
                window?.rootViewController = nvc
                
                var vc = nvc.childViewControllers[0] as UserProfileViewController
                vc.iBeaconNotification = true
                
            }
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
            //            sendLocalNotificationWithMessage("You exited the region")
    }
}

