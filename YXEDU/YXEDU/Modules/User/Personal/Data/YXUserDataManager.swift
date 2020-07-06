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
    func updateUserInfomation(_ finishBlock: ((YXUserInfomationModel?)->Void)?) {
        let request = YXRegisterAndLoginRequest.userInfomation
        YYNetworkService.default.request(YYStructResponse<YXUserInfomationModel>.self, request: request, success: { (response) in
            guard let userInfomation = response.data else {
                finishBlock?(nil)
                return
            }
            if !userInfomation.isJoinSchool {
                YYCache.set(true, forKey: .isShowSelectSchool)
            }
            if userInfomation.didSelectBook == 0 {
                YYCache.set(true, forKey: .isShowSelectBool)
            }
            YXUserModel.default.coinExplainUrl = userInfomation.coinExplainUrl
            YXUserModel.default.gameExplainUrl = userInfomation.gameExplainUrl
            finishBlock?(userInfomation)
        }) { error in
            finishBlock?(nil)
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    /// 加入班级
    /// - Parameters:
    ///   - code: 班级号
    ///   - finishBlock: 加入后的事件
    func joinClass(code: String?, complate: ((Bool)->Void)?) {
        guard let _code = code, !_code.trimed.isEmpty, _code != "请输入班级号" else {
            YXUtils.showHUD(nil, title: "请输入班级号")
            return
        }
        let request = YXHomeRequest.joinClass(code: _code.trimed)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            complate?(true)
            NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
        }) { (error) in
            complate?(false)
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
