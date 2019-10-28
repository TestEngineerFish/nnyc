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


/// 更新View的约束
protocol YXViewConstraintsProtocol {
    func updateHeight(_ height: CGFloat)
}

protocol YXQuestionEventProtocol {
    func clickSpellView(_ word: String)// 等model确定了,替换成对应的model
    /// 通过按钮的选中效果来播放和暂停
    func clickAudioButton(_ button: UIButton)
}

protocol YXAnswerEventProtocol {
    /// 点击答题区的按钮事件
    func clickWordButton(_ button: UIButton)
}
