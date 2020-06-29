//
//  YXFillWordAccordingToListenExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 听录音填空
class YXFillWordAccordingToListenExerciseView: YXBaseExerciseView {

    override func createSubview() {
        questionView = YXListenAndLackWordQuestionView(exerciseModel: exerciseModel)
        self.addSubview(questionView!)
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        questionView?.addGestureRecognizer(tapAction)

        remindView = YXRemindView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(remindView!)

        answerView = YXAnswerSelectLettersView(exerciseModel: exerciseModel)
        self.scrollView.addSubview(answerView!)
        answerView?.delegate       = questionView
        answerView?.answerDelegate = self
        (answerView as! YXAnswerSelectLettersView).textField.showRemindButton { [weak self] (button) in
            self?.answerView?.answerCompletion(right: false)
            self?.remindView?.show()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.questionView?.audioPlayerView?.play()
        }
        super.createSubview()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionViewHeight = AdaptSize(isPad() ? 192 : 180)
    }

    override func bindData() {
        self.remindView?.remindSteps = [[.exampleWithDigWord, .image, .exampleAudio], [.soundmark, .wordAudio], [.detail]]
    }
    
    override func showAlertEvnet() {
        (self.answerView as! YXAnswerSelectLettersView).textField.resignFirstResponder()
    }
    
    override func hideAlertEvent() {
        self.showKeyboard()
    }
    
    // MAKR: --- Event ----
    @objc private func showKeyboard() {
        (self.answerView as! YXAnswerSelectLettersView).textField.becomeFirstResponder()
    }
}
