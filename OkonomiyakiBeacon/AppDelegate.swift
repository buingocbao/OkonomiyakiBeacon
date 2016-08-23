//
//  AppDelegate.swift
//  OkonomiyakiBeacon
//
//  Created by BBaoBao on 7/1/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var beacons = []
    var pushFileArray: NSArray = NSArray()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Parse config
        Parse.enableLocalDatastore()
        Parse.setApplicationId("H7XFf7KghDP9SES9fstApk09ztNAcUaKzzKesf4w", clientKey:"dEGqP7fx7wBFL4gVbm51YfVZGTGT5hVnqK2Xmhw9")
        
        // iBeacon Config
        let uuidString = "B9407F30-F5F8-466E-AFF9-25556B57FE6D"
        let beaconIdentifier = "estimote.com"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: 3157, minor: 27701, identifier: beaconIdentifier)
        //let beaconRegion2:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, major: 3157, minor: 27701, identifier: beaconIdentifier)
        //let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        if ((locationManager?.respondsToSelector("requestAlwaysAuthorization")) != nil) {
            locationManager?.requestAlwaysAuthorization()
        }
        locationManager?.delegate = self
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringForRegion(beaconRegion)
        locationManager?.startRangingBeaconsInRegion(beaconRegion)
        locationManager?.startUpdatingLocation()
        
        if(application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: UIUserNotificationType.Alert | UIUserNotificationType.Sound,
                    categories: nil
                )
            )
        }
        
        // Config Parse
        //queryParseMethod()
        return true
    }
    
    func queryParseMethod() {
        println("Start query")
        var query = PFQuery(className: "PushNotification")
        query.orderByAscending("PushID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) pushes.")
                self.pushFileArray = objects!
                println(self.pushFileArray)
            }
        }
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

extension AppDelegate: CLLocationManagerDelegate {
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.soundName = "NotificationSound.m4a"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //println("didRangeBeacons")
        var message:String = ""
        
        if beacons.count > 0 {
            let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon
            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                    return;
            }
            lastProximity = nearestBeacon.proximity;
            switch nearestBeacon.proximity {
            case CLProximity.Far:
                message = "You are outside the restaurant (Far away)"
            case CLProximity.Near:
                message = "You are in front of the restaurant (Far)"
            case CLProximity.Immediate:
                message = "You are inside the restaurant (Immediate)"
            case CLProximity.Unknown:
                return
            }
        } else {
            message = "No beacon are nearby"
        }
        
        self.beacons = beacons
        
        NSNotificationCenter.defaultCenter().postNotificationName("updateBeaconTableView", object: self.beacons)
        //send updated beacons array to BeaconTableViewController
        
        println(message)
        //sendLocalNotificationWithMessage(message)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.startUpdatingLocation()
        
        println("You entered the region")
        
        //var pushObject:PFObject = pushFileArray.objectAtIndex(0) as! PFObject
        //var pushString = pushObject["PushText"] as? String
        sendLocalNotificationWithMessage("いっらしゃいませ")
        //sendLocalNotificationWithMessage(pushString)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        manager.stopUpdatingLocation()
        
        println("You exited the region")
        
        //var pushObject:PFObject = pushFileArray.objectAtIndex(1) as! PFObject
        //var pushString = pushObject["PushText"] as? String
        sendLocalNotificationWithMessage("ありがとうございました。またのご来店お待ちしております。")
        //sendLocalNotificationWithMessage(pushString)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        //var mainstoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //var promotionView:PromotionViewController = mainstoryBoard.instantiateViewControllerWithIdentifier("PromotionViewController") as! PromotionViewController
        //self.window?.rootViewController?.presentViewController(promotionView, animated: true, completion: nil)
        
        var tabBar:UITabBarController = self.window?.rootViewController as! UITabBarController
        tabBar.selectedIndex = 0
    }
}
