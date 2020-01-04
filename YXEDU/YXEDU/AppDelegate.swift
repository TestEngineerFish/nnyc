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
        QQApiManager.shared().registerQQ("1110115761")
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
        YXAlertCheckManager.default.checkCommand(isStartup: false, nil)
    }
    
    /** 每次启动时，都执行，但这个方法太过灵敏，App显示通知栏、双击home等情况，App没有完全退到后台时，也会调用，因此只是App每次启动时调用一次 */
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 仅刚启动时调用一次
        YXAlertQueueManager.default.start()
    }
    
    
    
    func initConfig() {
        // 网络状态监听
        YYNetworkService.default.startMonitorNetwork()
        YXAlertCheckManager.default.checkServiceState()
        
        // 启动时，删除学习中状态
        YYCache.remove(forKey: .learningState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.processReviewResult()
            
            
//            let vc = YXReviewResultView(type: .planListenReview)
//            vc.model = nil
//            vc.show()
        }
    }
    
//    /// 处理复习结果页
//    func processReviewResult() {
//        YXReviewDataManager().fetchReviewResult(type: .planListenReview, planId: 13) { [weak self] (resultModel, error) in
//            guard let self = self else {return}
//
//            if var model = resultModel {
//
//                model.planId = 13
//                if model.planState {
//                    self.processReviewResult(model: model)
//                } else {
////                    self.processReviewProgressResult(model: model)
//                }
//
//            } else {
//                UIView.toast("上报关卡失败")
////                self.navigationController?.popViewController(animated: true)
//            }
//
//        }
//    }
//
//        /// 听力复习结果页
//        func processReviewResult(model: YXReviewResultModel) {
//    //        let resultView = YXReviewResultView(type: dataType)
//    //        resultView.model = model
//    //        resultView.show()
//
////            self.navigationController?.popViewController(animated: false)
//
//            let vc = YXReviewResultViewController(type: .planListenReview, model: model)
//            vc.hidesBottomBarWhenPushed = true
//            YRRouter.sharedInstance()?.currentNavigationController()?.pushViewController(vc, animated: true)
//        }
    
}

