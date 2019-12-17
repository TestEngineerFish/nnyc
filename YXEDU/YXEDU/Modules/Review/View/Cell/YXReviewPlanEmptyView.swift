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
    
    var imageView = UIImageView()
    var reviewLabel = UILabel()
    var createReviewPlanButton = UIButton()
    
    deinit {
        createReviewPlanButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
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
        self.addSubview(imageView)
        self.addSubview(reviewLabel)
        self.addSubview(createReviewPlanButton)
    }
    
    
    override func bindProperty() {
        imageView.image = UIImage(named: "review_empty_data")
        
        reviewLabel.text = "您还没创建复习计划，快去创建一个吧！"
        reviewLabel.font = UIFont.regularFont(ofSize: 14)
        reviewLabel.textColor = UIColor.black2
        reviewLabel.textAlignment = .center
        
        createReviewPlanButton.layer.masksToBounds = true
        createReviewPlanButton.layer.cornerRadius = 21
        createReviewPlanButton.setBackgroundImage(UIImage.imageWithColor(UIColor.orange1), for: .normal)
        createReviewPlanButton.setTitle("制定复习计划", for: .normal)
        createReviewPlanButton.setTitleColor(UIColor.white, for: .normal)
        createReviewPlanButton.titleLabel?.font = UIFont.pfSCRegularFont(withSize: 17)
        createReviewPlanButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(222)
            make.height.equalTo(176)
        }
        
        reviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(-5)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        createReviewPlanButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(29)
            make.left.equalTo(51)
            make.right.equalTo(-51)
            make.height.equalTo(42)
            make.bottom.equalToSuperview()
        }
    }
    
    
    @objc func clickReviewButton() {
        self.createReviewPlanEvent?()
    }
}

