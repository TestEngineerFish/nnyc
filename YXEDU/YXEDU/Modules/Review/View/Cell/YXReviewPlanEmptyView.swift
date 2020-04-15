//
//  YXReviewPlanEmptyView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/16.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanEmptyView: YXView {
    var createReviewPlanEvent: (() -> Void)?
    
    var backgroundImageView = UIImageView()
    var plusIconImageView = UIImageView()
    var reviewLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(backgroundImageView)
        backgroundImageView.addSubview(plusIconImageView)
        backgroundImageView.addSubview(reviewLabel)
    }
    
    override func bindProperty() {
        backgroundImageView.image = UIImage(named: "newReviewPlan")
        backgroundImageView.isUserInteractionEnabled = true
        backgroundImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createReviewPlan)))

        plusIconImageView.image = UIImage(named: "newReviewPlanIcon")
        
        reviewLabel.text = "快来创建一个词单吧"
        reviewLabel.font = UIFont.regularFont(ofSize: AS(14))
        reviewLabel.textColor = UIColor.black3
        reviewLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        
        plusIconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-88)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        reviewLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(plusIconImageView.snp.right).offset(10)
        }
    }
    
    
    @objc func createReviewPlan() {
        self.createReviewPlanEvent?()
    }
}

