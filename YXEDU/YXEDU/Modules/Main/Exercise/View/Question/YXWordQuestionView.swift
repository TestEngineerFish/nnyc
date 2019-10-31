//
//  YXExerciseWordQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 单词+音标 题目
class YXWordQuestionView: YXBaseQuestionView {
    
    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.initSubTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(56)
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



