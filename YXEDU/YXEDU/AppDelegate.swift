//
//  AppDelegate.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if "NoLogin" == "NoLogin" {
            loadRegistrationAndLoginPage()
        }
        
        return true
    }
    
    func loadRegistrationAndLoginPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nil

        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        window?.rootViewController = navigationController

        window?.makeKeyAndVisible()
    }

    func loadMainPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nil

        let storyboard = UIStoryboard(name:"Home", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        window?.rootViewController = tabBarController

        window?.makeKeyAndVisible()
    }
}
