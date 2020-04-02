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
        NotificationCenter.default.addObserver(self, selector: #selector(updateTabBadge), name: YXNotification.kUpdateFeedbackReplyBadge, object: nil)
    }
    
    @objc private func updateTabBadge() {
        let badgeNum = YXRedDotManager.share.getFeedbackReplyBadgeNum()
        self.children.last?.tabBarItem.badgeColor = UIColor.clear
        self.children.last?.tabBarItem.badgeValue = badgeNum > 0 ? "" : nil
    }
}
