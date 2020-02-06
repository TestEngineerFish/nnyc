//
//  YXShareDefaultView.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/6.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

enum YXShareChannel: Int {
    case qq       = 1
    case wechat   = 2
    case timeLine = 3
}

enum YXShareType: Int {
    case image = 0
    case url   = 1
}

class YXShareDefaultView: UIView {
    
    var qqImageView: UIImageView = {
        let imageView   = UIImageView()
        imageView.image = UIImage(named: "gameShareQQ")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var qqLabel: UILabel = {
        let label = UILabel()
        label.text          = "QQ"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()
    
    var wechatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameShareWechat")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image    = UIImage(named: "challengeGoldIcon")
        imageView.isHidden = true
        return imageView
    }()
    
    var wechatLabel: UILabel = {
        let label = UILabel()
        label.text          = "微信"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()
    
    var timeLineImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameShareTimeLine")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var timeLineLabel: UILabel = {
        let label = UILabel()
        label.text          = "朋友圈"
        label.textColor     = UIColor.black2
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .center
        return label
    }()
    
    typealias FinishedBlock = ((YXShareChannel) -> Void)
    var shareType: YXShareType = .image
    var shareImag: UIImage?
    var shareUrl: URL?
    var finishedBlock: FinishedBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bindProperty()
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindProperty() {
        let tapQQ       = UITapGestureRecognizer(target: self, action: #selector(shareToQQ))
        let tapWechat   = UITapGestureRecognizer(target: self, action: #selector(shareToWechat))
        let tapTimeLine = UITapGestureRecognizer(target: self, action: #selector(shareToTimeLine))
        self.qqImageView.addGestureRecognizer(tapQQ)
        self.wechatImageView.addGestureRecognizer(tapWechat)
        self.timeLineImageView.addGestureRecognizer(tapTimeLine)
        self.coinImageView.isHidden = true
    }
    
    private func createSubviews() {
        self.addSubview(qqImageView)
        self.addSubview(qqLabel)
        self.addSubview(wechatImageView)
        self.addSubview(wechatLabel)
        self.addSubview(timeLineImageView)
        self.addSubview(timeLineLabel)
        self.addSubview(coinImageView)
        
        qqImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(70))
            make.top.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        qqLabel.sizeToFit()
        qqLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(qqImageView)
            make.bottom.equalToSuperview()
            make.size.equalTo(qqLabel.size)
        }
        wechatImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
            make.top.equalTo(qqImageView)
        }
        wechatLabel.sizeToFit()
        wechatLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(wechatImageView)
            make.size.equalTo(wechatLabel.size)
        }
        timeLineImageView.snp.makeConstraints { (make) in
            make.top.equalTo(qqImageView)
            make.right.equalToSuperview().offset(AdaptSize(-70))
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        coinImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(25), height: AdaptSize(25)))
            make.right.equalTo(timeLineImageView).offset(AdaptSize(15))
            make.top.equalTo(timeLineImageView).offset(AdaptSize(-6))
        }
        timeLineLabel.sizeToFit()
        timeLineLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(timeLineImageView)
            make.size.equalTo(timeLineLabel.size)
        }
    }
    
    // MARK: ==== Share Event ====
    @objc private func shareToQQ() {
        switch self.shareType {
        case .image:
            guard let image = self.shareImag else {
                return
            }
            self.shareImage(to: .qq, with: image, finishedBlock: self.finishedBlock)
        case .url:
            guard let url = self.shareUrl else {
                return
            }
            self.shareUrl(to: .qq, with: url, finishedBlock: self.finishedBlock)
        }
    }
    
    @objc private func shareToWechat() {
        switch self.shareType {
        case .image:
            guard let image = self.shareImag else {
                return
            }
            self.shareImage(to: .wechat, with: image, finishedBlock: self.finishedBlock)
        case .url:
            guard let url = self.shareUrl else {
                return
            }
            self.shareUrl(to: .wechat, with: url, finishedBlock: self.finishedBlock)
        }
    }
    
    @objc private func shareToTimeLine() {
        switch self.shareType {
        case .image:
            guard let image = self.shareImag else {
                return
            }
            self.shareImage(to: .timeLine, with: image, finishedBlock: self.finishedBlock)
        case .url:
            guard let url = self.shareUrl else {
                return
            }
            self.shareUrl(to: .timeLine, with: url, finishedBlock: self.finishedBlock)
        }
    }
    
    
    // MARK: ==== Tools ====
    private func shareImage(to channel: YXShareChannel, with image: UIImage, finishedBlock:FinishedBlock?) {
        switch channel {
        case .qq:
            QQApiManager.shared()?.share(image, toPaltform: .QQ, title: "", describution: "", shareBusiness: "")
            QQApiManager.shared()?.finishBlock = { (obj1: Any, obj2: Any, result: Bool) in
                finishedBlock?(.qq)
            }
        case .wechat:
            WXApiManager.shared()?.share(image, toPaltform: .wxSession, title: "", describution: "", shareBusiness: "")
            WXApiManager.shared()?.finishBlock = { (obj: Any, result: Bool) in
                finishedBlock?(.wechat)
            }
        case .timeLine:
            WXApiManager.shared()?.share(image, toPaltform: .wxTimeLine, title: "", describution: "", shareBusiness: "")
            WXApiManager.shared()?.finishBlock = { (obj: Any, result: Bool) in
                finishedBlock?(.timeLine)
            }
        }
    }
    private func shareUrl(to channel: YXShareChannel, with url: URL, finishedBlock:FinishedBlock?) {
        
    }
    
}
