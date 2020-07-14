//
//  YXWebActionManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

@objc
class YXWebActionManager: NSObject {
    @objc static let share = YXWebActionManager()

    @objc
    func progressWXReq(extion info: String) {
//        let dict = ["open_app_action":"join_class", "open_app_scheme" : "/class/list", "action_params" : "6344121"]
//        let _info = dict.toJson()
        guard let model = YXWXWebModel(JSONString: info) else {
            return
        }
        // 状态拦截
        guard YXUserModel.default.didLogin, (YYCache.object(forKey: .isShowSelectSchool) as? Bool) == .some(false), (YYCache.object(forKey: .isShowSelectBool) as? Bool) == .some(false) else {
            YXLog("状态拦截")
            return
        }
        // 页面拦截
        guard let currentVC = YRRouter.sharedInstance().currentViewController(), !currentVC.isKind(of: YXBindPhoneViewController.classForCoder()), !currentVC.isKind(of: YXExerciseViewController.classForCoder()) else {
            YXLog("页面拦截")
            return
        }

        switch model.action {
        case "join_class", "add_work":
            let classNumber = model.params
            // 加入班级
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                if result {
                    self.toVC(scheme: model.scheme)
                }
            }
            break
        case "make_team":
            self.addFriend(user: model.params, channel: 1, complete: nil)
            break
        default:
            break
        }
    }

    // MARK: ==== Tools ====
    private func toVC(scheme: String) {
        switch scheme {
        case "/class/list":
            if YRRouter.sharedInstance().currentViewController()?.isKind(of: YXMyClassViewController.classForCoder()) == .some(false) {
                let vc = YXMyClassViewController()
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            }
        case "/activity/detail":
            if YRRouter.sharedInstance().currentViewController()?.isKind(of: YXWebViewController.classForCoder()) == .some(false) {
                let vc = YXWebViewController()
                YRRouter.sharedInstance().currentNavigationController()?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }

    private func addFriend(user id: String, channel: Int, complete block: (()->Void)?) {
        guard let userId = Int(id) else {
            return
        }
        let request = YXHomeRequest.addFriend(id: userId, channel: channel)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            YXLog("添加好友成功")
            block?()
        }) { (error) in
            YXUtils.showHUD(kWindow, title: error.message)
        }
    }
}
