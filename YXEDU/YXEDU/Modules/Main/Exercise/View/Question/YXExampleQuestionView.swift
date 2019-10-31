//
//  YXExampleQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 例句题目
class YXExampleQuestionView: YXBaseQuestionView {
    override func createSubviews() {
        super.createSubviews()
        self.initSubTitleLabel()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            make.centerY.left.right.equalToSuperview()
            make.height.equalTo(22)
        })
    }

    override func bindData() {
        let str = "coffee"
        let question = "Would you like a cup of coffee?"
        
        if let range = question.range(of: str) {
            let location = question.distance(from: question.startIndex, to: range.lowerBound)
            
            let attrString = NSMutableAttributedString(string: question)
            
            let attr: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.black2]
            attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
            let attr2: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.orange1]
            attrString.addAttributes(attr2, range: NSRange(location: location, length: str.count))

            
            self.subTitleLabel?.attributedText = attrString
        }
        
    }
    
}
