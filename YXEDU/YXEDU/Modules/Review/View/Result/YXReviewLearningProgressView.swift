//
//  YXReviewLearningProgressView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 学习中【听写、复习计划】
class YXReviewLearningProgressView: YXTopWindowView {

    var reviewEvent: (() -> ())?
    var type: YXExerciseDataType = .aiReview
        
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var progressView = YXReviewProgressView(type: .iKnow, cornerRadius: AS(4))
    
    var subTitleLable1 = UILabel()
    var subTitleLable2 = UILabel()
    var subTitleLable3 = UILabel()
    
    var pointLabel1 = UILabel()
    var pointLabel2 = UILabel()
    var pointLabel3 = UILabel()
    
    var reviewButton = YXButton()
    var closeButton = UIButton()
    
    var model: YXReviewResultModel?
    
    deinit {
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        closeButton.removeTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    init(type: YXExerciseDataType, model: YXReviewResultModel?) {
        super.init(frame: .zero)
        self.type = type
        self.model = model
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func createSubviews() {
        
        mainView.addSubview(imageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(progressView)
        
        mainView.addSubview(subTitleLable1)
        mainView.addSubview(subTitleLable2)
        mainView.addSubview(subTitleLable3)
        
        mainView.addSubview(pointLabel1)
        mainView.addSubview(pointLabel2)
        mainView.addSubview(pointLabel3)
        
        mainView.addSubview(reviewButton)
        mainView.addSubview(closeButton)
    }
    
    override func bindProperty() {
        
        imageView.image = UIImage(named: "review_learning_progress")
        
        titleLabel.textAlignment = .center
        
        pointLabel1.layer.masksToBounds = true
        pointLabel1.layer.cornerRadius = AS(2)
        pointLabel1.backgroundColor = UIColor.black4
        pointLabel1.isHidden = true
        
        pointLabel2.layer.masksToBounds = true
        pointLabel2.layer.cornerRadius = AS(2)
        pointLabel2.backgroundColor = UIColor.black4
        pointLabel2.isHidden = true
        
        pointLabel3.layer.masksToBounds = true
        pointLabel3.layer.cornerRadius = AS(2)
        pointLabel3.backgroundColor = UIColor.black4
        pointLabel3.isHidden = true
        
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(21)
        let bgColor = UIColor.gradientColor(with: CGSize(width: AS(273), height: AS(42)), colors: [UIColor.hex(0xFDBA33), UIColor.orange1], direction: .vertical)
//        reviewButton.setBackgroundImage(UIImage.imageWithColor(bgColor ?? UIColor.orange1), for: .normal)
        reviewButton.backgroundColor = bgColor
        if type == .planListenReview {
            reviewButton.setTitle("继续听写", for: .normal)
        } else if type == .planReview {
            reviewButton.setTitle("继续复习", for: .normal)
        }
        
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "review_learning_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(103))
            make.centerX.equalToSuperview()
            make.width.equalTo(AS(233))
            make.height.equalTo(AS(109))
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(AS(13))
            make.left.right.equalToSuperview()
            make.height.equalTo(AS(24))
        }
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(11))
            make.left.right.equalTo(imageView)
            make.height.equalTo(AS(8))
        }
        
        pointLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(AS(36))
            make.left.equalTo(AS(85))
            make.width.height.equalTo(AS(4))
        }
        
        pointLabel2.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(AS(58))
            make.left.equalTo(AS(85))
            make.width.height.equalTo(AS(4))
        }
        
        
        subTitleLable1.snp.makeConstraints { (make) in
            make.centerY.equalTo(pointLabel1)
            make.left.equalTo(pointLabel1.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.width.height.equalTo(AS(20))
        }
        
        subTitleLable2.snp.makeConstraints { (make) in
            make.centerY.equalTo(pointLabel2)
            make.left.equalTo(pointLabel2.snp.right).offset(AS(12))
            make.right.equalTo(AS(-85))
            make.width.height.equalTo(AS(20))
        }
        
        if type == .planListenReview {
            reviewButton.snp.makeConstraints { (make) in
                make.top.equalTo(subTitleLable2.snp.bottom).offset(AS(41))
                make.centerX.equalToSuperview()
                make.width.equalTo(AS(273))
                make.height.equalTo(AS(42))
            }
        } else {
            pointLabel3.snp.makeConstraints { (make) in
                make.top.equalTo(progressView.snp.bottom).offset(AS(81))
                make.left.equalTo(AS(85))
                make.width.height.equalTo(AS(4))
            }
            subTitleLable3.snp.makeConstraints { (make) in
                make.centerY.equalTo(pointLabel3)
                make.left.equalTo(pointLabel3.snp.right).offset(AS(12))
                make.right.equalTo(AS(-20))
                make.width.height.equalTo(AS(20))
            }
            
            reviewButton.snp.makeConstraints { (make) in
                make.top.equalTo(subTitleLable3.snp.bottom).offset(AS(41))
                make.centerX.equalToSuperview()
                make.width.equalTo(AS(273))
                make.height.equalTo(AS(42))
            }
        }

    
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(AS(29 + kSafeBottomMargin))
            make.left.equalTo(AS(15))
            make.width.equalTo(AS(28))
            make.height.equalTo(AS(28))
        }
        
        self.layoutIfNeeded()
    }
    
    override func bindData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            guard let self = self else { return }
            let score = CGFloat(self.model?.score ?? 0)
            self.progressView.progress = score / 100.0
        }
        
        pointLabel1.isHidden = true
        pointLabel2.isHidden = true
        pointLabel3.isHidden = true
        
        titleLabel.attributedText = attrString()
        
        if let num = model?.allWordNum, num > 0 {
            pointLabel1.isHidden = false
            
            let length = "\(num)".count
            subTitleLable1.attributedText = attrString(subTitle(num), 3, length)
        }
        if let num = model?.knowWordNum, num > 0 {
            pointLabel2.isHidden = false
            
            let length = "\(num)".count
            subTitleLable2.attributedText = attrString("\(num)个单词掌握的更好了", 0, length)
        }
        
        if let num = model?.remainWordNum, num > 0, type != .planListenReview {
            pointLabel3.isHidden = false
            
            let length = "\(num)".count
            subTitleLable3.attributedText = attrString("该计划下剩余\(model?.remainWordNum ?? 0)个单词待复习", 6, length)
        }


    }
    
    @objc func clickReviewButton() {
        self.reviewEvent?()
        self.clickCloseButton()
    }
    
    
    @objc func clickCloseButton() {
        NotificationCenter.default.post(name: YXNotification.kCloseResultPage, object: nil)
        self.removeFromSuperview()
    }

    
    func attrString() -> NSAttributedString {
        let typeName = type == .planListenReview ? "听写" : ""
        
        let score = model?.score ?? 0
        
        let attrString = NSMutableAttributedString(string: "\(model?.planName ?? "")\(typeName)完成 \(score)%")
        let start = attrString.length - "\(score)%".count
        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.black1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: "\(score)%".count))

        return attrString
    }
    
    func attrString(_ text: String, _ start: Int, _ lenght: Int) -> NSAttributedString {
        
        let attrString = NSMutableAttributedString(string: text)
                        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.black3]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(14)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: lenght))

        return attrString
    }
    
    private func subTitle(_ num: Int) -> String {
        if type == .planListenReview {
            return "听写了\(num)个单词"
        }
        return "巩固了\(num)个单词"
    }
}
