//
//  AppDelegate.swift
//  GamesWithGold
//
//  Created by joshua kozlowski on 4/5/17.
//  Copyright © 2017 joshua kozlowski. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        
        // Configure AdMob
        GADMobileAds.configure(withApplicationID: "ca-app-pub-8452783658374563~1495186333")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in})
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
