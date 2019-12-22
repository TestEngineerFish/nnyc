//
//  AppDelegate.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import UserNotifications
import GrowingCoreKit
import GrowingAutoTrackKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    public static let `default` = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        getNotificationPermissions()
        initThirdPartyServices()
        initViewAndData()
        
        // 网络状态监听
        YYNetworkService.default.startMonitorNetwork()
        YXAlertManager.default.checkServiceState()
        YXAlertManager.default.checkVersion()
        
        return true
    }
    
    func getNotificationPermissions() {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            authored, error in
            
            guard authored else { return }
//            application.registerForRemoteNotifications()
        }
    }
    
    func initThirdPartyServices() {
        QQApiManager.shared().registerQQ("101475072")
        WXApiManager.shared().registerWX("wxa16b70cc1b2c98a0")
        
//        Growing.start(withAccountId: kGrowingIOID)
    }
    
    func initViewAndData() {
        if YXUserModel.default.didLogin == false {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = nil

            let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
            window?.rootViewController = navigationController
            
            window?.makeKeyAndVisible()
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Growing.handle(url)
        return YXMediator.shared().handleOpen(url)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if Growing.handle(url) {
            return true
        }
        
        return false
    }
    
    /** 每次启动时，该方法不会执行，App完全退到后台，再回到前台，该方法才会执行 */
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("==== applicationWillEnterForeground ====")
        // 回到前台，检查口令
        YXAlertManager.default.checkCommand(isStartup: false)
    }
    
    /** 每次启动时，都执行，但这个方法太过灵敏，App显示通知栏、双击home等情况，App没有完全退到后台时，也会调用，因此只是App每次启动时调用一次 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 仅刚启动时调用一次
        YXAlertManager.default.checkCommand(isStartup: true)
    }
}
