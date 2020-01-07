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
        self.initAudioPlayerView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth = self.exerciseModel.question?.word?.textWidth(font: titleLabel!.font, height: AdaptSize(37)) ?? 0
        titleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(AdaptSize(49))
            make.centerX.equalToSuperview()
            make.width.equalTo(titleWidth)
            make.height.equalTo(AdaptSize(37))
        })
        
        subTitleLabel?.snp.makeConstraints({ (make) in
            make.top.equalTo(titleLabel!.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(AdaptSize(20))
        })
        
        audioPlayerView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(titleLabel!)
            make.left.equalTo(titleLabel!.snp.right).offset(AdaptSize(3))
            make.width.height.equalTo(AdaptSize(22))
        })
    }
    
    override func bindData() {
        titleLabel?.text = exerciseModel.question?.word
        subTitleLabel?.text = exerciseModel.word?.soundmark
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {[weak self] in
            self?.audioPlayerView?.urlStr = self?.exerciseModel.word?.voice
            self?.audioPlayerView?.play()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.audioPlayerView?.play()
    }
}
