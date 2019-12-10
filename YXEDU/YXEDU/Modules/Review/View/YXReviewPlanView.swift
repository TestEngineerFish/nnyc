//
//  YXReviewPlanView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/9.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXReviewPlanView: YXView {
    
    var titleLabel = UILabel()
    var countLabel = UILabel()
    
    /// 熟悉
    var familiarLabel = UILabel()
    var familiarProgressLabel = UILabel()
    
    /// 认识
    var iKnowLabel = UILabel()
    var iKnowProgressLabel = UILabel()
    
    /// 模糊
    var fuzzyLabel = UILabel()
    var fuzzyProgressLabel = UILabel()
    
    /// 忘记
    var forgetLabel = UILabel()
    var forgetProgressLabel = UILabel()
    
    /// 智能复习
    var reviewButton = UIButton()
    var subTitleLabel = UILabel()
    
    
    var bgView2 = UIView()
    var contentView = UIView()
    
    
    var favoriteButton = UIButton()
    var wrongWordButton = UIButton()
        
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        self.addSubview(contentView)
        
        self.addSubview(favoriteButton)
        self.addSubview(wrongWordButton)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        
        contentView.addSubview(familiarLabel)
        contentView.addSubview(familiarProgressLabel)
        contentView.addSubview(iKnowLabel)
        contentView.addSubview(iKnowProgressLabel)
        contentView.addSubview(fuzzyLabel)
        contentView.addSubview(fuzzyProgressLabel)
        contentView.addSubview(forgetLabel)
        contentView.addSubview(forgetProgressLabel)
        contentView.addSubview(reviewButton)
        contentView.addSubview(subTitleLabel)
    }
    
    
    override func bindProperty() {
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(50)
            make.height.equalTo(320)
        }
        
        
        
        
        
    }
    
    
    
}
