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
//        self.registerNotification()
        self.interactivePopGestureRecognizer?.delegate = self
    }

    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotAction), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    // MARK: ==== Event ====
    @objc private func screenshotAction() {
        YXLog("检测到截屏")
        let image = self.getScreenshotImage()
        let alertView = YXAlertView()
        alertView.titleLabel.text = "提示"
        alertView.descriptionLabel.text = "是否提交反馈"
        alertView.doneClosure = { [weak self] (text:String?) in
            self?.toFeedbackVC(image: image)
        }
        YXAlertQueueManager.default.addAlert(alertView: alertView)
    }

    private func toFeedbackVC(image: UIImage?) {
        let vc = YXPersonalFeedBackVC()
        vc.screenShotImage = image

        YRRouter.sharedInstance().currentNavigationController()?.present(vc, animated: true, completion: nil)
    }

    // MARK: ==== Tools ====
    private func getScreenshotImage() -> UIImage? {
        guard let layer = UIApplication.shared.keyWindow?.layer else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: layer.frame.size)
        let image = renderer.image { (context: UIGraphicsImageRendererContext) in
            layer.render(in: context.cgContext)
        }
        return image
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
