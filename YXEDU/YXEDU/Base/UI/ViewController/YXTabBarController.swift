//
//  YXTabBarController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/4.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tabBar.items?[1].title = YXReviewDataManager.reviewPlanName
        }
        NotificationCenter.default.addObserver(self, selector: #selector(updateTabBadge), name: YXNotification.kUpdateFeedbackReplyBadge, object: nil)
    }
    
    @objc private func updateTabBadge() {
        let badgeNum = YXBadgeManager.share.getFeedbackReplyBadgeNum()
        self.children.last?.tabBarItem.badgeColor = UIColor.clear
        self.children.last?.tabBarItem.badgeValue = badgeNum > 0 ? "" : nil
    }
}
