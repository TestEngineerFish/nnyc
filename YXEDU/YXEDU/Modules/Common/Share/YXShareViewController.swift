//
//  YXShareViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXShareViewController: YXViewController {

    var shareImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.setDefaultShadow()
        imageView.layer.borderColor  = UIColor.white.cgColor
        imageView.layer.borderWidth  = AdaptSize(8)
        imageView.image = UIImage(named: "guide_320x480_2")
        if #available(iOS 11.0, *) {
            imageView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner)
        } else {
            // Fallback on earlier versions
        }

        return imageView
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = "炫耀一下"
        label.textColor     = UIColor.black3
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    var leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4.withAlphaComponent(0.5)
        return view
    }()

    var rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black4.withAlphaComponent(0.5)
        return view
    }()

    var qqImageView: UIImageView = {
        let imageView = UIImageView()
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
        imageView.image = UIImage(named: "gameShareWX")
        imageView.isUserInteractionEnabled = true
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

    var titleString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.customNavigationBar?.title = titleString
    }

    private func bindProperty() {
        let tapQQ = UITapGestureRecognizer(target: self, action: #selector(shareToQQ))
        self.qqImageView.addGestureRecognizer(tapQQ)
        let tapWechat = UITapGestureRecognizer(target: self, action: #selector(shareToWechat))
        self.wechatImageView.addGestureRecognizer(tapWechat)
        let tapTimeLine = UITapGestureRecognizer(target: self, action: #selector(shareToTimeLine))
        self.timeLineImageView.addGestureRecognizer(tapTimeLine)
    }

    private func createSubviews() {
        self.view.addSubview(shareImageView)
        self.view.addSubview(leftLineView)
        self.view.addSubview(rightLineView)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(qqImageView)
        self.view.addSubview(qqLabel)
        self.view.addSubview(wechatImageView)
        self.view.addSubview(wechatLabel)
        self.view.addSubview(timeLineImageView)
        self.view.addSubview(timeLineLabel)
        shareImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(300), height: AdaptSize(388)))
            make.top.equalToSuperview().offset(AdaptSize(35) + kNavHeight)
        }
        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(shareImageView.snp.bottom).offset(AdaptSize(48))
            make.size.equalTo(descriptionLabel.size)
        }
        leftLineView.snp.makeConstraints { (make) in
            make.right.equalTo(descriptionLabel.snp.left).offset(AdaptSize(-19))
            make.centerY.equalTo(descriptionLabel)
            make.size.equalTo(CGSize(width: AdaptSize(83), height: AdaptSize(1)))
        }
        rightLineView.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel.snp.right).offset(AdaptSize(19))
            make.centerY.equalTo(descriptionLabel)
            make.size.equalTo(CGSize(width: AdaptSize(83), height: AdaptSize(1)))
        }
        qqImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(70))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(19))
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        qqLabel.sizeToFit()
        qqLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(qqImageView)
            make.top.equalTo(qqImageView.snp.bottom).offset(AdaptSize(7))
            make.size.equalTo(qqLabel.size)
        }
        wechatImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
            make.top.equalTo(qqImageView)
        }
        wechatLabel.sizeToFit()
        wechatLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qqLabel)
            make.centerX.equalTo(wechatImageView)
            make.size.equalTo(wechatLabel.size)
        }
        timeLineImageView.snp.makeConstraints { (make) in
            make.top.equalTo(qqImageView)
            make.right.equalToSuperview().offset(AdaptSize(-70))
            make.size.equalTo(CGSize(width: AdaptSize(38), height: AdaptSize(38)))
        }
        timeLineLabel.sizeToFit()
        timeLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qqLabel)
            make.centerX.equalTo(timeLineImageView)
            make.size.equalTo(timeLineLabel.size)
        }
    }

    // MARK: ==== Event ====
    @objc private func shareToQQ() {
        QQApiManager.shared()?.share(shareImageView.image, toPaltform: .QQ, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }

    @objc private func shareToWechat() {
        WXApiManager.shared()?.share(shareImageView.image, toPaltform: .wxSession, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }

    @objc private func shareToTimeLine() {
        WXApiManager.shared()?.share(shareImageView.image, toPaltform: .wxTimeLine, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }
}

