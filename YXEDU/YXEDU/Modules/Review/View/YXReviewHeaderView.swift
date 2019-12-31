//
//  YXReviewHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewHeaderView: YXView {
    var startReviewEvent: (() -> Void)?
    var createReviewPlanEvent: (() -> Void)?
    var favoriteEvent: (() -> Void)?
    var wrongWordEvent: (() -> Void)?
    var reviewModel: YXReviewPageModel? { didSet {bindData()} }
    
    var bgView = UIView()
    var contentView = UIView()
    
    var imageView = UIImageView()
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    
    /// 熟悉
    var familiarPointLabel = pointLabel()
    var familiarLabel = UILabel()
    var familiarProgressView = YXReviewProgressView(type: .familiar)
    var familiarProgressLabel = UILabel()
    
    /// 认识
    var iKnowPointLabel = pointLabel()
    var iKnowLabel = UILabel()
    var iKnowProgressView = YXReviewProgressView(type: .iKnow)
    var iKnowProgressLabel = UILabel()
    
    /// 模糊
    var fuzzyPointLabel = pointLabel()
    var fuzzyLabel = UILabel()
    var fuzzyProgressView = YXReviewProgressView(type: .fuzzy)
    var fuzzyProgressLabel = UILabel()
    
    /// 忘记
    var forgetPointLabel = pointLabel()
    var forgetLabel = UILabel()
    var forgetProgressView = YXReviewProgressView(type: .forget)
    var forgetProgressLabel = UILabel()
    
    /// 智能复习
    var reviewButton = UIButton()
    var subTitleLabel = UILabel()
    
    
    var favoriteButton = UIButton()
    var wrongWordButton = UIButton()
    
    
    var reviewPlanLabel = UILabel()
    var createReviewPlanButton = UIButton()
    
    
    deinit {
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        createReviewPlanButton.removeTarget(self, action: #selector(clickCreateReviewPlanButton), for: .touchUpInside)
        favoriteButton.removeTarget(self, action: #selector(clickFavoriteButton), for: .touchUpInside)
        wrongWordButton.removeTarget(self, action: #selector(clickWrongWordButton), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(bgView)
        self.addSubview(imageView)
        self.addSubview(favoriteButton)
        self.addSubview(wrongWordButton)
        self.addSubview(reviewPlanLabel)
        self.addSubview(createReviewPlanButton)
        
        
        bgView.addSubview(contentView)
        
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
        
        contentView.addSubview(reviewButton)
        contentView.addSubview(subTitleLabel)
                
    }
    
    
    override func bindProperty() {
        imageView.image = UIImage(named: "review_circle_icon")
        
        bgView.backgroundColor = UIColor.orange1
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = AS(20)
        
                
        contentView.backgroundColor = UIColor.white
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = AS(15)
        
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AS(14))
        titleLabel.text = "背过的单词"
        titleLabel.textColor = UIColor.black2
        titleLabel.textAlignment = .center
        
        
        countLabel.font = UIFont.pfSCSemiboldFont(withSize: AS(35))
        countLabel.text = "200"
        countLabel.textColor = UIColor.black1
        countLabel.textAlignment = .center
        
        
        familiarLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        familiarLabel.textColor = UIColor.black1
        familiarLabel.text = "熟悉的单词"
        familiarProgressLabel.font = UIFont.pfSCRegularFont(withSize: AS(10))
        familiarProgressLabel.textColor = UIColor.orange5
        familiarProgressLabel.text = "50%"
        familiarPointLabel.backgroundColor = UIColor.orange5
                        
        
        iKnowLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        iKnowLabel.textColor = UIColor.black1
        iKnowLabel.text = "认识的单词"
        iKnowProgressLabel.font = UIFont.pfSCRegularFont(withSize: AS(10))
        iKnowProgressLabel.textColor = UIColor.orange1
        iKnowProgressLabel.text = "60%"
        iKnowPointLabel.backgroundColor = UIColor.orange1
        
        
        fuzzyLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        fuzzyLabel.textColor = UIColor.black1
        fuzzyLabel.text = "模糊的单词"
        fuzzyProgressLabel.font = UIFont.pfSCRegularFont(withSize: AS(10))
        fuzzyProgressLabel.textColor = UIColor.green2
        fuzzyProgressLabel.text = "80%"
        fuzzyPointLabel.backgroundColor = UIColor.green2
        
        
        forgetLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        forgetLabel.textColor = UIColor.black1
        forgetLabel.text = "忘记的单词"
        forgetProgressLabel.font = UIFont.pfSCRegularFont(withSize: AS(10))
        forgetProgressLabel.textColor = UIColor.blue1
        forgetProgressLabel.text = "10%"
        forgetPointLabel.backgroundColor = UIColor.blue1

        
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(21)
        reviewButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        reviewButton.setTitle("智能复习", for: .normal)
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        
        subTitleLabel.textColor = UIColor.black6
        subTitleLabel.text = "智能计划复习内容巩固薄弱单词"
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        
        
        favoriteButton.setBackgroundImage(UIImage(named: "review_favorite_icon"), for: .normal)
        favoriteButton.setTitle("收藏夹", for: .normal)
        favoriteButton.setTitleColor(UIColor.brown1, for: .normal)
        favoriteButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        favoriteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: AS(-60), bottom: 0, right: 0)
        favoriteButton.addTarget(self, action: #selector(clickFavoriteButton), for: .touchUpInside)
        
        
        wrongWordButton.setBackgroundImage(UIImage(named: "review_wrong_icon"), for: .normal)
        wrongWordButton.setTitle("错词本", for: .normal)
        wrongWordButton.setTitleColor(UIColor.brown1, for: .normal)
        wrongWordButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        wrongWordButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: AS(-60), bottom: 0, right: 0)
        wrongWordButton.addTarget(self, action: #selector(clickWrongWordButton), for: .touchUpInside)
        
        reviewPlanLabel.font = UIFont.mediumFont(ofSize: AS(15))
        reviewPlanLabel.textColor = UIColor.black1
        reviewPlanLabel.text = "复习计划"
        
        createReviewPlanButton.layer.masksToBounds = true
        createReviewPlanButton.layer.cornerRadius = AS(12.5)
        createReviewPlanButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        createReviewPlanButton.setImage(UIImage(named: "review_add_icon"), for: .normal)
        createReviewPlanButton.setTitle("制定复习计划", for: .normal)
        createReviewPlanButton.setTitleColor(UIColor.white, for: .normal)
        createReviewPlanButton.titleLabel?.font = UIFont.regularFont(ofSize: AS(12))
        createReviewPlanButton.addTarget(self, action: #selector(clickCreateReviewPlanButton), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.height.equalTo(AS(339))
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(8))
            make.left.equalTo(AS(11))
            make.width.equalTo(AS(42))
            make.height.equalTo(AS(29))
        }
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(9))
            make.left.equalTo(AS(8))
            make.right.equalTo(AS(-8))
            make.bottom.equalTo(AS(-10))
        }
                
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(23))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(71))
            make.height.equalTo(AS(20))
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(40))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(300))
            make.height.equalTo(AS(41))
        }
        
        
        familiarPointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(familiarLabel)
            make.right.equalTo(familiarLabel.snp.left).offset(AS(-4))
            make.width.height.equalTo(AS(5))
        }
        familiarLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(100))
            make.left.right.equalTo(familiarProgressView)
            make.height.equalTo(AS(17))
        }
        familiarProgressView.snp.makeConstraints { (make) in
            make.top.equalTo(familiarLabel.snp.bottom).offset(AS(4))
            make.left.equalTo(AS(26))
            make.height.equalTo(AS(10))
        }
        familiarProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(familiarProgressView.snp.bottom).offset(AS(3))
            make.left.right.equalTo(familiarProgressView)
            make.height.equalTo(AS(14))
        }
        
        
                                            
        iKnowPointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(iKnowLabel)
            make.right.equalTo(iKnowLabel.snp.left).offset(AS(-4))
            make.width.height.equalTo(AS(5))
        }
        iKnowLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(100))
            make.left.right.equalTo(iKnowProgressView)
            make.height.equalTo(AS(17))
        }
        iKnowProgressView.snp.makeConstraints { (make) in
            make.top.equalTo(iKnowLabel.snp.bottom).offset(AS(4))
            make.left.equalTo(familiarProgressView.snp.right).offset(AS(35))
            make.right.equalTo(AS(-15))
            make.width.equalTo(familiarProgressView)
            make.height.equalTo(AS(10))
        }
        iKnowProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iKnowProgressView.snp.bottom).offset(AS(3))
            make.left.right.equalTo(iKnowProgressView)
            make.height.equalTo(AS(14))
        }

        
        fuzzyPointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(fuzzyLabel)
            make.right.equalTo(fuzzyLabel.snp.left).offset(AS(-4))
            make.width.height.equalTo(AS(5))
        }
        fuzzyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(165))
            make.left.right.height.equalTo(familiarLabel)
        }
        fuzzyProgressView.snp.makeConstraints { (make) in
            make.top.equalTo(fuzzyLabel.snp.bottom).offset(AS(4))
            make.left.right.height.equalTo(familiarProgressView)
        }
        fuzzyProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fuzzyProgressView.snp.bottom).offset(AS(3))
            make.left.right.equalTo(fuzzyProgressView)
            make.height.equalTo(AS(14))
        }
        
                                    
        forgetPointLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(forgetLabel)
            make.right.equalTo(forgetLabel.snp.left).offset(AS(-4))
            make.width.height.equalTo(AS(5))
        }
        forgetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(165))
            make.left.right.height.equalTo(iKnowLabel)
        }
        forgetProgressView.snp.makeConstraints { (make) in
            make.top.equalTo(forgetLabel.snp.bottom).offset(AS(4))
            make.left.right.height.equalTo(iKnowProgressView)
        }
        forgetProgressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(forgetProgressView.snp.bottom).offset(AS(3))
            make.left.right.equalTo(forgetProgressView)
            make.height.equalTo(AS(14))
        }
        
        
        
        reviewButton.snp.makeConstraints { (make) in
            make.top.equalTo(forgetProgressLabel.snp.bottom).offset(AS(14))
            make.left.equalTo(AS(45))
            make.right.equalTo(AS(-45))
            make.height.equalTo(AS(42))
        }
        
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(reviewButton.snp.bottom).offset(AS(8))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(169))
            make.height.equalTo(AS(17))
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(AS(10))
            make.left.equalTo(AS(22))
            make.height.equalTo(AS(51))
        }
        
        wrongWordButton.snp.makeConstraints { (make) in
            make.top.equalTo(bgView.snp.bottom).offset(AS(10))
            make.left.equalTo(favoriteButton.snp.right).offset(AS(12))
            make.right.equalTo(AS(-22))
            make.width.equalTo(AS(160))
            make.height.equalTo(AS(51))
        }
        
        
        reviewPlanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(favoriteButton.snp.bottom).offset(AS(25))
            make.left.equalTo(AS(22))
            make.width.equalTo(AS(61))
            make.height.equalTo(AS(21))
        }
        
        createReviewPlanButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewPlanLabel)
            make.right.equalTo(AS(-22))
            make.width.equalTo(AS(104))
            make.height.equalTo(AS(25))
        }
        
        super.layoutIfNeeded()
    }

    override func bindData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.familiarProgressView.progress = self.progressValue(num: self.reviewModel?.familiarNum)
            self.iKnowProgressView.progress = self.progressValue(num: self.reviewModel?.knowNum)
            self.fuzzyProgressView.progress = self.progressValue(num: self.reviewModel?.fuzzyNum)
            self.forgetProgressView.progress = self.progressValue(num: self.reviewModel?.forgetNum)
        }
        
        countLabel.text = "\(reviewModel?.learnNum ?? 0)"
        familiarLabel.text = "熟悉的单词  \(reviewModel?.familiarNum ?? 0)个"
        iKnowLabel.text = "认识的单词  \(reviewModel?.knowNum ?? 0)个"
        fuzzyLabel.text = "模糊的单词  \(reviewModel?.fuzzyNum ?? 0)个"
        forgetLabel.text = "忘记的单词  \(reviewModel?.forgetNum ?? 0)个"
        
        familiarProgressLabel.text = progressStringValue(num: reviewModel?.familiarNum)
        iKnowProgressLabel.text = progressStringValue(num: reviewModel?.knowNum)
        fuzzyProgressLabel.text = progressStringValue(num: reviewModel?.fuzzyNum)
        forgetProgressLabel.text  = progressStringValue(num: reviewModel?.forgetNum)
        
        createReviewPlanButton.isHidden = (reviewModel?.reviewPlans?.count ?? 0 == 0)
        
    }
    
    private func progressStringValue(num: Int?) -> String {
        return "\(Int(progressValue(num: num) *  100))%"
    }
    
    private func progressValue(num: Int?) -> CGFloat {
        guard let n = num, let model = self.reviewModel, model.learnNum > 0 else {
            return 0
        }
        return CGFloat(n) / CGFloat(model.learnNum)
    }
    
    private class func pointLabel() -> UILabel {
        let label = UILabel()
        label.layer.masksToBounds = true
        label.layer.cornerRadius = AS(5 / 2.0)
        
        return label
    }
    
    @objc private func clickReviewButton() {
        self.startReviewEvent?()
    }
    @objc private func clickCreateReviewPlanButton() {        
        self.createReviewPlanEvent?()
    }
    @objc private func clickFavoriteButton() {
       self.favoriteEvent?()
    }
       
    @objc private func clickWrongWordButton() {
        self.wrongWordEvent?()
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
    
    private var type: YXReviewProgressViewType = .familiar
    private var progressView = UIView()
    private var cornerRadius: CGFloat = 5
    
    init(type: YXReviewProgressViewType, cornerRadius: CGFloat = 5) {
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
        self.backgroundColor = UIColor.gray2
        self.layer.masksToBounds = true
        self.layer.cornerRadius = cornerRadius
        
        self.progressView.layer.masksToBounds = true
        self.progressView.layer.cornerRadius = cornerRadius
        
        self.progressView.backgroundColor = self.color()
    }
    
    override func layoutSubviews() {
        
        
    }
    
    override func bindData() {
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.height)
        
        UIView.animate(withDuration: 0.6) {[weak self] in
            guard let self = self else { return }
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
