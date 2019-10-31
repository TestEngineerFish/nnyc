//
//  YXWordAndChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 单词+音标+词义题目
class YXWordAndChineseQuestionView: YXBaseQuestionView {
    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.initSubTitleLabel()
        self.initDescTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(28)
        })
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        })
        
        descTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(subTitleLabel!.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        })
        
    }
}
