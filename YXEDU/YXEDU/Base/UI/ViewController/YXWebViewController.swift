//
//  YXWebViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWebViewController: YXViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, YRWebViewJSBridgeDelegate {

    let appJS     = "nnycAppJS"
    var webView: YXWebView?
    var requestUrlStr: String?
    var customTitle: String?
    let jsBridge = YRWebViewJSBridge()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.loadWebView()
        NotificationCenter.default.post(name: YXNotification.kShowRightButton, object: nil, userInfo: ["event":"menuEvent"])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView?.configuration.userContentController.add(self, name: appJS)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: appJS)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func bindProperty() {
        let userContentController = WKUserContentController()

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController

        webView = YXWebView(frame: .zero, configuration: configuration)
        webView?.uiDelegate         = self
        webView?.navigationDelegate = self
        webView?.scrollView.bounces = false
        webView?.isMultipleTouchEnabled = false
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator   = false
        webView?.allowsBackForwardNavigationGestures = false

        jsBridge.delegate = self
        jsBridge.webView  = webView
        if let _title = self.customTitle {
            self.customNavigationBar?.title = _title
        }
        NotificationCenter.default.addObserver(self, selector: #selector(showRuleButton(notification:)), name: YXNotification.kShowRightButton, object: nil)
    }

    private func createSubviews() {
        self.view.addSubview(webView!)
        self.view.sendSubviewToBack(webView!)
        webView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        })
    }

    // MARK: ==== Notification ====

    @objc private func showRuleButton(notification: Notification) {
        guard let funcStr = notification.userInfo?["event"] as? String else {
            return
        }
        self.customNavigationBar?.rightButtonTitle      = "规则"
        self.customNavigationBar?.rightButtonTitleColor = .orange1
        self.customNavigationBar?.rightButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        self.customNavigationBar?.rightButton.sizeToFit()
        self.customNavigationBar?.rightButtonAction = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.jsBridge.webView?.evaluateJavaScript(funcStr + "()", completionHandler: nil)
            }
        }
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
        webView.reload()
    }

    // MARK: ==== YRWebViewJSBridgeDelegate ====
    func relationActionHandleClass() -> [String : YRWebViewJSActionDelegate.Type]? {
        let list =  [WebViewActionType.share.rawValue : YXWebViewShareAction.self,
                     WebViewActionType.study.rawValue : YXWebViewStudyAction.self,
                     WebViewActionType.selectSchool.rawValue : YXWebViewSelectSchool.self,
                     WebViewActionType.selectAddress.rawValue : YXWebViewSelectAddress.self,
                     WebViewActionType.appInfo.rawValue : YXWebViewAppInfoAction.self]
        return list
    }
}
