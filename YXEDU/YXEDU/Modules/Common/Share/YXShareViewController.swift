//
//  YXShareViewController.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/21.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit
import Alamofire

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
    var loadingView = UIActivityIndicatorView(style: .gray)
    var qrCodeImage = UIImage(named: "shareQRCode")
    var bookId: Int = 0
    var learnType: YXLearnType?
    private var backgroundImageUrls: [String]?
    private var currentBackgroundImageUrl: String?
    private var currentBackgroundImageIndex = 0
    private var shareManager = YXShareManager()

    var wordsAmount = 0
    var daysAmount  = 0
    var hideCoin    = true
    var gameModel: YXGameResultModel?
    var shareType: YXShareImageType = .challengeResult
    var backAction: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.bindProperty()
        self.createSubviews()
    }
    
    private func bindProperty() {
        self.shareManager.gameModel = self.gameModel
        self.shareManager.setData(wordsAmount: self.wordsAmount, daysAmount: self.daysAmount, type: self.shareType)
        self.shareManager.setShareImage { [weak self] (image:UIImage?) in
            guard let self = self else { return }
            self.shareImageView.image        = image
            self.shareChannelView.shareImage = image
        }
        self.backButton.addTarget(self, action: #selector(clickBackBtn), for: .touchUpInside)
        self.changeBackgroundImageButton.addTarget(self, action: #selector(changeBackgroundImage), for: .touchUpInside)
        self.changeBackgroundImageButton.isHidden    = (shareType == .challengeResult)
        // 设置分享数据
        self.shareChannelView.shareType              = .image
        self.shareChannelView.coinImageView.isHidden = hideCoin
        self.shareChannelView.finishedBlock = { [weak self] (channel: YXShareChannel) in
            guard let self = self, let learnType = self.learnType else { return }
            self.requestShare(shareType: channel, learnType: learnType)
            // 上报GIO
            let shareImageName = self.shareManager.currentBackgroundImageModel?.name ?? ""
            YXGrowingManager.share.shareType(imageName: shareImageName, channel: channel)
//            // 挑战分享不算打卡
//            if self.shareType != .challengeResult {
//                self.punch(channel)
//            }
        }
    }
    
    private func createSubviews() {
        self.view.addSubview(backButton)
        self.view.addSubview(changeBackgroundImageButton)
        self.view.addSubview(headerView)
        self.view.addSubview(footerView)

        headerView.addSubview(shareImageBorderView)
        shareImageBorderView.addSubview(shareImageView)
        shareImageView.addSubview(loadingView)
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
        let imageViewW = AdaptIconSize(319) * headerViewH/AdaptIconSize(436)
        let imageViewSize = CGSize(width: imageViewW, height: headerViewH)
        shareImageBorderView.size = imageViewSize
        shareImageBorderView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(imageViewSize)
        }
        shareImageView.size = imageViewSize
        shareImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loadingView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptIconSize(45), height: AdaptIconSize(45)))
            make.center.equalToSuperview()
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

    private func requestShare(shareType: YXShareChannel, learnType: YXLearnType) {
        let request = YXExerciseRequest.learnShare(shareType: shareType.rawValue, learnType: learnType.rawValue)
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            var isFinished = false
            if shareType == .timeLine {
                self.shareChannelView.coinImageView.isHidden = true
                isFinished = true
            }
            NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
            NotificationCenter.default.post(name: YXNotification.kShareResult, object: nil, userInfo: ["isFinished":isFinished])
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
        }
    }

    private func punch(_ channel: YXShareChannel) {
        let request = YXShareRequest.punch(type: channel.rawValue, bookId: self.bookId, learnType: self.learnType?.rawValue ?? 0)
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
            NotificationCenter.default.post(name: YXNotification.kReloadClassList, object: nil)
            NotificationCenter.default.post(name: YXNotification.kShareResult, object: nil, userInfo: ["isFinished":isFinished])
            
        }) { (error) in
            YXUtils.showHUD(nil, title: error.message)
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
    /// 更换背景图
    @objc
    private func changeBackgroundImage() {
        self.loadingView.startAnimating()
        self.shareManager.refreshImage { [weak self] (image: UIImage?) in
            guard let self = self else { return }
            self.loadingView.stopAnimating()
            self.shareChannelView.shareImage  = image
            self.shareImageView.image         = image
            self.shareImageView.layer.opacity = 1.0
        }
        
    }
}
