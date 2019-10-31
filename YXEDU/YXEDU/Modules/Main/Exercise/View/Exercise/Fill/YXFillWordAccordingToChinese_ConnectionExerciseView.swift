//
//  YXFillWordAccordingToChinese_ConnectionExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// /// 看中文填空，点击 + 连线两种操作
class YXFillWordAccordingToChinese_ConnectionExerciseView: YXBaseExerciseView {

    override func createSubview() {
        let word = "TableView"

        answerView = YXAnswerConnectionLettersView(exerciseModel: exerciseModel)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let answerViewW = self.exerciseModel.matix * (8 + 48) - 8
        let answerViewH = self.exerciseModel.matix * (8 + 48) - 8
        answerView?.snp.makeConstraints({ (make) in
            make.width.equalTo(answerViewW)
            make.height.equalTo(answerViewH)
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
        })
    }
    
}
