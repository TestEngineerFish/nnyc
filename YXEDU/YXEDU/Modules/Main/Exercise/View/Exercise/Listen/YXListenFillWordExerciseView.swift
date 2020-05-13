//
//  YXListenFillWordExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/20.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXListenFillWordExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXListenFillQuestionView(exerciseModel: self.exerciseModel)
        self.addSubview(questionView!)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXListenFillAnswerView(exerciseModel: self.exerciseModel)
        answerView?.answerDelegate = self
        questionView?.addSubview(answerView!)
        super.createSubview()
        (answerView as! YXListenFillAnswerView).textField.showRemindButton { [weak self] (button) in
            self?.exerciseDelegate?.clickTipsBtnEventWithExercise()
        }
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(181)
        
        answerView?.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.image], [.wordChinese], [.exampleWithDigWord, .exampleAudio], [.detail]]
    }

}
