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
        // 拦截
        guard YXUserModel.default.didLogin else {
            return
        }
        guard let model = YXWXWebModel(JSONString: info) else {
            return
        }
        switch model.action {
        case "join_class", "add_word":
            let classNumber = model.params
            // 加入班级
            YXUserDataManager.share.joinClass(code: classNumber) { (result) in
                if result {
                    self.toVC(scheme: model.scheme)
                }
            }
            break
        case "make_team":
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
}
