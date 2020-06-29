//
//  YXNavigationController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/29.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
