//
//  YXReviewPlanReportViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit
import WebKit

class YXReviewPlanReportViewController: YXViewController, WKNavigationDelegate {
    
    var webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    var indicatorView: UIActivityIndicatorView = {
         let indicatorView = UIActivityIndicatorView()
         indicatorView.hidesWhenStopped = true
         indicatorView.startAnimating()
         return indicatorView
     }()
    
    var shareChannelView: YXShareDefaultView = {
        let shareView = YXShareDefaultView()
        return shareView
    }()
    
    var planId: Int = 0
    var reviewPlanName = "我的词单"
    var userName       = YXUserModel.default.userName ?? ""
    var hideShareView  = false
    
    private var urlStr: String {
        return YYEVC.apiUrl + "/share/study/review_report.html?review_plan_id=\(planId)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
    }
    
    private func bindProperty() {
        guard let url = URL(string: self.urlStr) else {
            return
        }
        self.webView.load(URLRequest(url: url))
        self.webView.navigationDelegate        = self
        self.shareChannelView.shareType        = .url
        self.shareChannelView.shareUrlStr      = self.urlStr
        self.shareChannelView.shareTitle       = userName + "的学习报告"
        self.shareChannelView.shareDescription = "我已经学完了《" + self.reviewPlanName + "》"
        self.shareChannelView.shareThumbImage  = UIImage(named: "shareUrlImage") ?? UIImage()
        self.shareChannelView.isHidden         = self.hideShareView
    }
    
    private func createSubviews() {
        self.view.addSubview(webView)
        self.view.addSubview(shareChannelView)
        self.webView.addSubview(indicatorView)
        self.view.sendSubviewToBack(webView)
        
        webView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kStatusBarHeight)
            if self.hideShareView {
                make.bottom.equalToSuperview()
            } else {
                make.bottom.equalTo(shareChannelView.snp.top).offset(AdaptSize(-24))
            }
        }
        shareChannelView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-kSafeBottomMargin - AdaptSize(38)))
            make.height.equalTo(AdaptIconSize(65))
        }
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(34), height: AdaptSize(34)))
        }
    }
    
    // MARK: ==== WKNavigationDelegate ====
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
}
