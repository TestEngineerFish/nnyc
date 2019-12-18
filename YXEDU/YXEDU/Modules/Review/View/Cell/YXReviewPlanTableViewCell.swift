//
//  YXReviewPlanTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanTableViewCell: YXTableViewCell<YXReviewPlanModel> {
    
    var startReviewPlanEvent: (() -> Void)?
    var startListenPlanEvent: (() -> Void)?
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
    var listenButton = UIButton()
    var reviewButton = UIButton()
    
    deinit {
        listenButton.removeTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
        reviewButton.removeTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(bgView)
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(countLabel)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(listenStarView)
        bgView.addSubview(reviewStarView)
        bgView.addSubview(reviewProgressView)
        
        bgView.addSubview(listenImageView)
        bgView.addSubview(listenButton)
        bgView.addSubview(reviewButton)
    }
    
    override func bindProperty() {
        bgView.backgroundColor = UIColor.white
        bgView.layer.setDefaultShadow(radius: 4)
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: 15)
        titleLabel.text = "我的复习计划1"
        titleLabel.textColor = UIColor.black1
        
        countLabel.font = UIFont.pfSCRegularFont(withSize: 12)
        countLabel.textColor = UIColor.black3
        
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: 12)
        subTitleLabel.text = "听写进度：80%"
        subTitleLabel.textColor = UIColor.black3
        
                
        listenImageView.image = UIImage(named: "review_listen_icon")
        
        listenButton.setTitle("听写练习", for: .normal)
        listenButton.titleLabel?.font = UIFont.regularFont(ofSize: 12)
        listenButton.setTitleColor(UIColor.orange1, for: .normal)
        listenButton.addTarget(self, action: #selector(clickListenButton), for: .touchUpInside)
                                    
        
        reviewButton.titleLabel?.font = UIFont.regularFont(ofSize: 14)
        reviewButton.setTitleColor(UIColor.black2, for: .normal)
        reviewButton.layer.masksToBounds = true
        reviewButton.layer.cornerRadius = 15
        reviewButton.layer.borderColor = UIColor.black4.cgColor
        reviewButton.layer.borderWidth = 0.5
        reviewButton.addTarget(self, action: #selector(clickReviewButton), for: .touchUpInside)
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
        
        
        if reviewPlanModel?.listenState != .normal {
            let subTitleWidth = subTitleLabel.text?.textWidth(font: subTitleLabel.font, height: 17) ?? 0
            subTitleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(5)
                make.left.equalTo(titleLabel)
                make.width.equalTo(subTitleWidth)
                make.height.equalTo(17)
            }
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
        
        listenButton.snp.makeConstraints { (make) in
            make.left.equalTo(listenImageView.snp.right).offset(7)
            make.width.equalTo(49)
            make.height.equalTo(17)
            make.bottom.equalTo(-22)
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
    
    
    override func bindData() {
        titleLabel.text = reviewPlanModel?.planName
        countLabel.text = "单词: " + (reviewPlanModel?.wordCount.string ?? "")
        
        if reviewPlanModel?.reviewState == .normal {
            reviewButton.setTitle("开始复习", for: .normal)
        } else {
            reviewButton.setTitle("继续复习", for: .normal)
        }
    }
    
    
    override class func viewHeight(model: YXReviewPlanModel) -> CGFloat {
        let vHeight: CGFloat = model.listenState != .normal || model.reviewState != .normal ? 120 : 103
        return vHeight
    }
    
    
    
    @objc func clickReviewButton() {
        self.startReviewPlanEvent?()
    }
    
    
    @objc func clickListenButton() {
        self.startListenPlanEvent?()
    }
}



class YXReviewPlanStarContainerView: UIView {
    
    
}


class YXReviewPlanProgressView: UIView {
    
}

