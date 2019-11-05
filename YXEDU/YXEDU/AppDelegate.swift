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
        
        QQApiManager.shared().registerQQ("101475072")
        WXApiManager.shared().registerWX("wxa16b70cc1b2c98a0")
        return true
        if YXUserModel.default.didLogin == false {
            loadRegistrationAndLoginPage()
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return YXMediator.shared().handleOpen(url)
    }
    
    func loadRegistrationAndLoginPage(shouldShowShanYan: Bool = true) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nil

        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        window?.rootViewController = navigationController

        let registerAndLoginViewController = navigationController?.viewControllers.first as! YXRegisterAndLoginViewController
        registerAndLoginViewController.shouldShowShanYan = shouldShowShanYan
        
        window?.makeKeyAndVisible()
    }

    func loadMainPage() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nil

        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        window?.rootViewController = tabBarController

        window?.makeKeyAndVisible()
    }
}
