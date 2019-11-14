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
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            let height = self.subTitleLabel?.attributedText?.string.textHeight(font: subTitleLabel!.font, width: screenWidth - 64) ?? 0
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(height)
        })
    }
    
    override func bindProperty() {
        self.audioPlayerView?.isHidden = true
    }
    override func bindData() {
        
        guard let word = self.exerciseModel.question?.word, let example = exerciseModel.question?.englishExample else {
            return
        }
        
        if let range = example.range(of: word) {
            let location = example.distance(from: example.startIndex, to: range.lowerBound)
            
            let attrString = NSMutableAttributedString(string: example)
            
            let attr: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.black2]
            attrString.addAttributes(attr, range: NSRange(location: 0, length: attrString.length))
            let attr2: [NSAttributedString.Key : Any] = [.font: UIFont.pfSCRegularFont(withSize: 16),.foregroundColor: UIColor.orange1]
            attrString.addAttributes(attr2, range: NSRange(location: location, length: word.count))
            
            self.subTitleLabel?.attributedText = attrString
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
        
    }
    
}
