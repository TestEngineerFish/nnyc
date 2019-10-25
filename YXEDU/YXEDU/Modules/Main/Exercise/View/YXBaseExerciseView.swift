//
//  YXExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

/// 练习页面
class YXBaseExerciseView: UIView {
    
    

    var exerciseModel: YXWordExerciseModel?
//    var questionView: YXExerciseQuestionView?
//    var answerView: YXExerciseAnswerView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
