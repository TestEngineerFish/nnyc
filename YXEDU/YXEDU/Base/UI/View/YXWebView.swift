//
//  YXWebView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWebView: WKWebView, WKUIDelegate, WKScriptMessageHandler {
    let appJS = "ssaiAppJS"
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        let _userContentController = WKUserContentController()
//        _userContentController.add(self, name: appJS)

        let _configuration = WKWebViewConfiguration()
        _configuration.userContentController = _userContentController
        super.init(frame: frame, configuration: _configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
//
//        webView = WKWebView(frame: .zero, configuration: configuration)
//        webView?.uiDelegate = self
//        webView?.navigationDelegate = self
//        webView?.scrollView.bounces = false
//
//        webView?.allowsBackForwardNavigationGestures = false
//        //        webView.allowsLinkPreview = false
//
//        self.view.addSubview(webView!)
//        self.view.sendSubviewToBack(webView!)
//
//        jsBridge.delegate = self
//        jsBridge.webView = webView
    }

    // MARK: ==== WKUIDelegate ====

    // MARK: ==== WKScriptMessageHandler ====
    /** 获取相关的message    */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        DDLogInfo("###接收到的message:\(message)");
//
//        if let body = message.body as? String, message.name == appJS {
//            jsBridge.onScriptMessageHandler(body)
//        }
    }
}
