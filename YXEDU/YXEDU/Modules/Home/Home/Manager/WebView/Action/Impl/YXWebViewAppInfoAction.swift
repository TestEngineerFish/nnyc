//
//  YXWebViewAppInfoAction.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/7.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewAppInfoAction: YRWebViewJSAction {
    override func action() {
        super.action()
        guard let callBackStr = self.callback else {
            return
        }
        let appVersion = UIDevice().appVersion() ?? ""
        let osVersion  = UIDevice().sysVersion() ?? ""
        let platform   = "iOS"
        let screen     = UIDevice().screenResolution() ?? ""
        let resultDic  = ["app_version" : appVersion,
                          "os_version" : osVersion,
                          "platform" : platform,
                          "screen" : screen]
        let funcStr    = String(format: "%@('%@')", callBackStr, resultDic.toJson())
        DispatchQueue.main.async {
            self.jsBridge.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
        }

    }

}
