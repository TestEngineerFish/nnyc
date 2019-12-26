//
//  YXShareViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXShareType {
    /// 学习结果分享
    case learnResult
    /// 智能复习分享
    case aiReviewReuslt
    /// 复习计划分享
    case planReviewResult
    /// 听写复习分享
    case listenReviewResult
    /// 挑战结果分享
    case challengeResult
}

class YXShareViewController: YXViewController {

    var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.setDefaultShadow(radius: AdaptSize(13))
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
    var wordsAmount = 0
    var daysAmount  = 0
    var shareType: YXShareType = .challengeResult

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

        self.shareImageView.image = self.createListenReviewShareImage()
        switch self.shareType {
        case .learnResult:
            self.shareImageView.image = self.createLearnResultShareImage()
        case .aiReviewReuslt:
            self.shareImageView.image = self.createAIReviewShareImage()
        case .planReviewResult:
            self.shareImageView.image = self.createPlanReviewShareImage()
        case .listenReviewResult:
            self.shareImageView.image = self.createListenReviewShareImage()
        case .challengeResult:
            self.shareImageView.image = self.createListenReviewShareImage()
        }
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
            make.size.equalTo(CGSize(width: AdaptSize(319), height: AdaptSize(436)))
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
            make.right.equalTo(timeLineImageView).offset(AdaptSize(15))
            make.top.equalTo(timeLineImageView).offset(AdaptSize(-6))
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

