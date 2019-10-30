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
        let wordArray = ["e", "f", "u", "pdsss", "wddesa", "v", "m", "x"]
        
        answerView = YXAnswerSelectLettersView(wordArray)
        answerView?.exerciseModel = self.exerciseModel
        answerView?.answerDelegate = self
        self.addSubview(answerView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        answerView?.frame = CGRect(x: (screenWidth - 270) / 2, y: self.size.height - 200, width: 270, height: 200)
    }
    
    override func bindData() {
        
    }
    
}
