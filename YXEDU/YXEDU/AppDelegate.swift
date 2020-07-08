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
//import AdSupport

//#if DEBUG
//import EchoSDK
//#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    public static let `default` = UIApplication.shared.delegate as! AppDelegate
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        initThirdPartyServices()
        setRemoteNotification(application, launchOptions)
        initViewAndData()
        
        initConfig()
        return true
    }
    
    func initThirdPartyServices() {
        UMConfigure.initWithAppkey(kUmengAppKey, channel: kUmengChannel)
        QQApiManager.shared().registerQQ(qqId)
        WXApiManager.shared().registerWX(wechatId)
        Bugly.start(withAppId: kBuglyAppId)
        YXOCLog.shared()?.launch()
//        #if DEBUG
//        ECOClient.shared()?.start()
//        #endif
        
        #if !DEBUG  // 正式环境才开启统计
        Growing.start(withAccountId: kGrowingIOID)
        if YXUserModel.default.didLogin {
            Growing.setUserId(YXUserModel.default.uuid ?? "")
        }
        Growing.setEnableLog(false)
        #endif

        YXFileManager.share.moveToNewStudyPath()
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
        Growing.handle(url)
        return YXMediator.shared().handleOpen(url)
    }
    
    /** 每次启动时，该方法不会执行，App完全退到后台，再回到前台，该方法才会执行 */
    func applicationWillEnterForeground(_ application: UIApplication) {
        YXLog("==== applicationWillEnterForeground ====")
        // 回到前台，检查口令
        YXAlertCheckManager.default.checkCommand(isStartup: false, nil)
        if YXUserModel.default.didLogin {
            YXRedDotManager.share.updateFeedbackReplyBadge()
        }
    }
    
    /** 每次启动时，都执行，但这个方法太过灵敏，App显示通知栏、双击home等情况，App没有完全退到后台时，也会调用，因此只是App每次启动时调用一次 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 仅刚启动时调用一次
        YXLogManager.share.addInfo()
        YXAlertQueueManager.default.start()
    }

    /// 通用链接跳转
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        YXMediator.shared()?.handleOpenUnivrsalLinkURL(userActivity)
        return true
    }
    
    
    func initConfig() {
        let documentPath =  NSHomeDirectory() + "/Documents/"
        YXLog(documentPath)
        
        // 网络状态监听
        YYNetworkService.default.startMonitorNetwork()
        YXAlertCheckManager.default.checkServiceState()
        
        // 启动时，删除学习中状态
        YYCache.remove(forKey: .learningState)
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}


