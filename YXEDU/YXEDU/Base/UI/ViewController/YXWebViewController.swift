//
//  YXWebViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWebViewController: YXViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, YRWebViewJSBridgeDelegate {

    let appJS     = "ssaiAppJS"
    let uaTag     = " SSAI_iOS"
    let userAgent = "navigator.userAgent"
    var webView: YXWebView?
    var requestUrlStr: String?
    var customTitle: String?
    let jsBridge = YRWebViewJSBridge()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.loadWebView()
    }

    private func bindProperty() {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: appJS)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        webView = YXWebView(frame: .zero, configuration: configuration)
        webView?.uiDelegate         = self
        webView?.navigationDelegate = self
        webView?.scrollView.bounces = false
        webView?.allowsBackForwardNavigationGestures = false

        jsBridge.delegate = self
        jsBridge.webView  = webView
        if let _title = self.customTitle {
            self.customNavigationBar?.title = _title
        }
    }

    private func createSubviews() {
        self.view.addSubview(webView!)
        self.view.sendSubviewToBack(webView!)
        webView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        })
    }

    // MARK: ==== Event ====

    private func loadWebView() {
        guard let urlStr = self.requestUrlStr, let url = URL(string: urlStr) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        let requestUrl = URLRequest(url: url)
        self.webView?.load(requestUrl)
    }

    // MARK: ==== WKScriptMessageHandler ====
    /** 获取相关的message    */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        YXLog("###接收到的message:\(message)")

        if let body = message.body as? String, message.name == appJS {
            jsBridge.onScriptMessageHandler(body)
        }
    }

    // MARK: ==== WKNavigationDelegate ====
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.webView?.reload()
    }
}
