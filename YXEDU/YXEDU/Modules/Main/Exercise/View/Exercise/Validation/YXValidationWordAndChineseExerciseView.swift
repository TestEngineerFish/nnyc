//
//  YXValidationWordAndChineseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 判断单词和词义对错
class YXValidationWordAndChineseExerciseView: YXBaseExerciseView {
    private let answerHeight: CGFloat = 42
        
    override func createSubview() {
        questionView = YXWordAndChineseQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        
        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.addSubview(remindView!)
        
        answerView = YXRightOrWrongAnswerView(exerciseModel: exerciseModel)
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.questionView?.snp.makeConstraints { (make) in
            make.top.equalTo(32)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(180)
        }
        
        self.answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(answerHeight)
        })
        
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.detail]]
    }
}
