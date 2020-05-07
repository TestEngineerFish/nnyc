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
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(showKeyBoard))
        questionView?.addGestureRecognizer(tapAction)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)
        
        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(answerView!)
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        (answerView as! YXAnswerSelectLettersView).textField.showRemindButton { [weak self] (button) in
            self?.remindView?.show()
        }
        super.createSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(isPad() ? 192 : 160)
    }
    
    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord, .image, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
    
    override func showAlertEvnet() {
        (self.answerView as! YXAnswerSelectLettersView).textField.resignFirstResponder()
    }
    
    override func hideAlertEvent() {
        self.showKeyBoard()
    }
    
    // MAKR: --- Event ----
    @objc private func showKeyBoard() {
        (self.answerView as! YXAnswerSelectLettersView).textField.becomeFirstResponder()
    }
}
