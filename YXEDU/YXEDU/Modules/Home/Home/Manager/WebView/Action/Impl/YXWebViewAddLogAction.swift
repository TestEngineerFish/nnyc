//
//  YXWebViewAddLogAction.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/31.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXWebViewAddLogAction: YRWebViewJSAction {
    override func action() {
        super.action()
        if let json = self.params as? [String: Any] {
            let type    = json["type"] as? Int ?? 0
            let message = json["content"] as? String ?? ""
            if type == 1 {
                YXLog("【WebView】", message)
            } else {
                YXRequestLog("【WebView】", message)
            }
            // 回调处理
            guard let callBackStr = self.callback else {
                return
            }
            let resultDic = ["result":true]
            let funcStr = String(format: "%@('%@')", callBackStr, resultDic.toJson())
            DispatchQueue.main.async { [weak self] in
                self?.jsBridge?.webView?.evaluateJavaScript(funcStr, completionHandler: nil)
            }
        }
    }

}
