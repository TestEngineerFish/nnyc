//
//  YXChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 中文+单词词义题目
class YXChineseQuestionView: YXBaseQuestionView {

    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.titleLabel?.font = UIFont.pfSCSemiboldFont(withSize: 20)
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
    
    override func bindData() {
        titleLabel?.text = exerciseModel.word?.meaning
        subTitleLabel?.text = exerciseModel.word?.partOfSpeech
    }
}
