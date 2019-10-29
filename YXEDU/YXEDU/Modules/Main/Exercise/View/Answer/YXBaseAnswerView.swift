//
//  YXExerciseAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXBaseAnswerViewDelegate: NSObject {
    /// 答题完成时，对错的结果回调
    /// - Parameter right: 是否答对
    func answerCompletion(_ exerciseModel: YXWordExerciseModel?, _ right: Bool)
}



class YXBaseAnswerView: UIView {
    
    /// 练习数据模型
    var exerciseModel: YXWordExerciseModel? {
        didSet {
            self.bindData()
        }
    }
    
    
    weak var answerDelegate: YXBaseAnswerViewDelegate?
    
    func bindData() { }
    
}
