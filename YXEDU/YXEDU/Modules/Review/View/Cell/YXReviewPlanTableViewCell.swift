//
//  YXReviewPlanTableViewCell.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanTableViewCell: UITableViewCell {
    
    var bgView = UIView()
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    var subTitleLabel = UILabel()
    var listenImageView = UIImageView()
    var listenLabel = UILabel()
    var startReviewButton = UIButton()
    
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
        bgView.addSubview(listenImageView)
        bgView.addSubview(listenLabel)
        bgView.addSubview(startReviewButton)
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
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
        
        
    }
    
}





