//
//  YXReviewPlanTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanTableViewCell: UITableViewCell {
    
    var reviewPlanModel: YXReviewPlanModel? {
        didSet { bindData() }
    }
    
    var bgView = UIView()
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    var subTitleLabel = UILabel()
    var listenStarView = YXReviewPlanStarContainerView()
    var reviewStarView = YXReviewPlanStarContainerView()
    var reviewProgressView = YXReviewPlanProgressView()
    var listenImageView = UIImageView()
    var listenLabel = UILabel()
    var reviewButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubviews() {
        self.addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(countLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(listenStarView)
        bgView.addSubview(reviewStarView)
        bgView.addSubview(reviewProgressView)
        
        bgView.addSubview(listenImageView)
        bgView.addSubview(listenLabel)
        bgView.addSubview(reviewButton)
    }
    
    func bindProperty() {
        titleLabel.font = UIFont.pfSCRegularFont(withSize: 15)
        titleLabel.text = "我的复习计划1"
        titleLabel.textColor = UIColor.black1
        
        countLabel.font = UIFont.pfSCRegularFont(withSize: 12)
        countLabel.text = "我的复习计划1"
        countLabel.textColor = UIColor.black3
        
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: 12)
        subTitleLabel.text = "听写进度：80%"
        subTitleLabel.textColor = UIColor.black3
        
        reviewButton.titleLabel?.font = UIFont.regularFont(ofSize: 14)
        reviewButton.setTitleColor(UIColor.black2, for: .normal)
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = 15
        reviewButton.layer.borderColor = UIColor.black4.cgColor
        reviewButton.layer.borderWidth = 0.5
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.makeConstraints { (make) in
            make.top.equalTo(6.5)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.bottom.equalTo(-6.5)
        }
        
        let titleWidth = titleLabel.text?.textWidth(font: titleLabel.font, height: 21) ?? 0
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(15)
            make.left.equalTo(22)
            make.width.equalTo(titleWidth)
            make.height.equalTo(21)
        }
        
        let countWidth = countLabel.text?.textWidth(font: countLabel.font, height: 17) ?? 0
        countLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.width.equalTo(countWidth)
            make.height.equalTo(17)
        }
        
        
        
        let subTitleWidth = subTitleLabel.text?.textWidth(font: subTitleLabel.font, height: 17) ?? 0
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel)
            make.width.equalTo(subTitleWidth)
            make.height.equalTo(17)
        }
        
        
        
        if reviewPlanModel?.listenState == .finish {
            listenStarView.snp.makeConstraints { (make) in
                make.centerY.equalTo(subTitleLabel)
                make.left.equalTo(subTitleLabel.snp.right).offset(1)
                make.width.equalTo(14)
                make.height.equalTo(48)
            }
        }
        
        
        
        listenImageView.snp.makeConstraints { (make) in
            make.left.equalTo(23)
            make.bottom.equalTo(-23)
            make.width.height.equalTo(15)
        }
        
        
        reviewButton.snp.makeConstraints { (make) in
            make.right.equalTo(-9)
            make.bottom.equalTo(-14)
            make.width.equalTo(96)
            make.height.equalTo(30)
        }
        
        
        if reviewPlanModel?.reviewState == .learning {
            reviewProgressView.snp.makeConstraints { (make) in
                make.top.equalTo(26)
                make.right.equalTo(17)
                make.width.equalTo(81)
                make.height.equalTo(27)
            }
        }
        
        if reviewPlanModel?.reviewState == .finish {
            reviewStarView.snp.makeConstraints { (make) in
                make.top.equalTo(26)
                make.right.equalTo(17)
                make.width.equalTo(81)
                make.height.equalTo(27)
            }
        }
        
    }
    
    
    func bindData() {
        
    }
    
    
    func viewHeight() -> CGFloat {
        let vHeight: CGFloat = reviewPlanModel?.listenState != .normal || reviewPlanModel?.reviewState != .normal ? 120 : 103
        return vHeight
    }
}



class YXReviewPlanStarContainerView: UIView {
    
    
}


class YXReviewPlanProgressView: UIView {
    
}

