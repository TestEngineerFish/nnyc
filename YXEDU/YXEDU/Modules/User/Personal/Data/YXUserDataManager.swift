//
//  YXUserDataManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/14.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

struct YXUserDataManager {
    static let share = YXUserDataManager()

    /// 更新用户信息
    func updateUserInfomation(_ finishBlock: ((YXUserInfomationModel)->Void)?) {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let userInfomation = response.data else { return }

            YXUserModel.default.coinExplainUrl = userInfomation.coinExplainUrl
            YXUserModel.default.gameExplainUrl = userInfomation.gameExplainUrl
            YXUserModel.default.isJoinSchool   = userInfomation.isJoinSchool
            finishBlock?(userInfomation)
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 加入班级
    /// - Parameters:
    ///   - code: 班级号
    ///   - finishBlock: 加入后的事件
    func joinClass(code: String?) {
        guard let _code = code, !_code.trimed.isEmpty else {
            YXUtils.showHUD(nil, title: "班级号不能为空")
            return
        }
        let request = YXHomeRequest.joinClass(code: _code.trimed)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            NotificationCenter.default.post(name: YXNotification.kJoinClass, object: nil)
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
