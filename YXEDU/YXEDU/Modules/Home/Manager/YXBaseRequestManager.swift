//
//  YXBaseRequestManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

/// 负责管理程序各个Tab页基本的数据请求和词书下载顺序
struct YXBaseRequestManager {
    static let share = YXBaseRequestManager()

    /// 请求复习Tab基础数据
    func requestReviewPlanTabData() {
        YXReviewDataManager().fetchReviewPlanData { (pageModel, errorMsg) in
            if let reviewModel = pageModel, let jsonStr = reviewModel.toJSONString() {
                YXFileManager.share.saveJsonToFile(with: jsonStr, type: .review)
                NotificationCenter.default.post(name: YXNotification.kRefreshReviewTabPage, object: nil)
            }
        }
    }

    /// 请求挑战Tab基础数据
    func requestChallengeTabData() {
        let request = YXChallengeRequest.challengeModel
        YYNetworkService.default.request(YYStructResponse<YXChallengeModel>.self, request: request, success: { (response) in
            guard let jsonStr = response.data?.toJSONString() else {
                return
            }
            YXFileManager.share.saveJsonToFile(with: jsonStr, type: .challenge)
            NotificationCenter.default.post(name: YXNotification.kChallengeTab, object: nil)
        }, fail: nil)
    }

    /// 请求我的Tab - 个人信息数据
    func requestMineTabUserData() {
        YXComHttpService.shared()?.requestUserInfo({ (response, isSuccess) in
            guard let loginModel = response as? YXLoginModel, let jsonStr = loginModel.yrModelToJSONString() else {
                return
            }
            YXFileManager.share.saveJsonToFile(with: jsonStr, type: .mine_userInfo)
            NotificationCenter.default.post(name: YXNotification.kMineTabUserInfo, object: nil)
        })
    }

    /// 请求我的Tab - 徽章数据
    func requestMineTabBadgeData() {
        let request = YXMineRequest.badgeList
        YYNetworkService.default.request(YYStructDataArrayResponse<YXBadgeModel>.self, request: request, success: { (response) in
            guard let jsonStr = response.dataArray?.toJSONString() else {
                return
            }
            YXFileManager.share.saveJsonToFile(with: jsonStr, type: .mine_badge)
            NotificationCenter.default.post(name: YXNotification.kMineTabBadge, object: nil)
        }, fail: nil)
    }

    /// 请求我的Tab - 积分数据
    func requestMineTabIntegralData() {
        YXDataProcessCenter.get("\(YXEvnOC.baseUrl())/v1/user/credits", parameters: [:]) { (response, isSuccess) in
            guard let responseObj = response?.responseObject, let dict = responseObj as? [String:Any] else {
                return
            }
            YXFileManager.share.saveJsonToFile(with: dict.toJson(), type: .mine_integral)
            NotificationCenter.default.post(name: YXNotification.kMineTabIntegral, object: nil)
        }
    }

}
