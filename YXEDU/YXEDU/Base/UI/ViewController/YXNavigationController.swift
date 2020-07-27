//
//  YXNavigationController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/29.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: ==== UIGestureRecognizerDelegate ====
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first {
                return false
            }
        }
        // 特殊VC，不支持侧滑返回
        let specialVCList = [YXExerciseViewController.classForCoder(),
                             YXExerciseResultViewController.classForCoder(),
                             YXLearningResultViewController.classForCoder(),
                             YXBindPhoneViewController.classForCoder(),
                             YXSelectSchoolViewController.classForCoder(),
                             YXAddBookGuideViewController.classForCoder()]
        if specialVCList.contains(where: { (classType) -> Bool in
            self.topViewController?.classForCoder == .some(classType)
        }) {
            return false
        }
        return true
    }

}
