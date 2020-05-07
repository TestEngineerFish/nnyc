//
//  YXWordAndChineseQuestionView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 单词+音标+词义题目 (判断题)
class YXWordAndChineseQuestionView: YXBaseQuestionView {
    override func createSubviews() {
        super.createSubviews()
        self.initTitleLabel()
        self.initDescTitleLabel()
        self.descTitleLabel?.font = UIFont.regularFont(ofSize: AdaptFontSize(16))
        self.descTitleLabel?.textColor = UIColor.black1
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.sizeToFit()
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(AdaptIconSize(33))
            make.centerX.equalToSuperview()
            make.size.equalTo(titleLabel?.size ?? CGSize.zero)
        })
        
        descTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom).offset(AdaptSize(28))
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptIconSize(20))
        })
        
        audioPlayerView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel!)
            make.left.equalTo(titleLabel!.snp.right).offset(AdaptIconSize(3))
            make.width.height.equalTo(AdaptIconSize(22))
        })
    }
    
    override func bindData() {
        let word = (exerciseModel.question?.word ?? "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        self.titleLabel?.text = word
        
        for item in self.exerciseModel.option?.firstItems ?? [] {
             if let meaning = item.content, item.optionId != -1 {
                self.descTitleLabel?.text = meaning
             }
         }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
}
