//
//  YXListenQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音题目
class YXListenQuestionView: YXBaseQuestionView {
    
    private var audioBackgroundView: UIView = UIView()
    
    
    override func createSubviews() {
        super.createSubviews()
        
        contentView.frame = CGRect(x: 22, y: 0, width: screenWidth - 22 * 2, height: 130)        
        self.setShadowColor()
        
        self.contentView.addSubview(audioBackgroundView)
        
        self.audioBackgroundView.backgroundColor = UIColor.orange3
        self.audioBackgroundView.layer.masksToBounds = true
        self.audioBackgroundView.layer.cornerRadius = 24
        self.audioBackgroundView.layer.borderWidth = 3
        self.audioBackgroundView.layer.borderColor = UIColor.orange2.cgColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        audioBackgroundView.snp.makeConstraints({ (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(48)
        })
    }
    
}
