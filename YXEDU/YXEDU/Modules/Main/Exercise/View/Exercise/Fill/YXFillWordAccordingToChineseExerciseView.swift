//
//  YXFillWordAccordingChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// /// 看中文填空，仅点击操作
class YXFillWordAccordingToChineseExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXChineseFillQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)
        remindView?.backgroundColor = UIColor.orange1

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.addSubview(answerView!)

        questionView?.delegate     = answerView
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(180)
        }

        remindView?.snp.makeConstraints({ (make) in
            make.top.equalTo(questionView!.snp.bottom).offset(15)
            make.left.width.equalTo(questionView!)
            make.height.equalTo(150)
        })

        answerView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(200)
        })
    }
}
