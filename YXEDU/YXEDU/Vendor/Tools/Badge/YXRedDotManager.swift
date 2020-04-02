//
//  YXRedDotManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

@objc class YXRedDotManager: NSObject {
    
    @objc static let share = YXRedDotManager()
    
    var mineBadge: Int     = 0
    var feedbackBadge: Int = 0

    // MARK: ---- 获取Badge ----
    /// 获取反馈回复未读数
    @objc func getFeedbackReplyBadgeNum() -> Int {
        guard let badgeNum = YYCache.object(forKey: YXLocalKey.newFeedbackReply) as? Int else {
            return 0
        }
        return badgeNum
    }
    
    /// 获取任务中心未领任务数
    @objc func getTaskCenterBadgeNum() -> Int {
        guard let badgeNum = YYCache.object(forKey: YXLocalKey.taskCenterCanReceive) as? Int else {
            return 0
        }
        return badgeNum
    }
    
    // MARK: ---- 更新Badge ----
    /// 更新反馈回复小红点
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
            NotificationCenter.default.post(name: YXNotification.kUpdateFeedbackReplyBadge, object: nil)
        })
    }
    
    /// 更新任务中心小红点
    func updateTaskCenterBadge() {
        let request = YXHomeRequest.task
        YYNetworkService.default.request(YYStructResponse<YXTaskCenterBadgeModel>.self, request: request, success: { (response) in
            guard let model = response.data else {
                return
            }
            let badgeNum = model.num
            YYCache.set(badgeNum, forKey: YXLocalKey.taskCenterCanReceive)
            NotificationCenter.default.post(name: YXNotification.kUpdateTaskCenterBadge, object: nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
            YXLog("更新首页任务中心红点失败，error msg：\(error.message)")
        }
    }
    
}
