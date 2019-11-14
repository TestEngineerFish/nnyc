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
    /// - returns:  返回插入的位置
    func selectedAnswerButton(_ button: YXLetterButton) -> Int?
    func unselectAnswerButton(_ button: YXLetterButton)
    /// 更新结果UI
    /// - Parameter list: 错误对象ID列表
    func showResult(errorList list: [Int])
    func playAudio()
}
