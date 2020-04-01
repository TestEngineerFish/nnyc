//
//  YXWordTestViewController.swift
//  YXEDU
//
//  Created by Jake To on 4/1/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXWordTestViewController: UIViewController {
    
    // 注入到JS的对象
    let appJS = "ssaiAppJS"
    let uaTag = " SSAI_iOS"
    var webView: WKWebView?
    let jsBridge = YRWebViewJSBridge()
    
    private var initialCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.createSubviews()
        self.setUserAgent {[weak self] in
            self?.createSubviews()
            self?.loadWebView()
        }
        self.setNotification()
    }
    
    
    
    private func createSubviews() {
        let userContentController = WKUserContentController()
        userContentController.add(self, name: appJS)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        
        webView?.allowsBackForwardNavigationGestures = false
        //        webView.allowsLinkPreview = false
        
        self.view.addSubview(webView!)
        self.view.sendSubviewToBack(webView!)
        
        jsBridge.delegate = self
        jsBridge.webView = webView
    }
    
    private func setUserAgent(_ completion: @escaping () -> Void) {
        webView = WKWebView(frame: .zero)
        
        webView?.evaluateJavaScript("navigator.userAgent") { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let r = result as? String {
                if !r.hasSuffix(self.uaTag) {
                    let ua = r.appending(self.uaTag)
                    UserDefaults.standard.register(defaults: ["UserAgent" : ua])
                }
            } else {
                UserDefaults.standard.register(defaults: ["UserAgent" : self.uaTag])
            }
            
            completion()
        }
    }
    
    private func loadWebView(refresh: Bool = false) {
        if let url = URL(string: "") {
            let request = URLRequest(url: url)
            webView?.load(request)
        }
    }
    
    private func setNotification(add: Bool = true) {
        if add {
            NotificationCenter.default.addObserver(self, selector: #selector(reconnectWebSocket), name: UIApplication.willEnterForegroundNotification, object: nil)
            
        } else {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if webView?.superview != nil {
            webView?.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    
    @objc private func reconnectWebSocket() {
        let reconnectWebSocket = "window.reconnectWebSocket && window.reconnectWebSocket()"
        webView?.evaluateJavaScript(reconnectWebSocket) { (result, error) in
            print(result, error)
        }
    }
}



extension YXWordTestViewController: YRWebViewJSBridgeDelegate {
    func relationActionHandleClass() -> [String : YRWebViewJSActionDelegate.Type]? {
        return [WebViewActionType.microphone.rawValue : YRWebViewRecordAudioAction.self,
                WebViewActionType.sessionExpired.rawValue : YRWebViewSessionExpiredAction.self]
    }
}


extension YXWordTestViewController: WKUIDelegate, WKScriptMessageHandler {
    
    /** 获取相关的message    */
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        DDLogInfo("###接收到的message:\(message)");
        
        if let body = message.body as? String, message.name == appJS {
            jsBridge.onScriptMessageHandler(body)
        }
    }
    
}

extension YXWordTestViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.reload()
    }
}

