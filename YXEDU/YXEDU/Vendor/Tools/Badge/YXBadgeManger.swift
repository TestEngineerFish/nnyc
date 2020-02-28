//
//  YXBadgeManger.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

@objc class YXBadgeManger: NSObject {
    
    @objc static let share = YXBadgeManger()
    
    var mineBadge: Int     = 0
    var feedbackBadge: Int = 0

    // MARK: ---- 获取Badge ----
    @objc func getFeedbackReplyBadgeNum() -> Int {
        guard let badgeNum = YYCache.object(forKey: YXLocalKey.newFeedbackReply) as? Int else {
            return 0
        }
        return badgeNum
    }
    
    // MARK: ---- 更新Badge ----
    func updateFeedbackReplyBadge() {
        // 清除本地通知的badge
        UIApplication.shared.applicationIconBadgeNumber = 0
        YXComHttpService.shared()?.requestUserInfo({ (objc, result) in
            guard let userModel = objc as? YXLoginModel else {
                return
            }
            let badgeNum = userModel.notify.intValue
            YYCache.set(badgeNum, forKey: YXLocalKey.newFeedbackReply)
            UIApplication.shared.applicationIconBadgeNumber = badgeNum
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                tabBarController.children.last?.tabBarItem.badgeColor = UIColor.clear
                tabBarController.children.last?.tabBarItem.badgeValue = badgeNum > 0 ? "" : nil
            }
        })
    }
    
}
