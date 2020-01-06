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
        bgView.layer.setDefaultShadow(cornerRadius: AS(4))
        
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

    
    var startReviewPlanEvent: (() -> Void)?
    var startListenPlanEvent: (() -> Void)?
    
    var reviewPlanModel: YXReviewPlanDetailModel? {
        didSet { bindData() }
    }
    
    var bgView = UIView()
    
    var titleLabel = UILabel()
    var editButton = BiggerClickAreaButton()
    var subTitleLabel = UILabel()
    var listenStarView = YXReviewPlanStarContainerView(type: .listen)
    var reviewStarView = YXReviewPlanStarContainerView(type: .plan)
    var reviewProgressView = YXReviewPlanProgressView()
    
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
        
        bgView.addSubview(titleLabel)
        bgView.addSubview(editButton)
        bgView.addSubview(subTitleLabel)
        bgView.addSubview(listenStarView)
        bgView.addSubview(reviewStarView)
        bgView.addSubview(reviewProgressView)
    }
    
    override func bindProperty() {
        bgView.backgroundColor = UIColor.white
        bgView.layer.setDefaultShadow(cornerRadius: AS(6))
        
        titleLabel.font = UIFont.pfSCRegularFont(withSize: AS(15))
        titleLabel.textColor = UIColor.black1
        
        subTitleLabel.font = UIFont.pfSCRegularFont(withSize: AS(12))
        subTitleLabel.textColor = UIColor.black3

        editButton.setImage(UIImage(named: "review_plan_detail_edit"), for: .normal)
        editButton.addTarget(self, action: #selector(clickEditButton), for: .touchUpInside)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(6.5))
            make.left.equalTo(AS(22))
            make.right.equalTo(AS(-22))
            make.bottom.equalTo(AS(-6.5))
        }
        
        var titleWidth = titleLabel.text?.textWidth(font: titleLabel.font, height: AS(21)) ?? 0
        let maxTitleWidth = screenWidth - AS(44 + 22 + 15 + 5 + 41 + 56 )
        titleWidth = titleWidth > maxTitleWidth ? maxTitleWidth : titleWidth
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(AS(15))
            make.left.equalTo(AS(22))
            make.width.equalTo(titleWidth)
            make.height.equalTo(AS(21))
        }
        
        
        editButton.snp.remakeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(AS(13))
            make.width.equalTo(AS(15))
            make.height.equalTo(AS(15))
        }
        
        

        let subTitleWidth = subTitleLabel.text?.textWidth(font: subTitleLabel.font, height: AS(17)) ?? 0
        subTitleLabel.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AS(5))
            make.left.equalTo(titleLabel)
            make.width.equalTo(subTitleWidth)
            make.height.equalTo(AS(17))
        }
        
        listenStarView.isHidden = true
        if reviewPlanModel?.listenState == .finish {
            listenStarView.isHidden = false
            listenStarView.snp.remakeConstraints { (make) in
                make.centerY.equalTo(subTitleLabel)
                make.left.equalTo(subTitleLabel.snp.right).offset(AS(1))
                make.width.equalTo(AS(48))
                make.height.equalTo(AS(14))
            }
        }
        
        reviewProgressView.isHidden = true
        if reviewPlanModel?.reviewState != .finish {
            reviewProgressView.isHidden = false
            reviewProgressView.snp.remakeConstraints { (make) in
                make.top.equalTo(AS(18))
                make.right.equalTo(AS(-18))
                make.size.equalTo(AS(40))
            }
        }
        
        reviewStarView.isHidden = true
        if reviewPlanModel?.reviewState == .finish {
            reviewStarView.isHidden = false
            reviewStarView.snp.remakeConstraints { (make) in
                make.top.equalTo(AS(26))
                make.right.equalTo(AS(-17))
                make.width.equalTo(AS(85))
                make.height.equalTo(AS(31))
            }
        }
        
//        self.layoutIfNeeded()
    }
    
    
    override func bindData() {
        titleLabel.text = reviewPlanModel?.planName
        
        if reviewPlanModel?.listenState == .normal {
            let attrString = NSMutableAttributedString(string: "听写成绩：尚未听写")
        
            let all: [NSAttributedString.Key : Any] = [.font: UIFont.regularFont(ofSize: AS(12)),.foregroundColor: UIColor.black1]
            attrString.addAttributes(all, range: NSRange(location: 0, length: attrString.length))
            
            let nicknameAttr: [NSMutableAttributedString.Key: Any] = [.font: UIFont.regularFont(ofSize: AS(12)),.foregroundColor: UIColor.black3]
            attrString.addAttributes(nicknameAttr, range: NSRange(location: 5, length: 4))
            
            subTitleLabel.attributedText = attrString
        } else if reviewPlanModel?.listenState == .learning {
            subTitleLabel.text = "听写进度：\(reviewPlanModel?.listen ?? 0)%"
        } else if reviewPlanModel?.listenState == .finish {
            subTitleLabel.text = "听写成绩："
            listenStarView.count = reviewPlanModel?.listen ?? 0
        }
        
        if reviewPlanModel?.reviewState == .normal {
            reviewProgressView.progress = 0
        } else if reviewPlanModel?.reviewState == .learning {
            reviewProgressView.progress = CGFloat(reviewPlanModel?.review ?? 0) / 100.0
        } else if reviewPlanModel?.reviewState == .finish {
            reviewStarView.count = reviewPlanModel?.review ?? 0
        }
        
        self.setNeedsLayout()
    }
    
    
//    override class func viewHeight(model: YXReviewPlanModel) -> CGFloat {
//        let vHeight: CGFloat = model.listenState != .normal || model.reviewState != .normal ? 120 : 103
//        return AS(vHeight)
//    }


    
    @objc func clickEditButton() {
        var p = self.convert(editButton.origin, to: editButton.superview?.superview?.superview)
        p.x -= AS(14)
        p.y += AS(15 + 8)

        let editView = YXReviewPlanEditView(point: p)
        editView.reviewPlanModel = reviewPlanModel
        editView.show()
        
    }
    
}
