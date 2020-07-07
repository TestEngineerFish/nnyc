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
    let appJS = "nnycAppJS"
    var webView: WKWebView?
    let jsBridge = YRWebViewJSBridge()
    
    private var initialCenter = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSubviews()
        self.loadWebView()
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
    
    private func loadWebView(refresh: Bool = false) {
        if let url = URL(string: "") {
            let request = URLRequest(url: url)
            webView?.load(request)
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
}



extension YXWordTestViewController: YRWebViewJSBridgeDelegate {
    func relationActionHandleClass() -> [String : YRWebViewJSActionDelegate.Type]? {
        return [WebViewActionType.share.rawValue : YRWebViewShareAction.self]
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

