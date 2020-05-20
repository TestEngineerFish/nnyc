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
        // 初始化 友盟 推送
        UNUserNotificationCenter.current().delegate = self
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.alert.rawValue | UMessageAuthorizationOptions.sound.rawValue)
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (result, error) in
            print(result)
        }
        
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
        // 上报后台
        if let pushId = userInfo?["push_id"] as? String {
            let dict = ["push_notify": ["action":2, "push_id":pushId]]
            YXSetReminderView.requestReportNotification(dataString: dict.toJson())
        }

        YXRedDotManager.share.updateFeedbackReplyBadge()
        if let action = userInfo?["open_scheme"] as? String {
            YRRouter.openURL(action, query: nil, animated: true)
        }
        resetIconBadge()
    }
    
    
    /// 清除 App icon 上的红点
    func resetIconBadge() {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    /// 获取Token进行注册
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = NSObject.deviceTokenToString(with: deviceToken) ?? ""
        YXLog("获取deviceToken成功 ===========", token)
        
        if YXUserModel.default.didLogin == false {
            // 未登录
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let alias = YXUserModel.default.uuid ?? ""
            UMessage.setAlias(alias, type: kUmengAliasType) { (response, error) in
                if let _error = error {
                    YXLog("设置别名\(alias)失败 ====已经登录过=======, error: ", _error)
                } else {
                    YXLog("设置别名\(alias)成功 ====已经登录过=======")
                }
            }
        }
    }
    /// 获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        YXLog("获取deviceToken失败 error: \(error)")
    }

    /// 在前台时收到通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let pushId = userInfo["push_id"] as? String {
            let dict = ["push_notify": ["action":1, "push_id":pushId]]
            YXSetReminderView.requestReportNotification(dataString: dict.toJson())
        }
        
        completionHandler(.badge)
    }

    /// 点击通知
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        processNotification(userInfo: userInfo)
        completionHandler()
    }
}


