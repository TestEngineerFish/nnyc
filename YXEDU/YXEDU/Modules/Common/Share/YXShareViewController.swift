//
//  YXShareViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

enum YXShareImageType: Int {
    /// 学习结果分享
    case learnResult = 1
    /// 智能复习分享
    case aiReviewReuslt = 3
    /// 复习计划分享
    case planReviewResult = 2
    /// 听写复习分享
    case listenReviewResult = 4
    /// 挑战结果分享
    case challengeResult = 5
}

class YXShareViewController: YXViewController {

    var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    var shareImageBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        return imageView
    }()

    var shareTypeBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
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
    
    var shareChannelView: YXShareDefaultView = {
        let shareView = YXShareDefaultView(frame: CGRect.zero)
        return shareView
    }()
    
    private var backgroundImageUrls: [String]?
    private var currentBackgroundImageUrl: String?
    private var changeBackgroundImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("换背景", for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(changeBackgroundImage), for: .touchUpInside)
        return button
    }()

    var wordsAmount = 0
    var daysAmount  = 0
    var hideCoin    = true
    var gameModel: YXGameResultModel?
    var shareType: YXShareImageType = .challengeResult
    var backAction: (()->Void)?
    var finishAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if backAction != nil {
            self.customNavigationBar?.leftButtonAction = backAction
        }
        self.bindProperty()
        self.createSubviews()
    }
    
    private func bindProperty() {
        changeBackgroundImage()
        
        // 设置分享数据
        self.shareChannelView.shareType  = .image
        self.shareChannelView.shareImage = self.shareImageView.image
        self.shareChannelView.coinImageView.isHidden = hideCoin
        self.shareChannelView.finishedBlock = { [weak self] (channel: YXShareChannel) in
            guard let self = self else { return }
            self.punch(channel)
        }
    }
    
    private func createSubviews() {
        self.view.addSubview(headerView)
        self.view.addSubview(footerView)

        headerView.addSubview(shareImageBorderView)
        shareImageBorderView.addSubview(shareImageView)
        footerView.addSubview(shareTypeBorderView)

        shareTypeBorderView.addSubview(leftLineView)
        shareTypeBorderView.addSubview(rightLineView)
        shareTypeBorderView.addSubview(descriptionLabel)
        shareTypeBorderView.addSubview(shareChannelView)

        let headerViewH = (screenHeight - kNavHeight - kSafeBottomMargin) * 0.68
        headerView.snp.makeConstraints { (make) in
            make.height.equalTo(headerViewH)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        footerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
        }

        let imageViewSize = CGSize(width: AdaptSize(319), height: AdaptSize(436))
        shareImageBorderView.size = imageViewSize
        shareImageBorderView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(imageViewSize)
        }
        shareImageView.size = imageViewSize
        shareImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        shareTypeBorderView.snp.makeConstraints { (make) in
            make.height.equalTo(AdaptSize(100))
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }

        descriptionLabel.sizeToFit()
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
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
        shareChannelView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(19))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(65))
        }
        shareImageBorderView.layer.setDefaultShadow()
        shareImageView.clipRectCorner(directionList: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadius: AdaptSize(13))
        
        self.customNavigationBar?.addSubview(changeBackgroundImageButton)
        changeBackgroundImageButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
            make.size.equalTo(CGSize(width: 44, height: 20))
        }
    }
    
    // MARK: ==== Request ====
    private func punch(_ channel: YXShareChannel) {
        // 挑战分享不算打卡
        if self.shareType == .challengeResult {
            return
        }
        
        let request = YXShareRequest.punch(type: channel.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXShareModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else { return }
            self.finishAction?()
            
//            if model.state && model.coin > 0 {
//                YXToastView.share.showCoinView(model.coin)
//                self.shareChannelView.coinImageView.isHidden = true
//            }
            
        }) { (error) in
            YXUtils.showHUD(self.view, title: "\(error.message)")
        }
    }
    
    // MARK: ==== Tools ====
    @objc
    private func changeBackgroundImage() {
        if let urls = backgroundImageUrls, urls.count > 0 {
            if let currentUrl = currentBackgroundImageUrl, let index = urls.firstIndex(of: currentUrl), index < urls.count - 1 {
                shareImageView.sd_setImage(with: URL(string: urls[index + 1]))
                currentBackgroundImageUrl = urls[index + 1]
                
            } else {
                shareImageView.sd_setImage(with: URL(string: urls[0]))
                currentBackgroundImageUrl = urls[0]
            }

        } else {
            let request = YXShareRequest.changeBackgroundImage(type: shareType.rawValue)
            YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] response in
                guard let result = response.data, let imageUrls = result.imageUrls else { return }
                self?.backgroundImageUrls = imageUrls
                self?.changeBackgroundImage()
                
            }) { (error) in
                YXUtils.showHUD(self.view, title: "\(error.message)")
            }
        }
    }
    
    /// 创建学习结果打卡页面
    private func createLearnResultShareImage() -> UIImage? {
        
        // ---- 数据准备 ----
        let shareBgImage = UIImage(named: "learnShareBgImage")
        let iconImage    = UIImage(named: "gameShareLogo")
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词背单词"
            label.textColor     = UIColor.black2
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
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
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
        let logoImage    = UIImage(named: "gameShareLogo_blue")
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
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 56, y: 147, width: 181, height: 28))
        amountLabel.drawText(in: CGRect(x: 116, y: 179, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 116 + amountLabel.width, y: 193, width: 161, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建智能复习打卡分享页面
    private func createAIReviewShareImage() -> UIImage? {
        let logoImage    = UIImage(named: "gameShareLogo_orange")
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
            label.text          = "智能计划复习内容\n高效背单词"
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
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 72, y: 152, width: 241, height: 28))
        amountLabel.drawText(in: CGRect(x: 161, y: 184, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 161 + amountLabel.width, y: 198, width: 21, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建复习计划打卡分享页面
    private func createPlanReviewShareImage() -> UIImage? {
        let logoImage    = UIImage(named: "gameShareLogo_purple")
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
            label.text          = "个单词的自动复习"
            label.textColor     = UIColor.hex(0x44107A)
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        let contentImage = UIImage(named: "reviewShareContent")
        let bottomLabel: UILabel = {
            let label = UILabel()
            label.text          = "智能计划复习内容\n高效背单词"
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
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 414))
        logoImage?.draw(in: CGRect(x: 18, y: 18, width: 131, height: 44))
        aboveLabel.drawText(in: CGRect(x: 46, y: 147, width: 181, height: 28))
        amountLabel.drawText(in: CGRect(x: 126, y: 179, width: amountLabel.width, height: 47))
        belowLabel.drawText(in: CGRect(x: 126 + amountLabel.width, y: 193, width: 161, height: 28))
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建挑战打卡分享页面
    private func createChallengeReviewShareImage() -> UIImage? {
        guard let model = self.gameModel else {
            return nil
        }
        let shareBgImage = UIImage(named: "challengeShareBgImage")
        let contentImage = UIImage(named: "reviewShareContent")
        let flagImage    = UIImage(named: "flagImage")
        let rankTitleLabel: UILabel = {
            let label = UILabel()
            label.text          = "排名"
            label.textColor     = UIColor.hex(0xFFD9D9)
            label.font          = UIFont.regularFont(ofSize: 14)
            label.textAlignment = .center
            return label
        }()
        let rankLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(model.ranking)"
            label.textColor     = UIColor.white
            label.font          = UIFont.DINAlternateBold(ofSize: 24)
            label.textAlignment = .center
            return label
        }()
        let questionAmountLabel: UILabel = {
            let label = UILabel()
            let mAttr =
                NSMutableAttributedString(string: "答对\(model.questionNumber)题", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.regularFont(ofSize: 14)])
            mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: 18)], range: NSMakeRange(2, "\(model.questionNumber)".count))
            label.attributedText = mAttr
            label.textAlignment  = .left
            return label
        }()
        let consumeTimeLabel: UILabel = {
            let label   = UILabel()
            let timeStr = String(format: "%0.2f", Float(model.consumeTime)/1000)
            let mAttr   =
                NSMutableAttributedString(string: "用时" + timeStr + "秒", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.regularFont(ofSize: 14)])
            mAttr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.DINAlternateBold(ofSize: 18)], range: NSMakeRange(2, timeStr.count))
            label.attributedText = mAttr
            label.textAlignment  = .left
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
        let treeBranchImage = UIImage(named: "treeBranchImage")
        
        // ---- 内容绘制 ----
        let imageSize = CGSize(width: 375, height: 514)
        UIGraphicsBeginImageContextWithOptions(imageSize, true, UIScreen.main.scale)
        shareBgImage?.draw(in: CGRect(x: 0, y: 0, width: 375, height: 513))
        contentImage?.draw(in: CGRect(x: 0, y: 430, width: 375, height: 84))
        flagImage?.draw(in: CGRect(x: 28, y: 427, width: 75, height: 77))
        rankTitleLabel.drawText(in: CGRect(x: 54, y: 436, width: 29, height: 20))
        rankLabel.drawText(in: CGRect(x: 45, y: 455, width: 47, height: 28))
        questionAmountLabel.drawText(in: CGRect(x: 125, y: 449, width: 66, height: 21))
        consumeTimeLabel.drawText(in: CGRect(x: 125, y: 474, width: 89, height: 21))
        qrcordImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        treeBranchImage?.draw(in: CGRect(x: 265, y: 314, width: 110, height: 123))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
}
