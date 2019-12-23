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
        
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var progressView = YXReviewProgressView(type: .iKnow)
    
    var subTitleLable1 = UILabel()
    var subTitleLable2 = UILabel()
    var subTitleLable3 = UILabel()
    
    var pointLabel1 = UILabel()
    var pointLabel2 = UILabel()
    var pointLabel3 = UILabel()
    
    var reviewButton = UIButton()
    var closeButton = UIButton()
    
    var model: YXReviewPlanCommandModel? {
        didSet { bindData() }
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
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressView)
        
        contentView.addSubview(subTitleLable1)
        contentView.addSubview(subTitleLable2)
        contentView.addSubview(subTitleLable3)
        
        contentView.addSubview(pointLabel1)
        contentView.addSubview(pointLabel2)
        contentView.addSubview(pointLabel3)
        
        contentView.addSubview(reviewButton)
        contentView.addSubview(closeButton)
    }
    
    override func bindProperty() {
        
        imageView.image = UIImage(named: "review_learning_progress")
        
        titleLabel.textAlignment = .center
        
        pointLabel1.layer.masksToBounds = true
        pointLabel1.layer.cornerRadius = AS(2)
        pointLabel1.backgroundColor = UIColor.black4
        
        
        pointLabel2.layer.masksToBounds = true
        pointLabel2.layer.cornerRadius = AS(2)
        pointLabel2.backgroundColor = UIColor.black4
        
        
        pointLabel3.layer.masksToBounds = true
        pointLabel3.layer.cornerRadius = AS(2)
        pointLabel3.backgroundColor = UIColor.black4
        
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = AS(21)
        reviewButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        reviewButton.setTitle("继续复习", for: .normal)
        reviewButton.setTitleColor(UIColor.white, for: .normal)
        reviewButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: AS(17))
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
        
        closeButton.setImage(UIImage(named: "review_learning_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(clickCloseButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
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
        
        pointLabel3.snp.makeConstraints { (make) in
            make.top.equalTo(progressView.snp.bottom).offset(AS(81))
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
        
        subTitleLable3.snp.makeConstraints { (make) in
            make.centerY.equalTo(pointLabel3)
            make.left.equalTo(pointLabel3.snp.right).offset(AS(12))
            make.right.equalTo(AS(-20))
            make.width.height.equalTo(AS(20))
        }
        
        reviewButton.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLable3.snp.bottom).offset(AS(41))
            make.left.equalTo(AS(51))
            make.right.equalTo(AS(-51))
            make.height.equalTo(AS(42))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.progressView.progress = 0.5
        }
                
        titleLabel.attributedText = attrString()
        subTitleLable1.attributedText = attrString("巩固了 32 个单词", 4, 2)
        subTitleLable2.attributedText = attrString("20 个单词掌握的很好", 0, 2)
        subTitleLable3.attributedText = attrString("该计划下剩余 20 个单词待复习", 7, 2)

    }
    
    @objc func clickReviewButton() {
        self.reviewEvent?()
    }
    
    
    @objc func clickCloseButton() {
        self.removeFromSuperview()
    }

    
    func attrString() -> NSAttributedString {
        
        
        let attrString = NSMutableAttributedString(string: "<复习计划> 完成 50%")
        let start = attrString.length - "50%".count
        
        let all: [NSAttributedString.Key : Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.black1]
        attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
        
        let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.mediumFont(ofSize: AS(17)),.foregroundColor: UIColor.orange1]
        attrString.addAttributes(nicknameAttr, range: NSRange(location: start, length: "50%".count))

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
}
