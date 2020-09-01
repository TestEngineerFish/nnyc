//
//  YXShareManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/1.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXShareManager: NSObject {

    var qrCodeImage = UIImage(named: "shareQRCode")

    private var wordsAmount: Int = 0
    private var daysAmount: Int = 0
    private var gameModel: YXGameResultModel?
    private var shareType: YXShareImageType = .learnResult
    private var backgroundImageUrls: [String]?
    private var currentBackgroundImageUrl: String?
    private var currentBackgroundImageIndex = 0

//    override init() {
//        super.init()
//    }

    // MARK: ==== Event ====

    func setData(wordsAmount: Int, daysAmount: Int, type: YXShareImageType) {
        self.wordsAmount = wordsAmount
        self.daysAmount  = daysAmount
        self.shareType   = type
    }

    /// 设置分享图
    /// - Parameter block: 回调
    func setShareImage(complete block:((UIImage?)->Void)?) {
        self.setQRCodeImage { [weak self] in
            guard let self = self else { return }
            self.getShareImageUrlList { [weak self] in
                guard let self = self else { return }
                self.getBackgroundImage(from: self.currentBackgroundImageUrl) { [weak self] image in
                    guard let self = self else { return }
                    DispatchQueue.main.async() { [weak self] in
                        let shareImage = self?.composeImage(background: image)
                        block?(shareImage)
                    }
                }
            }
        }
    }

    /// 更换图片
    func refreshImage(complete block:((UIImage?)->Void)?) {
        guard let urls = backgroundImageUrls, urls.count > 0 else { return }
        self.currentBackgroundImageIndex = (self.currentBackgroundImageIndex + 1) % urls.count
        currentBackgroundImageUrl = urls[self.currentBackgroundImageIndex]
        getBackgroundImage(from: currentBackgroundImageUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let shareImage = self.composeImage(background: image)
                block?(shareImage)
            }
        }
    }

    // MARK: ==== Tools ====

    /// 设置分享二维码
    /// - Parameter block: 完成回调
    private func setQRCodeImage(complete block:(()->Void)?) {
        let request = YXShareRequest.getQRCode
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] (response) in
            guard let self = self, let model = response.data else {
                return
            }
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: model.imageUrlStr), completed: { (image, data, error, result) in
                if let _image = image {
                    self.qrCodeImage = _image
                }
                block?()
            })
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    /// 获取分享图地址列表
    /// - Parameters:
    ///   - shareType: 分享属性
    ///   - block: 回调
    private func getShareImageUrlList(complete block:(()->Void)?) {
        let request = YXShareRequest.changeBackgroundImage(type: self.shareType.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { [weak self] response in
            guard let self = self, let result = response.data, let imageUrls = result.imageUrls, imageUrls.count > 0 else { return }
            self.backgroundImageUrls         = imageUrls
            self.currentBackgroundImageIndex = Int.random(in: 0..<imageUrls.count)
            self.currentBackgroundImageUrl   = self.backgroundImageUrls?[self.currentBackgroundImageIndex]
            block?()
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    /// 获得分享背景图
    /// - Parameters:
    ///   - urlString: 图片地址
    ///   - block: 回调
    private func getBackgroundImage(from urlString: String?, complete block: @escaping ((_ image: UIImage?) -> Void)) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            block(nil)
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                block(nil)
                return
            }

            block(UIImage(data: data))
        }).resume()
    }

    private func composeImage(background image: UIImage?) -> UIImage? {
        var shareImage: UIImage?
        switch self.shareType {
        case .learnResult:
            shareImage = self.createLearnResultShareImage(image)
        case .aiReviewReuslt:
            shareImage = self.createAIReviewShareImage(image)
        case .planReviewResult:
            shareImage = self.createPlanReviewShareImage(image)
        case .listenReviewResult:
            shareImage = self.createListenReviewShareImage(image)
        case .challengeResult:
            shareImage = self.createChallengeReviewShareImage(UIImage(named: "challengeShareBgImage"))
        }
        return shareImage
    }

    // MARK: ==== Draw ====

    /// 创建学习结果打卡页面
    private func createLearnResultShareImage(_ backgroundImage: UIImage?) -> UIImage? {

        let avatarImage = YXUserModel.default.userAvatarImage == nil ? UIImage(named: "challengeAvatar") : YXUserModel.default.userAvatarImage
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
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        lableContainer.layer.render(in: currentContext)
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
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        lableContainer.layer.render(in: currentContext)
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
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        lableContainer.layer.render(in: currentContext)
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
