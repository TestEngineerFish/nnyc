//
//  YXExerciseAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXBaseAnswerView: UIView {
    
    /// 练习数据模型
    var exerciseModel: YXWordExerciseModel? {
        didSet {
            self.bindData()
        }
    }
        
    /// 答题完成时，对错的结果回调
    var answerCompletion: ((_ exerciseModel: YXWordExerciseModel?, _ right: Bool) -> Void)?
    
    
    func bindData() { }
    
}
