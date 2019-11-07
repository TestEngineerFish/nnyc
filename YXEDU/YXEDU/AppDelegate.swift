//
//  AppDelegate.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { //}, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            authored, error in
            
            guard authored else { return }
//            application.registerForRemoteNotifications()
        }
        
        QQApiManager.shared().registerQQ("101475072")
        WXApiManager.shared().registerWX("wxa16b70cc1b2c98a0")

        if YXUserModel.default.didLogin == false {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = nil

            let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
            window?.rootViewController = navigationController
            
            window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return YXMediator.shared().handleOpen(url)
    }
}
