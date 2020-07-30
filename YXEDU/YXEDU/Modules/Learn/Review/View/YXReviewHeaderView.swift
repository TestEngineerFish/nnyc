//
//  YXReviewHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewHeaderView: YXView {
    var reviewModel = YXReviewPageModel() { didSet {bindData()} }
    var startReviewEvent: (() -> Void)?
    var createReviewPlanEvent: (() -> Void)?
    
    var bgView          = UIView()
    var circlrImageView = UIImageView()
    var contentBgView   = UIView()
    var contentView     = UIView()
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    
    /// 熟悉
    var familiarPointLabel    = pointLabel()
    var familiarLabel         = UILabel()
    var familiarProgressView  = YXReviewProgressView(type: .familiar)
    var familiarProgressLabel = UILabel()
    
    /// 认识
    var iKnowPointLabel    = pointLabel()
    var iKnowLabel         = UILabel()
    var iKnowProgressView  = YXReviewProgressView(type: .iKnow)
    var iKnowProgressLabel = UILabel()
    
    /// 模糊
    var fuzzyPointLabel    = pointLabel()
    var fuzzyLabel         = UILabel()
    var fuzzyProgressView  = YXReviewProgressView(type: .fuzzy)
    var fuzzyProgressLabel = UILabel()
    
    /// 忘记
    var forgetPointLabel    = pointLabel()
    var forgetLabel         = UILabel()
    var forgetProgressView  = YXReviewProgressView(type: .forget)
    var forgetProgressLabel = UILabel()
    
    /// 智能复习
    var reviewButton  = YXButton(.theme)
    var subTitleLabel = UILabel()
    
    var reviewPlanLabel        = UILabel()
    var createReviewPlanButton = UIButton()
    
    var cannotReviewImageView = UIImageView()
    var cannotReviewLabel     = UILabel()
    
    init(frame: CGRect, reviewModel: YXReviewPageModel) {
        super.init(frame: frame)
        self.reviewModel = reviewModel
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(bgView)
        self.addSubview(circlrImageView)
        self.addSubview(reviewPlanLabel)
        if let reviewPlans = reviewModel.reviewPlans, reviewPlans.count > 0 {
            self.addSubview(createReviewPlanButton)
        }
        bgView.addSubview(contentBgView)
        contentBgView.addSubview(contentView)
        contentView.addSubview(reviewButton)

        if reviewModel.learnNum > 0 {
            contentView.addSubview(titleLabel)
            contentView.addSubview(countLabel)
            
            contentView.addSubview(familiarPointLabel)
            contentView.addSubview(familiarLabel)
            contentView.addSubview(familiarProgressView)
            contentView.addSubview(familiarProgressLabel)
            
            contentView.addSubview(iKnowPointLabel)
            contentView.addSubview(iKnowLabel)
            contentView.addSubview(iKnowProgressView)
            contentView.addSubview(iKnowProgressLabel)
            
            contentView.addSubview(fuzzyPointLabel)
            contentView.addSubview(fuzzyLabel)
            contentView.addSubview(fuzzyProgressView)
            contentView.addSubview(fuzzyProgressLabel)
            
            contentView.addSubview(forgetPointLabel)
            contentView.addSubview(forgetLabel)
            contentView.addSubview(forgetProgressView)
            contentView.addSubview(forgetProgressLabel)

            contentView.addSubview(subTitleLabel)
            
        } else {
            contentView.addSubview(cannotReviewImageView)
            contentView.addSubview(cannotReviewLabel)
        }
    }
    
    
    override func bindProperty() {
        circlrImageView.image = UIImage(named: "review_circle_icon")
        
        bgView.backgroundColor     = UIColor.orange1
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius  = AS(20)

        contentView.backgroundColor     = UIColor.white
        contentView.layer.cornerRadius  = AS(15)
        contentView.layer.shadowColor   = UIColor.hex(0xE09779).cgColor
        contentView.layer.shadowOffset  = CGSize.zero
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius  = 10
        contentView.layer.masksToBounds = false

        contentBgView.backgroundColor     = UIColor.white
        contentBgView.layer.masksToBounds = true
        contentBgView.layer.cornerRadius  = AdaptSize(15)

        titleLabel.font          = UIFont.pfSCRegularFont(withSize: AdaptFontSize(14))
        titleLabel.text          = "背过的单词"
        titleLabel.textColor     = UIColor.black2
        titleLabel.textAlignment = .center
        
        countLabel.font          = UIFont.DINAlternateBold(ofSize: AdaptFontSize(35))
        countLabel.text          = "--"
        countLabel.textColor     = UIColor.black1
        countLabel.textAlignment = .center
                
        familiarLabel.font                 = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        familiarLabel.textColor            = UIColor.black1
        familiarLabel.text                 = "熟悉的单词"
        familiarProgressLabel.font         = UIFont.pfSCRegularFont(withSize: AdaptFontSize(10))
        familiarProgressLabel.textColor    = UIColor.orange5
        familiarProgressLabel.text         = "--"
        familiarPointLabel.backgroundColor = UIColor.orange5
                                
        iKnowLabel.font                 = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        iKnowLabel.textColor            = UIColor.black1
        iKnowLabel.text                 = "认识的单词"
        iKnowProgressLabel.font         = UIFont.pfSCRegularFont(withSize: AdaptFontSize(10))
        iKnowProgressLabel.textColor    = UIColor.orange1
        iKnowProgressLabel.text         = "--"
        iKnowPointLabel.backgroundColor = UIColor.orange1
        
        fuzzyLabel.font                 = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        fuzzyLabel.textColor            = UIColor.black1
        fuzzyLabel.text                 = "模糊的单词"
        fuzzyProgressLabel.font         = UIFont.pfSCRegularFont(withSize: AdaptFontSize(10))
        fuzzyProgressLabel.textColor    = UIColor.green2
        fuzzyProgressLabel.text         = "--"
        fuzzyPointLabel.backgroundColor = UIColor.green2
        
        forgetLabel.font                 = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        forgetLabel.textColor            = UIColor.black1
        forgetLabel.text                 = "忘记的单词"
        forgetProgressLabel.font         = UIFont.pfSCRegularFont(withSize: AdaptFontSize(10))
        forgetProgressLabel.textColor    = UIColor.blue1
        forgetProgressLabel.text         = "--"
        forgetPointLabel.backgroundColor = UIColor.blue1
        
        reviewButton.setTitle("智能复习", for: .normal)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AdaptFontSize(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        
        if reviewModel.learnNum == 0 {
            reviewButton.alpha     = 0.3
            reviewButton.isEnabled = false
            reviewButton.setTitle("学习后开启智能复习", for: .normal)
        }
                
        subTitleLabel.textColor = UIColor.black6
        subTitleLabel.text      = "智能计划复习内容巩固薄弱单词"
        subTitleLabel.font      = UIFont.pfSCRegularFont(withSize: AdaptFontSize(12))
        
        reviewPlanLabel.font      = UIFont.mediumFont(ofSize: AdaptFontSize(15))
        reviewPlanLabel.textColor = UIColor.black1
        reviewPlanLabel.text      = "词单"
        
        createReviewPlanButton.layer.cornerRadius = AS(isPad() ? 35 : 25)/2
        createReviewPlanButton.setImage(UIImage(named: "review_add_icon"), for: .normal)
        createReviewPlanButton.setTitle("新建词单", for: .normal)
        createReviewPlanButton.setTitleColor(UIColor.hex(0x323232), for: .normal)
        createReviewPlanButton.titleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(12))
        if isPad() {
            createReviewPlanButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 11)
        }
        createReviewPlanButton.layer.borderWidth = 0.5
        createReviewPlanButton.layer.borderColor = UIColor.black4.cgColor
        createReviewPlanButton.addTarget(self, action: #selector(clickCreateReviewPlanButton), for: .touchUpInside)
        
        cannotReviewImageView.image       = UIImage(named: "cannotReview")
        cannotReviewImageView.contentMode = .scaleAspectFit
        
        cannotReviewLabel.text      = "直击薄弱 稳固提分"
        cannotReviewLabel.textColor = UIColor.black3
        cannotReviewLabel.font      = UIFont.pfSCRegularFont(withSize: AdaptFontSize(14))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bgHeight = isPad() ? AdaptSize(541) : AdaptSize(339)
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(isPad() ? 36 : 21) + kStatusBarHeight)
            make.left.equalTo(AS(isPad() ? 34 : 22))
            make.right.equalTo(AS(isPad() ? -34 : -22))
            make.height.equalTo(bgHeight)
        }
        
        circlrImageView.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(AdaptIconSize(8))
            make.left.equalTo(AS(isPad() ? 18 : 11))
            make.width.equalTo(AdaptIconSize(42))
            make.height.equalTo(AdaptIconSize(29))
        }

        contentBgView.snp.makeConstraints { (make) in
            make.top.equalTo(AdaptIconSize(9))
            make.left.equalTo(AdaptIconSize(8))
            make.right.equalTo(AdaptIconSize(-8))
            make.bottom.equalTo(AdaptIconSize(-10))
        }

        contentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-6))
        }
        
        reviewButton.snp.makeConstraints { (make) in
            if reviewModel.learnNum > 0 {
                make.bottom.equalToSuperview().offset(AdaptSize(isPad() ? -58 : -44))
            } else {
                make.bottom.equalToSuperview().offset(AdaptSize(isPad() ? -48 : -34))
            }
            
            make.centerX.equalToSuperview()
            if isPad() {
                make.width.equalTo(AdaptSize(525))
                make.height.equalTo(AdaptSize(AdaptSize(73)))
            } else {
                make.width.equalTo(AdaptSize(226))
                make.height.equalTo(AdaptSize(AdaptSize(42)))
            }
        }
        
        if reviewModel.learnNum > 0 {
            titleLabel.sizeToFit()
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(AS(isPad() ? 36 : 23))
                make.centerX.equalToSuperview()
                make.size.equalTo(titleLabel.size)
            }
            countLabel.sizeToFit()
            countLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(isPad() ? 6 : 0))
                make.centerX.equalToSuperview()
                make.size.equalTo(countLabel.size)
            }
            
            familiarPointLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(familiarLabel)
                make.right.equalTo(familiarLabel.snp.left).offset(AdaptSize(-4))
                make.left.equalToSuperview().offset(AdaptSize(isPad() ? 48 : 17))
                make.width.height.equalTo(AdaptFontSize(5))
            }
            familiarLabel.sizeToFit()
            familiarLabel.snp.makeConstraints { (make) in
                make.top.equalTo(AS(isPad() ? 191 : 100))
                make.left.equalTo(familiarPointLabel.snp.right).offset(AdaptSize(4))
                make.size.equalTo(familiarLabel.size)
            }
            familiarProgressView.snp.makeConstraints { (make) in
                make.top.equalTo(familiarLabel.snp.bottom).offset(AS(4))
                make.left.equalTo(familiarLabel)
                make.size.equalTo(CGSize(width: AdaptSize(isPad() ? 168 : 120), height: AdaptIconSize(10)))
            }

            familiarProgressLabel.sizeToFit()
            familiarProgressLabel.snp.makeConstraints { (make) in
                if isPad() {
                    make.centerY.equalTo(familiarProgressView)
                    make.left.equalTo(familiarProgressView.snp.right).offset(AdaptSize(11))
                } else {
                    make.top.equalTo(familiarProgressView.snp.bottom).offset(AS(3))
                    make.left.equalTo(familiarProgressView)
                }
                make.size.equalTo(familiarProgressLabel.size)
            }

            iKnowPointLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(iKnowLabel)
                make.left.equalTo(contentView.snp.centerX).offset(AdaptSize(isPad() ? 48 : 17))
                make.width.height.equalTo(AdaptFontSize(5))
            }
            iKnowLabel.sizeToFit()
            iKnowLabel.snp.makeConstraints { (make) in
                make.top.equalTo(familiarLabel)
                make.left.equalTo(iKnowPointLabel.snp.right).offset(AdaptSize(4))
                make.size.equalTo(iKnowLabel.size)
            }
            iKnowProgressView.snp.makeConstraints { (make) in
                make.top.equalTo(iKnowLabel.snp.bottom).offset(AS(4))
                make.left.equalTo(iKnowLabel)
                make.size.equalTo(familiarProgressView)
            }
            iKnowProgressLabel.sizeToFit()
            iKnowProgressLabel.snp.makeConstraints { (make) in
                if isPad() {
                    make.centerY.equalTo(iKnowProgressView)
                    make.left.equalTo(iKnowProgressView.snp.right).offset(AdaptSize(11))
                } else {
                    make.top.equalTo(iKnowProgressView.snp.bottom).offset(AS(3))
                    make.left.equalTo(iKnowProgressView)
                }
                make.size.equalTo(iKnowProgressLabel.size)
            }

            fuzzyPointLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(fuzzyLabel)
                make.left.equalTo(familiarPointLabel)
                make.width.height.equalTo(AdaptFontSize(5))
            }
            fuzzyLabel.sizeToFit()
            fuzzyLabel.snp.makeConstraints { (make) in
                make.top.equalTo(familiarProgressView.snp.bottom).offset(AdaptSize(isPad() ? 37 : 34))
                make.left.equalTo(familiarLabel)
                make.size.equalTo(fuzzyLabel.size)
            }
            fuzzyProgressView.snp.makeConstraints { (make) in
                make.top.equalTo(fuzzyLabel.snp.bottom).offset(AS(4))
                make.left.equalTo(fuzzyLabel)
                make.size.equalTo(familiarProgressView)
            }
            fuzzyProgressLabel.sizeToFit()
            fuzzyProgressLabel.snp.makeConstraints { (make) in
                if isPad() {
                    make.centerY.equalTo(fuzzyProgressView)
                    make.left.equalTo(fuzzyProgressView.snp.right).offset(AdaptSize(11))
                } else {
                    make.top.equalTo(fuzzyProgressView.snp.bottom).offset(AS(3))
                    make.left.equalTo(fuzzyProgressView)
                }
                make.size.equalTo(fuzzyProgressLabel.size)
            }
            
            forgetPointLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(forgetLabel)
                make.left.equalTo(iKnowPointLabel)
                make.width.height.equalTo(AdaptFontSize(5))
            }
            forgetLabel.sizeToFit()
            forgetLabel.snp.makeConstraints { (make) in
                make.top.equalTo(fuzzyLabel)
                make.left.equalTo(iKnowLabel)
                make.size.equalTo(forgetLabel.size)
            }
            forgetProgressView.snp.makeConstraints { (make) in
                make.top.equalTo(forgetLabel.snp.bottom).offset(AS(4))
                make.left.equalTo(forgetLabel)
                make.size.equalTo(familiarProgressView)
            }
            forgetProgressLabel.sizeToFit()
            forgetProgressLabel.snp.makeConstraints { (make) in
                if isPad() {
                    make.centerY.equalTo(forgetProgressView)
                    make.left.equalTo(forgetProgressView.snp.right).offset(AdaptSize(11))
                } else {
                    make.top.equalTo(forgetProgressView.snp.bottom).offset(AS(3))
                    make.left.equalTo(forgetProgressView)
                }
                make.size.equalTo(forgetProgressLabel.size)
            }

            subTitleLabel.sizeToFit()
            subTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(reviewButton.snp.bottom).offset(AS(isPad() ? 16 : 8))
                make.centerX.equalToSuperview()
                make.size.equalTo(subTitleLabel.size)
            }
            
        } else {
            cannotReviewImageView.snp.makeConstraints { (make) in
                make.top.left.right.equalToSuperview().inset(20)
                make.bottom.equalTo(reviewButton.snp.top).offset(-44)
            }
            
            cannotReviewLabel.snp.makeConstraints { (make) in
                make.top.equalTo(cannotReviewImageView.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
        }

        reviewPlanLabel.sizeToFit()
        reviewPlanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(AS(isPad() ? 28 : 17))
            make.left.equalTo(bgView)
            make.size.equalTo(reviewPlanLabel.size)
        }
        
        if let reviewPlans = reviewModel.reviewPlans, reviewPlans.count > 0 {
            createReviewPlanButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(reviewPlanLabel)
                make.right.equalTo(bgView)
                if isPad() {
                    make.size.equalTo(CGSize(width: AS(126), height: AS(35)))
                } else {
                    make.size.equalTo(CGSize(width: AS(90), height: AS(25)))
                }
            }
        }
        
        super.layoutIfNeeded()
    }

    override func bindData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.familiarProgressView.progress = self.progressValue(num: self.reviewModel.familiarNum)
            self.iKnowProgressView.progress    = self.progressValue(num: self.reviewModel.knowNum)
            self.fuzzyProgressView.progress    = self.progressValue(num: self.reviewModel.fuzzyNum)
            self.forgetProgressView.progress   = self.progressValue(num: self.reviewModel.forgetNum)
        }
        
        countLabel.text    = "\(reviewModel.learnNum)"
        familiarLabel.text = "熟悉的单词  \(reviewModel.familiarNum)个"
        iKnowLabel.text    = "认识的单词  \(reviewModel.knowNum)个"
        fuzzyLabel.text    = "模糊的单词  \(reviewModel.fuzzyNum)个"
        forgetLabel.text   = "忘记的单词  \(reviewModel.forgetNum)个"
        
        familiarProgressLabel.text = progressStringValue(num: reviewModel.familiarNum)
        iKnowProgressLabel.text    = progressStringValue(num: reviewModel.knowNum)
        fuzzyProgressLabel.text    = progressStringValue(num: reviewModel.fuzzyNum)
        forgetProgressLabel.text   = progressStringValue(num: reviewModel.forgetNum)
    }
    
    private func progressStringValue(num: Int?) -> String {
        return "\(Int(progressValue(num: num) *  100))%"
    }
    
    private func progressValue(num: Int?) -> CGFloat {
        guard let n = num, self.reviewModel.learnNum > 0 else {
            return 0
        }
        return CGFloat(n) / CGFloat(self.reviewModel.learnNum)
    }
    
    private class func pointLabel() -> UILabel {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = AdaptIconSize(5)/2
        return label
    }
    
    @objc private func clickReviewButton() {
        guard reviewButton.isEnabled else { return }
        self.startReviewEvent?()
    }
    
    @objc private func clickCreateReviewPlanButton() {        
        self.createReviewPlanEvent?()
    }
}