    /// 创建学习结果打卡页面
    private func createLearnResultShareImage() -> UIImage? {

        // ---- 数据准备 ----
//        guard let url = URL(string: self.imageUrlStr) else {
//            return nil
//        }
//        let data = try? Data(contentsOf: url)
//        guard let _data = data, let backgroundImage = UIImage(data: _data) else {
//            return nil
//        }
        let shareBgImage = UIImage(named: "learnShareBgImage")
        let iconImage = UIImage(named: "gameShareLogo")
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词背单词"
            label.textColor     = UIColor.white
            label.font          = UIFont.mediumFont(ofSize: 15)
            label.textAlignment = .center
            return label
        }()
        let contentImage = UIImage(named: "learnShareContent")
        let learnWordsAmountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(self.wordsAmount)"
            label.textColor     = UIColor.black1
            label.font          = UIFont.DINAlternateBold(ofSize: 34)
            label.textAlignment = .left
            return label
        }()
        let daysAmountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(self.daysAmount)"
            label.textColor     = UIColor.black1
            label.font          = UIFont.DINAlternateBold(ofSize: 34)
            label.textAlignment = .left
            return label
        }()
        let learnWordTitleLabel: UILabel = {
            let label = UILabel()
            label.text          = "今日单词"
            label.textColor     = UIColor.black2
            label.font          = UIFont.regularFont(ofSize: 14)
            label.textAlignment = .left
            return label
        }()
        let daysTitleLabel: UILabel = {
            let label = UILabel()
            label.text          = "坚持天数"
            label.textColor     = UIColor.black2
            label.font          = UIFont.regularFont(ofSize: 14)
            label.textAlignment = .left
            return label
        }()
        let qrcordImage = UIImage(named: "shareQRCode")

        // ---- 内容绘制 ----
        let imageSize = CGSize(width: 375, height: 513)
        UIGraphicsBeginImageContext(imageSize)
        shareBgImage?.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        iconImage?.draw(in: CGRect(x: 20, y: 16, width: 37, height: 37))
        titleLabel.drawText(in: CGRect(x: 67, y: 23, width: 136, height: 21))
        contentImage?.draw(in: CGRect(x: 21, y: 395, width: 333, height: 100))
        learnWordsAmountLabel.drawText(in: CGRect(x: 52, y: 415, width: 66, height: 40))
        daysAmountLabel.drawText(in: CGRect(x: 159, y: 415, width: 60, height: 40))
        learnWordTitleLabel.drawText(in: CGRect(x: 52, y: 455, width: 57, height: 20))
        daysTitleLabel.drawText(in: CGRect(x: 159, y: 455, width: 57, height: 20))
        qrcordImage?.draw(in: CGRect(x: 275, y: 418, width: 55, height: 55))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }

    /// 创建听写复习打卡分享页面
    private func createListenReviewShareImage() -> UIImage? {
        let logoImage = UIImage(named: "gameShareLogo2")
        let shareBgImage = UIImage(named: "ListenReviewShareBgImage")
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词完成了"
            label.textColor     = UIColor.hex(0x126172)
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = UIColor.hex(0x126172)
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个单词的听写练习"
            label.textColor     = UIColor.hex(0x126172)
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let contentImage = UIImage(named: "reviewShareContent")
        let bottomLabel: UILabel = {
            let label = UILabel()
            label.text          = "听写不求人\n自己就能做听写练习"
            label.textColor     = UIColor.black1
            label.font          = UIFont.regularFont(ofSize: 15)
            label.numberOfLines = 2
            label.textAlignment = .left
            return label
        }()
        let qrcordImage = UIImage(named: "shareQRCode")
        let qrcordLabel: UILabel = {
            let label = UILabel()
            label.text          = "扫码下载  智能背词"
            label.textColor     = UIColor.black2
            label.font          = UIFont.regularFont(ofSize: 10)
            label.textAlignment = .center
            return label
        }()

        // ---- 内容绘制 ----
        let imageSize = CGSize(width: 375, height: 514)
        UIGraphicsBeginImageContext(imageSize)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 56, y: 147, width: 181, height: 28))
        amountLabel.drawText(in: CGRect(x: 116, y: 179, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 116 + amountLabel.width, y: 193, width: 161, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 100))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }

    /// 创建听写复习打卡分享页面
    private func createAIReviewShareImage() -> UIImage? {
        let logoImage = UIImage(named: "gameShareLogo2")
        let shareBgImage = UIImage(named: "reviewAIShareBgImage")
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "智能复习帮我自动巩固单词"
            label.textColor     = UIColor.hex(0x863A05)
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = UIColor.hex(0x863A05)
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个"
            label.textColor     = UIColor.hex(0x863A05)
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let contentImage = UIImage(named: "reviewShareContent")
        let bottomLabel: UILabel = {
            let label = UILabel()
            label.text          = "听写不求人\n自己就能做听写练习"
            label.textColor     = UIColor.black1
            label.font          = UIFont.regularFont(ofSize: 15)
            label.numberOfLines = 2
            label.textAlignment = .left
            return label
        }()
        let qrcordImage = UIImage(named: "shareQRCode")
        let qrcordLabel: UILabel = {
            let label = UILabel()
            label.text          = "扫码下载  智能背词"
            label.textColor     = UIColor.black2
            label.font          = UIFont.regularFont(ofSize: 10)
            label.textAlignment = .center
            return label
        }()

        // ---- 内容绘制 ----
        let imageSize = CGSize(width: 375, height: 514)
        UIGraphicsBeginImageContext(imageSize)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 72, y: 152, width: 241, height: 28))
        amountLabel.drawText(in: CGRect(x: 161, y: 184, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 161 + amountLabel.width, y: 198, width: 21, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 100))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }

    /// 创建听写复习打卡分享页面
    private func createPlanReviewShareImage() -> UIImage? {
        let logoImage = UIImage(named: "gameShareLogo2")
        let shareBgImage = UIImage(named: "reviewPlanShareBgImage")
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词完成了"
            label.textColor     = UIColor.hex(0x44107A)
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = UIColor.hex(0x44107A)
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个"
            label.textColor     = UIColor.hex(0x44107A)
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let contentImage = UIImage(named: "reviewShareContent")
        let bottomLabel: UILabel = {
            let label = UILabel()
            label.text          = "听写不求人\n自己就能做听写练习"
            label.textColor     = UIColor.black1
            label.font          = UIFont.regularFont(ofSize: 15)
            label.numberOfLines = 2
            label.textAlignment = .left
            return label
        }()
        let qrcordImage = UIImage(named: "shareQRCode")
        let qrcordLabel: UILabel = {
            let label = UILabel()
            label.text          = "扫码下载  智能背词"
            label.textColor     = UIColor.black2
            label.font          = UIFont.regularFont(ofSize: 10)
            label.textAlignment = .center
            return label
        }()

        // ---- 内容绘制 ----
        let imageSize = CGSize(width: 375, height: 514)
        UIGraphicsBeginImageContext(imageSize)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 46, y: 147, width: 181, height: 28))
        amountLabel.drawText(in: CGRect(x: 126, y: 179, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 126 + amountLabel.width, y: 193, width: 161, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 100))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
}
