//
//  YXValidationImageAndWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 判断图片和单词对错
class YXValidationImageAndWordExerciseView: YXBaseExerciseView {

    private let answerHeight: CGFloat = 42
        
    override func createSubview() {
        questionView = YXWordAndImageQuestionView(exerciseModel: exerciseModel)
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
            make.height.equalTo(250)
        }
        
        self.answerView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(answerHeight)
        })
//        answerView?.frame = CGRect(x: 0, y: self.size.height - answerHeight, width: screenWidth, height: answerHeight)
        
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.detail]]
    }

}
