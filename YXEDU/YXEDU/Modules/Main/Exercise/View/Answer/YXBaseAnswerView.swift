//
//  YXExerciseAnswerView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/24.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 答题视图相关协议方法
protocol YXAnswerViewDelegate: NSObjectProtocol {
    /// 答题完成时，对错的结果回调
    /// - Parameter right: 是否答对
    func answerCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool)
}



/// 答案视图基类，所有的答案区都需要继承自该类
class YXBaseAnswerView: UIView {
    
    /// 练习数据模型
    var exerciseModel: YXWordExerciseModel? {
        didSet {
            self.bindData()
        }
    }
    
    weak var answerDelegate: YXAnswerViewDelegate?
    
    func bindData() { }
    
    // 答题完成时，子类必须调用该方法
    func answerCompletion(right: Bool) {
        if let model = self.exerciseModel {
            self.answerDelegate?.answerCompletion(model, right)
        }
    }
}
