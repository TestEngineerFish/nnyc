//
//  YXImageQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 图片题目
class YXImageQuestionView: YXBaseQuestionView {

    override func createSubviews() {
        super.createSubviews()
        self.initImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.equalTo(130)
            make.height.equalTo(94)
        })
    }
}
