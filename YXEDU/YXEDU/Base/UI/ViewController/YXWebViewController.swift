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
    let jsBridge    = YRWebViewJSBridge()
    var callBackDic = [String:String]()
    var reloadCount = 0
    
    let loadingView = UIActivityIndicatorView()
    var rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("规则", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: appJS)
        self.webView?.configuration.userContentController.add(self, name: appJS)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: appJS)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.rightButton.removeFromSuperview()
        self.clearCacheData()
        self.webView?.removeObserver(self, forKeyPath: "title")
    }
    
    private func clearCacheData() {
        let dateFrom = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: dateFrom) {
            YXLog("WKWebView清除缓存完毕！")
        }
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
        webView?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        
        jsBridge.delegate = self
        jsBridge.webView  = webView
        if let _title = self.customTitle {
            self.customNavigationBar?.title = _title
        }
        NotificationCenter.default.addObserver(self, selector: #selector(showRuleButton(notification:)), name: YXNotification.kShowRightButton, object: nil)
        self.loadingView.hidesWhenStopped = true
    }
    
    private func createSubviews() {
        guard let _webView = self.webView else {
            return
        }
        self.view.addSubview(_webView)
        self.view.addSubview(loadingView)
        self.view.sendSubviewToBack(_webView)
        _webView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        })
        loadingView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
        })
    }
    
    // MARK: ==== Notification ====
    
    @objc private func showRuleButton(notification: Notification) {
        guard let funcStr = notification.userInfo?["event"] as? String else {
            return
        }
        self.callBackDic["rule"] = funcStr
        self.rightButton.removeFromSuperview()
        self.customNavigationBar?.addSubview(self.rightButton)
        self.rightButton.sizeToFit()
        self.rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(self.rightButton.size)
        }
        self.rightButton.addTarget(self, action: #selector(showRule), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    
    @objc private func showRule() {
        guard let _funcStr = self.callBackDic["rule"] else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.jsBridge.webView?.evaluateJavaScript(_funcStr + "()", completionHandler: nil)
        }
    }
    
    private func loadWebView() {
        guard let urlStr = self.requestUrlStr, let url = URL(string: urlStr) else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.loadingView.startAnimating()
        let requestUrl = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15.0)
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
        if self.reloadCount < 3 {
            webView.reload()
            self.reloadCount += 1
        }
        YXLog("WebView Load Error:", (error as NSError).message)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.loadingView.stopAnimating()
        YXLog("页面加载完成✅")
    }
    
    // MARK: ==== YRWebViewJSBridgeDelegate ====
    func relationActionHandleClass() -> [String : YRWebViewJSActionDelegate.Type]? {
        let list =  [WebViewActionType.share.rawValue : YXWebViewShareAction.self,
                     WebViewActionType.study.rawValue : YXWebViewStudyAction.self,
                     WebViewActionType.selectSchool.rawValue : YXWebViewSelectSchool.self,
                     WebViewActionType.selectAddress.rawValue : YXWebViewSelectAddress.self,
                     WebViewActionType.appInfo.rawValue : YXWebViewAppInfoAction.self,
                     WebViewActionType.addMenu.rawValue : YXWebViewMenuAction.self,
                     WebViewActionType.addLog.rawValue : YXWebViewAddLogAction.self]
        return list
    }
    
    // MARK: ==== KVO ====
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            self.customNavigationBar?.title = self.webView?.title
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
