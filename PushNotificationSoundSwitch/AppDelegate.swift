//
//  AppDelegate.swift
//  PushNotificationSoundSwitch
//
//  Created by Patrick Steiner on 10.02.16.
//  Copyright © 2016 Patrick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Setup push notifications
        let userNotificationTypes: UIUserNotificationType = ([.Alert, .Badge, .Sound])
        
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if UIApplication.sharedApplication().applicationState == .Active {
            showAppActiveDialog()
        }
    }
    
    private func showAppActiveDialog() {
        let alertTitle = "App is in foreground"
        let alertMessage = "After selecting the sound, you have 5 seconds to put the app in the background"
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
}

