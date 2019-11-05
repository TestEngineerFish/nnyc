//
//  YXExerciseEvent.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


/// 答题协议
@objc protocol YXAnswerEvent {
        
    /// 选择图片答案
    @objc func chooseImageAnswer()
        
    /// 选择中文答案
    @objc func chooseChineseAnswer()
    
    // 选择英文答案
    @objc func chooseWordAnswer()
    
    // 选择正确答案
    @objc func chooseRightAnswer()
    
    // 连线答案
    @objc func connectAnswer()
}

protocol YXQuestionEventProtocol {
    func removeQuestionWord(_ tag: Int)
    func checkQuestionResult(errorList tags: [Int])
    /// 通过按钮的选中效果来播放和暂停
    func clickAudioButton(_ button: UIButton)
}

protocol YXAnswerEventProtocol {
    /// 点击答题区的按钮事件
    func selectedAnswerButton(_ button: YXLetterButton) -> Bool
    func unselectAnswerButton(_ button: YXLetterButton)
    func checkAnserResult()
    func switchQuestion()
}
