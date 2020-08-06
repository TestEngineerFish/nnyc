//
//  YXAlertWebView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import WebKit

class YXAlertWebView: YXTopWindowView, WKNavigationDelegate {

    var url: URL?

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        return view
    }()

    var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor     = UIColor.white
        webView.layer.cornerRadius  = AdaptIconSize(14)
        webView.layer.masksToBounds = true
        webView.scrollView.showsVerticalScrollIndicator   = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()

    var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "alertCloseIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.style            = .gray
        indicatorView.startAnimating()
        return indicatorView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.webView.navigationDelegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(webView)
        self.addSubview(closeImageView)
        self.webView.addSubview(indicatorView)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        webView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptIconSize(-40))
            make.size.equalTo(CGSize(width: AdaptIconSize(331), height: AdaptIconSize(474)))
        }
        closeImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(webView.snp.bottom).offset(AdaptIconSize(14))
            make.size.equalTo(CGSize(width: AdaptIconSize(34), height: AdaptIconSize(34)))
        }
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptIconSize(34), height: AdaptIconSize(34)))
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.closeImageView.addGestureRecognizer(tap)
    }

    override func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        guard let url = self.url else {
            return
        }
        self.webView.load(URLRequest(url: url))
    }

    @objc private func hide() {
        self.removeFromSuperview()
    }

    // MARK: ==== WKNavigationDelegate ====
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
}
