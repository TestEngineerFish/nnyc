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
    case learnResult        = 1
    /// 复习计划分享
    case planReviewResult   = 2
    /// 智能复习分享
    case aiReviewReuslt     = 3
    /// 听写复习分享
    case listenReviewResult = 4
    /// 挑战结果分享
    case challengeResult    = 5
    /// 课外作业
    case homeworkResult     = 6
}

class YXShareViewController: YXViewController {

    var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(kIconFont_back, for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconfont(size: AdaptSize(16))
        return button
    }()

    var changeBackgroundImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("换背景", for: .normal)
        button.setTitleColor(UIColor.gray1, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: AdaptFontSize(14))
        return button
    }()

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
        label.font          = UIFont.regularFont(ofSize: AdaptFontSize(12))
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

//    let qrCodeImage: UIImage? = {
//        if let image = SGQRCodeObtain.generateQRCode(withData: "https://apps.apple.com/cn/app/id1379948642", size: 65, logoImage: UIImage(named: "gameShareLogo"), ratio: 0.25, logoImageCornerRadius: 0, logoImageBorderWidth: 0, logoImageBorderColor: .clear) {
//            return image
//        } else {
//            return UIImage(named: "shareQRCode")
//        }
//    }()
    let qrCodeImage = UIImage(named: "shareQRCode")
    
    private var backgroundImageUrls: [String]?
    private var currentBackgroundImageUrl: String?
    private var currentBackgroundImageIndex = 0

    var wordsAmount = 0
    var daysAmount  = 0
    var wordId: Int = 0
    var hideCoin    = true
    var gameModel: YXGameResultModel?
    var shareType: YXShareImageType = .challengeResult
    var backAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.getBackgroundImageList()
        self.bindProperty()
        self.createSubviews()
    }
    
    private func bindProperty() {
        self.backButton.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        self.changeBackgroundImageButton.addTarget(self, action: #selector(changeBackgroundImage), for: .touchUpInside)
        self.changeBackgroundImageButton.isHidden    = (shareType == .challengeResult)
        // 设置分享数据
        self.shareChannelView.shareType              = .image
        self.shareChannelView.coinImageView.isHidden = hideCoin
        self.shareChannelView.finishedBlock = { [weak self] (channel: YXShareChannel) in
            guard let self = self else { return }
            // 挑战分享不算打卡
            if self.shareType != .challengeResult {
                self.punch(channel, word: self.wordId)
            }
        }
    }
    
    private func createSubviews() {
        self.view.addSubview(backButton)
        self.view.addSubview(changeBackgroundImageButton)
        self.view.addSubview(headerView)
        self.view.addSubview(footerView)

        headerView.addSubview(shareImageBorderView)
        shareImageBorderView.addSubview(shareImageView)
        footerView.addSubview(shareTypeBorderView)

        shareTypeBorderView.addSubview(leftLineView)
        shareTypeBorderView.addSubview(rightLineView)
        shareTypeBorderView.addSubview(descriptionLabel)
        shareTypeBorderView.addSubview(shareChannelView)

        backButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kStatusBarHeight + AdaptIconSize(13))
            make.width.height.equalTo(AdaptSize(22))
            make.left.equalToSuperview().offset(AdaptSize(14))
        }
        changeBackgroundImageButton.sizeToFit()
        changeBackgroundImageButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(changeBackgroundImageButton.size)
        }
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

        let imageViewSize = CGSize(width: AdaptIconSize(319), height: AdaptIconSize(436))
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
            make.size.equalTo(CGSize(width: AdaptIconSize(83), height: AdaptSize(1)))
        }
        rightLineView.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel.snp.right).offset(AdaptSize(19))
            make.centerY.equalTo(descriptionLabel)
            make.size.equalTo(CGSize(width: AdaptIconSize(83), height: AdaptSize(1)))
        }
        shareChannelView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(19))
            make.width.equalToSuperview()
            make.height.equalTo(AdaptIconSize(65))
        }
        shareImageBorderView.layer.setDefaultShadow(cornerRadius: AdaptSize(13), shadowRadius: AdaptSize(13))
        shareImageView.clipRectCorner(directionList: [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadius: AdaptSize(13))
    }
    
    // MARK: ==== Request ====

    private func getBackgroundImageList() {
        let request = YXShareRequest.changeBackgroundImage(type: shareType.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] response in
            guard let self = self, let result = response.data, let imageUrls = result.imageUrls, imageUrls.count > 0 else { return }
            self.backgroundImageUrls         = imageUrls
            self.currentBackgroundImageIndex = Int.random(in: 0..<imageUrls.count)
            self.currentBackgroundImageUrl   = self.backgroundImageUrls?[self.currentBackgroundImageIndex]
            self.getBackgroundImage(from: self.currentBackgroundImageUrl) { backgroundImage in

                DispatchQueue.main.async() {
                    switch self.shareType {
                    case .learnResult, .homeworkResult:
                        self.shareImageView.image = self.createLearnResultShareImage(backgroundImage)
                    case .aiReviewReuslt:
                        self.shareImageView.image = self.createAIReviewShareImage(backgroundImage)
                    case .planReviewResult:
                        self.shareImageView.image = self.createPlanReviewShareImage(backgroundImage)
                    case .listenReviewResult:
                        self.shareImageView.image = self.createListenReviewShareImage(backgroundImage)
                    case .challengeResult:
                        self.shareImageView.image = self.createChallengeReviewShareImage(UIImage(named: "challengeShareBgImage"))
                    }
                    self.shareChannelView.shareImage = self.shareImageView.image
                }
            }

        }) { (error) in
            YXUtils.showHUD(self.view, title: error.message)
        }
    }

    private func punch(_ channel: YXShareChannel, word id: Int) {

        let request = YXShareRequest.punch(type: channel.rawValue, wordId: id)
        YYNetworkService.default.request(YYStructResponse<YXShareModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else { return }
            var isFinished = false
            if model.state {
                if let count = YYCache.object(forKey: YXLocalKey.punchCount) as? Int {
                    YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： \(count + 1)")
                    YYCache.set(count + 1, forKey: YXLocalKey.punchCount)
                    
                } else {
                    YXLog("用户 \(YXUserModel.default.uuid ?? "") 打卡次数： 1")
                    YYCache.set(1, forKey: YXLocalKey.punchCount)
                }
                
                if channel == .timeLine {
                    self.shareChannelView.coinImageView.isHidden = true
                    isFinished = true
                }
                
                self.navigationController?.popViewController(animated: true)
                
            } else {
                YXLog("打卡分享失败")
            }
            NotificationCenter.default.post(name: YXNotification.kShareResult, object: nil, userInfo: ["isFinished":isFinished])
            
        }) { (error) in
            YXUtils.showHUD(self.view, title: error.message)
        }
    }

    // MARK: ==== Event ====
    @objc private func clickBackBtn(_ button: UIButton) {
        if self.backAction != nil {
            self.backAction?()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        button.isEnabled = false
    }
    
    // MARK: ==== Tools ====
    @objc
    private func changeBackgroundImage() {
        guard let urls = backgroundImageUrls, urls.count > 0 else { return }
        self.currentBackgroundImageIndex = (self.currentBackgroundImageIndex + 1) % urls.count
        currentBackgroundImageUrl = urls[self.currentBackgroundImageIndex]
        getBackgroundImage(from: currentBackgroundImageUrl) { backgroundImage in
            DispatchQueue.main.async() {
                switch self.shareType {
                case .learnResult, .homeworkResult:
                    self.shareImageView.image = self.createLearnResultShareImage(backgroundImage)
                case .aiReviewReuslt:
                    self.shareImageView.image = self.createAIReviewShareImage(backgroundImage)
                case .planReviewResult:
                    self.shareImageView.image = self.createPlanReviewShareImage(backgroundImage)
                case .listenReviewResult:
                    self.shareImageView.image = self.createListenReviewShareImage(backgroundImage)
                case .challengeResult:
                    self.shareImageView.image = self.createChallengeReviewShareImage(backgroundImage)
                }
                self.shareChannelView.shareImage = self.shareImageView.image
            }
        }
    }
    
    private func getBackgroundImage(from urlString: String?, completeClosure: @escaping ((_ image: UIImage?) -> Void)) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completeClosure(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                completeClosure(nil)
                return
            }
            
            completeClosure(UIImage(data: data))
        }).resume()
    }
    
    /// 创建学习结果打卡页面
    private func createLearnResultShareImage(_ backgroundImage: UIImage?) -> UIImage? {

        let avatarImage = YXUserModel.default.userAvatarImage == nil ? UIImage(named: "userPlaceHolder") : YXUserModel.default.userAvatarImage
        let shareImageView = YXShareImageView(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 518)))
        shareImageView.backgroundImageView.image = backgroundImage
        shareImageView.avatarImageView.image     = avatarImage
        shareImageView.nameLabel.text            = YXUserModel.default.userName
        shareImageView.qrCodeImageView.image     = self.qrCodeImage
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        dateFormatter.locale     = Locale(identifier: "en")
        
        shareImageView.dateLabel.text      = dateFormatter.string(from: Date())
        shareImageView.wordCountLabel.text = "\(self.wordsAmount)"
        shareImageView.dayCountLabel.text  = "\(self.daysAmount)"
                
        let renderer = UIGraphicsImageRenderer(size: shareImageView.bounds.size)
        let image = renderer.image { context in
            shareImageView.drawHierarchy(in: shareImageView.bounds, afterScreenUpdates: true)
        }
                
        return image
    }
    
    /// 创建听写复习打卡分享页面
    private func createListenReviewShareImage(_ backgroundImage: UIImage?) -> UIImage? {
        let lableContainer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 514))
        lableContainer.backgroundColor = .clear

        let logoImage    = UIImage(named: "gameShareLogo_blue")
        let shareBgImage = backgroundImage
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词完成了"
            label.textColor     = .white
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        aboveLabel.frame = CGRect(x: 56, y: 147, width: 181, height: 28)
        aboveLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        aboveLabel.layer.shadowRadius  = 2.0
        aboveLabel.layer.shadowOpacity = 1.0
        aboveLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(aboveLabel.layer)
        
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = .white
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        amountLabel.frame = CGRect(x: 116, y: 179, width: amountLabel.width, height: 47)
        amountLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        amountLabel.layer.shadowRadius  = 2.0
        amountLabel.layer.shadowOpacity = 1.0
        amountLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(amountLabel.layer)
        
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个单词的听写练习"
            label.textColor     = .white
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        belowLabel.frame = CGRect(x: 116 + amountLabel.width, y: 193, width: 161, height: 28)
        belowLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        belowLabel.layer.shadowRadius  = 2.0
        belowLabel.layer.shadowOpacity = 1.0
        belowLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(belowLabel.layer)
        
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
        lableContainer.layer.render(in: UIGraphicsGetCurrentContext()!)
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrCodeImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建智能复习打卡分享页面
    private func createAIReviewShareImage(_ backgroundImage: UIImage?) -> UIImage? {
        let lableContainer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 514))
        lableContainer.backgroundColor = .clear
        
        let logoImage    = UIImage(named: "gameShareLogo_orange")
        let shareBgImage = backgroundImage
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "智能复习帮我自动巩固单词"
            label.textColor     = .white
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        aboveLabel.frame = CGRect(x: 72, y: 148, width: 241, height: 28)
        aboveLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        aboveLabel.layer.shadowRadius  = 2.0
        aboveLabel.layer.shadowOpacity = 1.0
        aboveLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(aboveLabel.layer)
        
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = .white
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        amountLabel.frame = CGRect(x: 161, y: 181, width: amountLabel.width, height: 47)
        amountLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        amountLabel.layer.shadowRadius  = 2.0
        amountLabel.layer.shadowOpacity = 1.0
        amountLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(amountLabel.layer)
        
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个"
            label.textColor     = .white
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        belowLabel.frame = CGRect(x: 161 + amountLabel.width, y: 196, width: 21, height: 28)
        belowLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        belowLabel.layer.shadowRadius  = 2.0
        belowLabel.layer.shadowOpacity = 1.0
        belowLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(belowLabel.layer)
        
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
        lableContainer.layer.render(in: UIGraphicsGetCurrentContext()!)
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrCodeImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建复习计划打卡分享页面
    private func createPlanReviewShareImage(_ backgroundImage: UIImage?) -> UIImage? {
        let lableContainer = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 514))
        lableContainer.backgroundColor = .clear
        
        let logoImage    = UIImage(named: "gameShareLogo_purple")
        let shareBgImage = backgroundImage
        let aboveLabel: UILabel = {
            let label = UILabel()
            label.text          = "我在念念有词完成了"
            label.textColor     = .white
            label.font          = UIFont.mediumFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        aboveLabel.frame = CGRect(x: 60, y: 147, width: 181, height: 28)
        aboveLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.5).cgColor
        aboveLabel.layer.shadowRadius = 2.0
        aboveLabel.layer.shadowOpacity = 1.0
        aboveLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(aboveLabel.layer)
        
        let amountLabel: UILabel = {
            let label = UILabel()
            label.text          = "\(wordsAmount)"
            label.textColor     = .white
            label.font          = UIFont.DINAlternateBold(ofSize: 40)
            label.textAlignment = .center
            label.sizeToFit()
            return label
        }()
        amountLabel.frame = CGRect(x: 126, y: 179, width: amountLabel.width, height: 47)
        amountLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        amountLabel.layer.shadowRadius  = 2.0
        amountLabel.layer.shadowOpacity = 1.0
        amountLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(amountLabel.layer)
        
        let belowLabel: UILabel = {
            let label = UILabel()
            label.text          = "个单词的自动复习"
            label.textColor     = .white
            label.font          = UIFont.regularFont(ofSize: 20)
            label.textAlignment = .center
            return label
        }()
        belowLabel.frame = CGRect(x: 126 + amountLabel.width, y: 193, width: 161, height: 28)
        belowLabel.layer.shadowColor   = UIColor.black.withAlphaComponent(0.5).cgColor
        belowLabel.layer.shadowRadius  = 2.0
        belowLabel.layer.shadowOpacity = 1.0
        belowLabel.layer.shadowOffset  = CGSize(width: 2, height: 2)
        lableContainer.layer.addSublayer(belowLabel.layer)
        
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
        lableContainer.layer.render(in: UIGraphicsGetCurrentContext()!)
        contentImage?.draw(in: CGRect(x: 0, y: 413, width: 375, height: 101))
        bottomLabel.drawText(in: CGRect(x: 29, y: 443, width: 147, height: 42))
        qrCodeImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
    
    /// 创建挑战打卡分享页面
    private func createChallengeReviewShareImage(_ backgroundImage: UIImage?) -> UIImage? {
        guard let model = self.gameModel else {
            return nil
        }
        let shareBgImage = backgroundImage
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
        qrCodeImage?.draw(in: CGRect(x: 287, y: 423, width: 65, height: 65))
        qrcordLabel.drawText(in: CGRect(x: 275, y: 490, width: 90, height: 14))
        treeBranchImage?.draw(in: CGRect(x: 265, y: 314, width: 110, height: 123))
        guard let shareImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        return shareImage
    }
}
