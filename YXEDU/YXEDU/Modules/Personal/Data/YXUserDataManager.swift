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
            YXConfigure.shared().isShowKeyboard = (userInfomation.fillType == .keyboard)
            YXConfigure.shared().saveCurrentToken()
            YXUserModel.default.coinExplainUrl = userInfomation.coinExplainUrl
            YXUserModel.default.gameExplainUrl = userInfomation.gameExplainUrl
            YXUserModel.default.reviewNameType = userInfomation.reviewNameType
            finishBlock?(userInfomation)
        }) { error in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }

    


}
