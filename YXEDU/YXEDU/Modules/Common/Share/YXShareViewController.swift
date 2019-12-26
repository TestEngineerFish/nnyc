//
//  YXShareViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXShareType {
    case learnResult
    case reviewResult
    case reviewAIReuslt
    case reviewListenResult
    case challengeResult
}

class YXShareViewController: YXViewController {

    var shareImageView: YXKVOImageView = {
        let imageView = YXKVOImageView()
        imageView.layer.setDefaultShadow()
        imageView.layer.borderColor  = UIColor.white.cgColor
        imageView.layer.borderWidth  = AdaptSize(8)
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
        imageView.image = UIImage(named: "gameShareWechat")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    var goldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "challengeGoldIcon")
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
    var imageUrlStr = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindProperty()
        self.createSubviews()
        self.customNavigationBar?.title = titleString
    }

    private func bindProperty() {
        let tapQQ = UITapGestureRecognizer(target: self, action: #selector(shareToQQ))
        let tapWechat = UITapGestureRecognizer(target: self, action: #selector(shareToWechat))
        let tapTimeLine = UITapGestureRecognizer(target: self, action: #selector(shareToTimeLine))
        self.qqImageView.addGestureRecognizer(tapQQ)
        self.wechatImageView.addGestureRecognizer(tapWechat)
        self.timeLineImageView.addGestureRecognizer(tapTimeLine)
        self.shareImageView.showImage(with: imageUrlStr)
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
        self.view.addSubview(goldImageView)
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
        goldImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(25), height: AdaptSize(25)))
            make.right.equalTo(timeLineLabel).offset(AdaptSize(15))
            make.top.equalTo(timeLineLabel).offset(AdaptSize(-6))
        }
        timeLineLabel.sizeToFit()
        timeLineLabel.snp.makeConstraints { (make) in
            make.top.equalTo(qqLabel)
            make.centerX.equalTo(timeLineImageView)
            make.size.equalTo(timeLineLabel.size)
        }
    }

    // MARK: ==== Share Event ====
    @objc private func shareToQQ() {
        QQApiManager.shared()?.share(shareImageView.image, toPaltform: .QQ, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }

    @objc private func shareToWechat() {
        WXApiManager.shared()?.share(shareImageView.image, toPaltform: .wxSession, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }

    @objc private func shareToTimeLine() {
        WXApiManager.shared()?.share(shareImageView.image, toPaltform: .wxTimeLine, title: "分享标题", describution: "分享描述", shareBusiness: "shareBusiness")
    }

    // MARK: ==== Tools ====
    private func createShareImageView(_ type: YXShareType, wordNum: Int, days: Int) -> UIImage? {

        // ---- 数据准备 ----
        guard let url = URL(string: self.imageUrlStr) else {
            return nil
        }
        let data = try? Data(contentsOf: url)
        guard let _data = data, let backgroundImage = UIImage(data: _data) else {
            return nil
        }
        let iconImage = UIImage(named: "gameShareLogo")
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词背单词"
            label.textColor     = UIColor.white
            label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
            label.textAlignment = .center
            return label
        }()
        var contentView: UIView = {
            let view = UIView()
            view.backgroundColor     = UIColor.white
            view.layer.cornerRadius  = AdaptSize(8)
            view.layer.masksToBounds = true
            return view
        }()

        // ---- 内容绘制 ----
        let imageSize = CGSize(width: AdaptSize(375), height: AdaptSize(513))
        UIGraphicsBeginImageContext(imageSize)
        backgroundImage.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        iconImage?.draw(in: CGRect(x: AdaptSize(20), y: AdaptSize(16), width: AdaptSize(37), height: AdaptSize(37)))
        titleLabel.drawText(in: CGRect(x: AdaptSize(67), y: AdaptSize(23), width: AdaptSize(136), height: AdaptSize(21)))


        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage

    }
}

