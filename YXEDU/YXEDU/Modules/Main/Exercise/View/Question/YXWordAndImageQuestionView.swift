//
//  YXWordAndImageQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 图片+单词+音标题目
class YXWordAndImageQuestionView: YXBaseQuestionView {
    
    override func createSubviews() {
        super.createSubviews()
        self.initImageView()
        self.initTitleLabel()
        self.initSubTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.snp.makeConstraints({ (make) in
            make.top.equalTo(38)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(94)
        })
        
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(imageView!.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(28)
        })
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        })
        
    }
}

