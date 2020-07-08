//
//  YXWebViewMenuAction.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewMenuAction: YRWebViewJSAction {
    override func action() {
        super.action()
        if let json = self.params as? [String:Any], let actionModel = MenuActionModel(JSON: json) {
            if actionModel.type == 2 {
                NotificationCenter.default.post(name: YXNotification.kShowRightButton, object: nil, userInfo: ["event":actionModel.event])
            }
        }
    }

}
