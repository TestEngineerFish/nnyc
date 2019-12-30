//
//  YXReviewPlanDetailHeaderView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


class YXReviewPlanShareDetailHeaderView: YXView {
    
    var reviewPlanModel: YXReviewPlanDetailModel? {
        didSet { bindData() }
    }
    
    var bgView = UIView()
    
    var reviewPlanLabel = UILabel()
    var fromLabel = UILabel()
    
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
        bgView.addSubview(reviewPlanLabel)
        bgView.addSubview(fromLabel)
    }
    
    override func bindProperty() {
        bgView.backgroundColor = UIColor.white
        bgView.layer.setDefaultShadow(radius: AS(4))
        
        reviewPlanLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
        reviewPlanLabel.text = "我的复习计划1"
        reviewPlanLabel.textColor = UIColor.black1
        
        fromLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        fromLabel.text = "来自张老师分享的复习计划"
        fromLabel.textColor = UIColor.black3
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.height.equalTo(AS(87))
        }
        
        reviewPlanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(20))
            make.left.equalTo(AS(20))
            make.right.equalTo(AS(-20))
            make.height.equalTo(AS(21))
        }
    
        fromLabel.snp.makeConstraints { (make) in
            make.top.equalTo(reviewPlanLabel.snp.bottom).offset(AS(14))
            make.left.equalTo(reviewPlanLabel)
            make.right.equalTo(AS(-20))
            make.height.equalTo(AS(17))
        }

    }
    
    
    override func bindData() {
        reviewPlanLabel.text = reviewPlanModel?.planName
        fromLabel.text = "来自\(reviewPlanModel?.fromUser ?? "")分享的复习计划"
    }
    
}





class YXReviewPlanDetailHeaderView: YXView {

    var reviewPlanModel: YXReviewPlanDetailModel? {
        didSet { bindData() }
    }
    
    var bgView = UIView()
    
    var reviewPlanLabel = UILabel()
    var subTitleLabel = UILabel()
    var fromLabel = UILabel()
    var reviewProgressView = YXReviewPlanProgressView()
    var editButton = UIButton()
    
    
    deinit {
        editButton.removeTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
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
        
        bgView.addSubview(reviewPlanLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(fromLabel)
        bgView.addSubview(reviewProgressView)
        bgView.addSubview(editButton)
        
    }
    
    override func bindProperty() {
        bgView.backgroundColor = UIColor.white
        bgView.layer.setDefaultShadow(radius: AS(4))
        
        reviewPlanLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
//        reviewPlanLabel.text = "我的复习计划1"
        reviewPlanLabel.textColor = UIColor.black1

        
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
//        subTitleLabel.text = "听写成绩：9"
        subTitleLabel.textColor = UIColor.black3
                                
        
        fromLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
//        fromLabel.text = "听写成绩：9"
        fromLabel.textColor = UIColor.black3
        
        editButton.setImage(UIImage(named: "review_plan_detail_edit"), for: .normal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.height.equalTo(AS(108))
        }
        
        let titleWidth = reviewPlanLabel.text?.textWidth(font: reviewPlanLabel.font, height: AS(21)) ?? 0
        reviewPlanLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AS(20))
            make.left.equalTo(AS(20))
            make.width.equalTo(titleWidth)
            make.height.equalTo(AS(21))
        }
        
        
        editButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(reviewPlanLabel)
            make.left.equalTo(reviewPlanLabel.snp.right).offset(AS(13))
            make.width.equalTo(AS(15))
            make.height.equalTo(AS(15))
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(reviewPlanLabel.snp.bottom).offset(AS(3))
            make.left.equalTo(reviewPlanLabel)
            make.right.equalTo(reviewProgressView.snp.left).offset(AS(-20))
            make.height.equalTo(AS(17))
        }
        
        
        fromLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(AS(14))
            make.left.equalTo(reviewPlanLabel)
            make.right.equalTo(reviewProgressView.snp.left).offset(AS(-20))
            make.height.equalTo(AS(17))
        }
        
        
        reviewProgressView.snp.makeConstraints { (make) in
            make.top.equalTo(AS(19))
            make.right.equalTo(AS(-19))
            make.width.equalTo(AS(41))
            make.height.equalTo(AS(41))
        }
    }
    
    
    override func bindData() {
        reviewPlanLabel.text = reviewPlanModel?.planName
        
        subTitleLabel.text = "听写成绩：" + (reviewPlanModel?.wordCount.string ?? "")
//        if let nickname = reviewPlanModel?.fromUser {
//            fromLabel.text = "来自\(nickname)分享的复习计划"
//        }
    }
    

    
    
    
    @objc func clickEditButton() {
    }
    
    
    @objc func clickListenButton() {
        
    }
    
}
