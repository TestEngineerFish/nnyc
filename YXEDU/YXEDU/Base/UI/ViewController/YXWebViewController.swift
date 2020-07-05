//
//  YXWebViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWebViewController: YXViewController {

    var webView: YXWebView?
    let jsBridge = YRWebViewJSBridge()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func bindProperty() {
//        self.jsBridge.delegate = self
//        self.jsBridge.webView  = webView
    }

    private func createSubviews() {

    }

}
