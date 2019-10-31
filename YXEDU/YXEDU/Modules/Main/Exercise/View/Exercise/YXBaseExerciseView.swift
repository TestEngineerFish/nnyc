//
//  YXBaseExerciseView.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/29.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 练习相关的协议
protocol YXExerciseViewDelegate: NSObjectProtocol {
    /// 练习完成
    /// - Parameter right: 是否答对
    func exerciseCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool)
}


/// 练习模块基类：内容主页面，包括题目View、答案View、TipsView
class YXBaseExerciseView: UIScrollView {

    var exerciseModel: YXWordExerciseModel? {
        didSet { self.bindData() }
    }
        
    /// 题目view
    var questionView: YXBaseQuestionView?
    
    /// 答案view
    var answerView: YXBaseAnswerView?
    
    weak var exerciseDelegate: YXExerciseViewDelegate?
    
    deinit {
        print("练习view 释放")
    }
    
    convenience init(exerciseModel: YXWordExerciseModel) {
        self.init(frame: CGRect.zero)
        self.exerciseModel = exerciseModel
        self.createSubview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()        
        self.contentSize = self.bounds.size
        
        self.questionView?.frame = CGRect(x: 0, y: 32, width: screenWidth, height: 150)
    }
    
    func createSubview() {}
        
    func bindData() {
        
    }
    
    
    /// 动画入场，动画从右边往左边显示出来
    func animateAdmission(_ first: Bool = false, _ completion: (() -> Void)?) {
        
        self.origin.x = screenWidth
        UIView.animate(withDuration: 0.4, delay: first ? 0.4 : 0.2, options: [], animations: {
            self.origin.x = 0
        }) { (finish) in
            if finish {
                completion?()
            }
        }
    }
    
    
    /// 动画出场
    func animateRemove() {
        UIView.animate(withDuration: 0.3, animations: {
            self.origin.x = -screenWidth
        }) { (finish) in
            if finish {
                self.removeFromSuperview()
            }
        }
    }
    
}


extension YXBaseExerciseView: YXAnswerViewDelegate {
    
    func answerCompletion(_ exerciseModel: YXWordExerciseModel, _ right: Bool) {
        self.exerciseDelegate?.exerciseCompletion(exerciseModel, right)
    }

}
