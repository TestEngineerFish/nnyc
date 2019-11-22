//
//  YXExerciseEvent.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

protocol YXQuestionEventProtocol {
//    /// 更新结果UI
//    /// - Parameter list: 错误对象ID列表
//    func showResult(errorList list: [Int])
//    func unselectQuestionLetter(_ tag: Int)
}

protocol YXAnswerEventProtocol {
    /// 点击答题区的按钮事件,
    /// - Parameter button: 点击的按钮
    /// - returns:  是否插入成功
    func selectedAnswerButton(_ button: YXLetterButton) -> Bool
    func unselectAnswerButton(_ button: YXLetterButton)
    func playAudio()
    func checkResult() -> (Bool, [Int])?
}
