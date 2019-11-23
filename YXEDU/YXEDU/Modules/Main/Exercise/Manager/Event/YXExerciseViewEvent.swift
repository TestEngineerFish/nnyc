//
//  YXExerciseEvent.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit


protocol YXAnswerEventProtocol {
    /// 点击答题区的按钮事件,
    /// - Parameter button: 点击的按钮
    /// - returns:  是否插入成功
    func selectedAnswerButton(_ button: YXLetterButton) -> Bool
    func unselectAnswerButton(_ button: YXLetterButton)
    func playAudio()
    func checkResult() -> (Bool, [Int])?
}


