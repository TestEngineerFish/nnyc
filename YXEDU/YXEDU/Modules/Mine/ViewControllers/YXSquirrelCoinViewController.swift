//
//  YXSquirrelCoinViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/13.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

class YXSquirrelCoinViewController: YXViewController, WKNavigationDelegate {

    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "squirrelCoinBg")
        return imageView
    }()

    var coinWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
        return imageView
    }()

    var coinAmountlabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(25))
        label.textAlignment = .left
        return label
    }()

    var contentWebWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.setDefaultShadow()
        return view
    }()

    var contentWebView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor     = UIColor.white
        webView.layer.configPathShadow(cornerRadius: AdaptSize(14))
        webView.scrollView.showsVerticalScrollIndicator   = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()

    var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        return indicatorView
    }()

    var taskButton: UIButton = {
        let button = UIButton()
        button.setTitle("去赚松果币", for: .normal)
        let size = CGSize(width: AdaptSize(259), height: AdaptSize(42))
        button.size = size
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.gradientColor(with: size, colors: [UIColor.hex(0xFFBE34), UIColor.hex(0xFF790C)], direction: .vertical)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(17))
        button.layer.cornerRadius = AdaptSize(21)
        return button
    }()

    var coinAmount: String? = "0"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        
        self.taskButton.addTarget(self, action: #selector(goToEarnCoin), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func bindProperty() {
        self.coinAmountlabel.text              = coinAmount
        self.contentWebView.navigationDelegate = self
        guard let urlStr = YXUserModel.default.coinExplainUrl, let url = URL(string: urlStr) else {
            self.indicatorView.stopAnimating()
            YXUtils.showHUD(self.view, title: "加载失败，请稍后再试")
            return
        }
        self.contentWebView.load(URLRequest(url: url))
        self.indicatorView.startAnimating()
    }

    private func createSubviews() {
        self.customNavigationBar?.title                = "松果币"
        self.customNavigationBar?.titleColor           = UIColor.white
        self.customNavigationBar?.titleLabel.font      = UIFont.regularFont(ofSize: AdaptSize(17))
        self.customNavigationBar?.leftButtonTitleColor = UIColor.white
        self.customNavigationBar?.backgroundColor      = UIColor.clear
//        self.view.backgroundColor                      = UIColor.hex(0xF0F2F5)

        self.view.addSubview(backgroundImageView)
        self.view.addSubview(coinWrapView)
        self.view.addSubview(contentWebWrapView)
        self.view.addSubview(taskButton)
        contentWebWrapView.addSubview(contentWebView)
        contentWebView.addSubview(indicatorView)
        coinWrapView.addSubview(coinImageView)
        coinWrapView.addSubview(coinAmountlabel)
        self.view.sendSubviewToBack(backgroundImageView)

        backgroundImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-kNavHeight)
            make.height.equalTo(AdaptSize(375))
        }
        coinAmountlabel.sizeToFit()
        coinWrapView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(28))
            make.top.equalToSuperview().offset(kNavHeight + AdaptSize(11))
            make.width.equalTo(AdaptSize(36) + coinAmountlabel.width)
        }
        coinImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(28), height: AdaptSize(28)))
        }
        coinAmountlabel.snp.makeConstraints { (make) in
            make.left.equalTo(coinImageView.snp.right).offset(AdaptSize(8))
            make.right.equalToSuperview()
            make.height.centerY.equalToSuperview()
        }
        contentWebWrapView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(coinWrapView.snp.bottom).offset(AdaptSize(22))
            make.left.equalToSuperview().offset(AdaptSize(11))
            make.bottom.equalTo(taskButton.snp.top).offset(AdaptSize(-14))
        }
        contentWebView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        taskButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-31) - kSafeBottomMargin)
            make.size.equalTo(CGSize(width: AdaptSize(269), height: AdaptSize(42)))
        }
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(34), height: AdaptSize(34)))
        }
    }
    
    @objc
    private func goToEarnCoin() {
        let home = UIStoryboard(name: "Home", bundle: nil)
        let taskCenterViewController = home.instantiateViewController(withIdentifier: "YXTaskCenterViewController") as! YXTaskCenterViewController
        taskCenterViewController.fromYXSquirrelCoinViewController = true
        
        self.navigationController?.pushViewController(taskCenterViewController, animated: true)
    }

    // MARK: ==== WKNavigationDelegate ====
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.indicatorView.stopAnimating()
    }
}
