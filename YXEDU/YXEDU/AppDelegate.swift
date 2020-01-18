//
//  AppDelegate.swift
//  YXEDU
//
//  Created by Jake To on 10/28/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import UserNotifications
import Bugly
import GrowingCoreKit
import GrowingAutoTrackKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    public static let `default` = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()

        getNotificationPermissions()
        initThirdPartyServices()
        initViewAndData()
        
        initConfig()
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
        Bugly.start(withAppId: kBuglyAppId)
        // ---- 日志 ----
        DDLog.add(DDOSLogger.sharedInstance) // 发送到苹果控制台
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        // 添加基本信息
        YXLogManager.share.addInfo()
        // ---- 日志 ----
        #if !DEBUG  // 正式环境才开启统计，不然开发环境打印的日志太多
        Growing.start(withAccountId: kGrowingIOID)
        #endif
    }
    
    func initViewAndData() {
        if YXUserModel.default.didLogin {
            if let lastStoredDate = YYCache.object(forKey: "LastStoreTokenDate") as? Date {
                if Calendar.current.isDateInToday(lastStoredDate) == false {
                    YXUserModel.default.updateToken()
                    YYCache.set(Date(), forKey: "LastStoreTokenDate")
                }

            } else {
                YXUserModel.default.updateToken()
                YYCache.set(Date(), forKey: "LastStoreTokenDate")
            }
            
        } else {
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
        YXAlertCheckManager.default.checkCommand(isStartup: false, nil)
    }
    
    /** 每次启动时，都执行，但这个方法太过灵敏，App显示通知栏、双击home等情况，App没有完全退到后台时，也会调用，因此只是App每次启动时调用一次 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 仅刚启动时调用一次
        YXAlertQueueManager.default.start()
    }

    /// 通用链接跳转
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }
    
    
    func initConfig() {
        // 网络状态监听
        YYNetworkService.default.startMonitorNetwork()
        YXAlertCheckManager.default.checkServiceState()
        
        // 启动时，删除学习中状态
        YYCache.remove(forKey: .learningState)
    }
    
}

