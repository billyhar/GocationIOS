//
//  AppDelegate.swift
//  Gocation
//
//  Created by Billy Harris on 14/04/17.
//  Copyright © 2017 Billy Harris. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import CoreLocation
import KontaktSDK
import UserNotifications

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        FIRApp.configure()
    
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        //        Intialising the Notification
        let center = UNUserNotificationCenter.current()
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
            if granted{
                application.registerForRemoteNotifications()
            } else{
                print("User Notification Permission Denied: \(error?.localizedDescription)")
            }
        }
        


        if #available(iOS 10,*) {
            //            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.alert, .sound, .badge], categories: nil))
            //            UIApplication.shared.registerForRemoteNotifications()
            //
            locationManager.requestWhenInUseAuthorization();
            let center = UNUserNotificationCenter.current();
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization
            }
            
        } else if #available(iOS 8,*){
            locationManager.requestAlwaysAuthorization()
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types:[.alert, .sound, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }else{
            locationManager.requestAlwaysAuthorization()
            UIApplication.shared.registerForRemoteNotifications(matching: [.alert, .sound, .badge])
        }
        
        UIApplication.shared.cancelAllLocalNotifications()
        
        return true
    }
    
    func tokenString(_ deviceToken:Data) -> String{
        let bytes = [UInt8](deviceToken)
        var token = ""
        for byte in bytes{
            token += String(format:"%02x",byte)
        }
            return token
    }
        
        //REMOTE NOTIFICATIONS
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successful registration. Token is:")
        print(tokenString(deviceToken))
    }
  
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register")
    }
    
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled

    }
    

    
    
   
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    
    
    
    //LOCAL NOTIFICATION SHIT
    
    //Main Stage Beacon
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // When Approaching the Beacon
        scheduleLocalNotification(true, tips: "You are approaching the main stage")
        
        // When Leaving the Beacon Region
        scheduleLocalNotification(false, tips: "You are leaving the main stage")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0;
    }
    
    func scheduleLocalNotification(_ onEntry:Bool, tips:String!){
        
        if #available(iOS 10,*) {
            let content = UNMutableNotificationContent();
            content.title = "Your Activity";
            content.body = String(tips);
            content.sound = UNNotificationSound.default();
            
            let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "3d80997d-5415-4f7e-8117-82ce9b407e3e")!,
                                        major: 51401, minor: 14274, identifier: tips)
            region.notifyOnEntry = onEntry
            region.notifyOnExit = !onEntry;
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let notification = UNNotificationRequest(identifier: tips, content: content,trigger: trigger);
            
            
            //            notification.
            
            let center = UNUserNotificationCenter.current();
            
            center.add(notification);
        }else{
            let messageString = String(tips)
            let notification = UILocalNotification()
            notification.alertBody = messageString
            notification.region = CLBeaconRegion(proximityUUID: UUID(uuidString: "3d80997d-5415-4f7e-8117-82ce9b407e3e")!,
                                                 major: 51401, minor: 14274, identifier: tips)
            
            notification.region?.notifyOnEntry = onEntry
            notification.region?.notifyOnExit = !onEntry
            notification.regionTriggersOnce = false
            
            notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedAlways){
            print("Notification Sent")
        }
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
}



//// MARK: - CLLocationManagerDelegate
//extension AppDelegate: CLLocationManagerDelegate {
//    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
//        if let beaconRegion = region as? CLBeaconRegion {
//            var notification = UILocalNotification()
//            notification.alertBody = "Are you forgetting something?"
//            notification.soundName = "Default"
//            UIApplication.shared.presentLocalNotificationNow(notification)
//        }
//    }
















