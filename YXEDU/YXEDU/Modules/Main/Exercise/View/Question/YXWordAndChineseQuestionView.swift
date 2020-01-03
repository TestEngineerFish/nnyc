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
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth = self.exerciseModel.question?.word?.textWidth(font: titleLabel!.font, height: 28) ?? 0
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
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
        
        audioPlayerView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel!)
            make.left.equalTo(titleLabel!.snp.right).offset(3)
            make.width.height.equalTo(22)
        })
    }
    
    override func bindData() {
        let word = (exerciseModel.question?.word ?? "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
        self.titleLabel?.text     = word
        self.subTitleLabel?.text  = exerciseModel.word?.soundmark
        self.descTitleLabel?.text = (exerciseModel.word?.partOfSpeech ?? "") + " " + (exerciseModel.word?.meaning ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
}
