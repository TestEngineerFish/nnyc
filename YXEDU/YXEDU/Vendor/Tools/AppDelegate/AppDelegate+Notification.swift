//
//  AppDelegate+Notification.swift
//  YXEDU
//
//  Created by sunwu on 2020/2/27.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    /// 设置推送
    /// - Parameters:
    ///   - application:
    ///   - launchOptions:
    func setRemoteNotification(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        /// 初始化 APNs 代码
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        
        /// 初始化 JPush 代码
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: kJPushChannel, apsForProduction: kJPushProduction > 0)
        
        
        /// app冷启动，从通知栏点击进去
        if let remoteNotification = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.processNotification(userInfo: remoteNotification)
            }
        }
        
    }
    
    
    /// 处理推送
    /// - Parameter userInfo: 数据
    func processNotification(userInfo: [AnyHashable: Any]?) {        
        if UIApplication.shared.applicationState == .active {
            return
        }
        YXBadgeManger.share.updateFeedbackReplyBadge()
        if let action = userInfo?["action"] as? String {
            YRRouter.openURL(action, query: nil, animated: true)
        }
        resetIconBadge()
    }
    
    
    /// 清除 App icon 上的红点
    func resetIconBadge() {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
    }
}


extension AppDelegate: JPUSHRegisterDelegate {

    /// 当app在前台时，静默推送
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
       // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
       completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
       let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 系统要求执行这个方法
        completionHandler()
        
        processNotification(userInfo: userInfo)
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {
        
    }
    

    /// 获取Token进行注册
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        
        if YXUserModel.default.didLogin == false {
            // 没登陆
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            JPUSHService.setAlias(YXUserModel.default.uuid ?? "", completion: { (code, alias, seq) in
                DDLogInfo("alias =========== \(code),\(alias ?? ""),\(seq)")
            }, seq: Int(Date().timeIntervalSince1970))
        }
    }
    /// 获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        DDLogInfo("获取device token失败 error: \(error)")
    }



}