class YXReviewProgressView: YXView {
    
    enum YXReviewProgressViewType {
        case familiar
        case iKnow
        case fuzzy
        case forget
    }
    
    public var progress: CGFloat = 0 {
        didSet { self.bindData() }
    }
    var showAnimation = true
    private var type: YXReviewProgressViewType = .familiar
    private var progressView = UIView()
    private var cornerRadius: CGFloat = AdaptIconSize(5)
    
    init(type: YXReviewProgressViewType, cornerRadius: CGFloat = AdaptIconSize(5)) {
        super.init(frame: CGRect.zero)
        self.type = type
        self.cornerRadius = cornerRadius
        
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(progressView)
    }
    
    override func bindProperty() {
        self.backgroundColor     = UIColor.gray2
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = cornerRadius
        
        self.progressView.layer.masksToBounds = true
        self.progressView.layer.cornerRadius  = cornerRadius
        self.progressView.backgroundColor     = self.color()
    }
    
    override func layoutSubviews() {
        
        
    }
    
    override func bindData() {
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.height)
        if showAnimation {
            UIView.animate(withDuration: 0.6) {[weak self] in
                guard let self = self else { return }
                self.progressView.width = self.progress * self.width
            }
        } else {
            self.progressView.width = self.progress * self.width
        }
    }
        
    private func color() -> UIColor? {
        var color: UIColor?
        
        switch type {
        case .familiar:
            color = UIColor.orange5
        case .iKnow:
            color = UIColor.orange1
        case .fuzzy:
            color = UIColor.green2
        case .forget:
            color = UIColor.blue1
        }
        
        return color
    }

}
