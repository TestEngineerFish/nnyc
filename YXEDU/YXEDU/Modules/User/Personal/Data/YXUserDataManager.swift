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
            YXUserModel.default.coinExplainUrl = userInfomation.coinExplainUrl
            YXUserModel.default.gameExplainUrl = userInfomation.gameExplainUrl
            finishBlock?(userInfomation)
        }) { error in
            finishBlock?(nil)
            DispatchQueue.main.async {
                YXUtils.showHUD(nil, title: error.message)
            }
        }
    }

    /// 加入班级
    /// - Parameters:
    ///   - code: 班级号
    ///   - finishBlock: 加入后的事件
    func joinClass(code: String?, complate: ((Bool)->Void)?) {
        guard var _code = code, !_code.trimed.isEmpty, _code != "输入班级号或作业提取码" else {
            YXUtils.showHUD(nil, title: "请输入班级号或作业提取码")
            return
        }
        _code = _code.trimed
        let classCode = _code.isPureNumbers() ? _code : ""
        let workCode  = _code.isPureNumbers() ? "" : _code
        let request = YXHomeRequest.joinClass(classCode: classCode, workCode: workCode)
        YYNetworkService.default.request(YYStructResponse<YXMyClassSummaryModel>.self, request: request, success: { (response) in
            if response.data?.isFirstJoin == .some(true) {
                let vc = YXMyClassEditNameViewController()
                vc.submitBlock = complate
                vc.classModel  = response.data
                YRRouter.sharedInstance().currentNavigationController()?.popViewController(animated: false)
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            } else {
                complate?(true)
            }
            NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
        }) { (error) in
            complate?(false)
            YXUtils.showHUD(nil, title: error.message)
        }
    }
}
