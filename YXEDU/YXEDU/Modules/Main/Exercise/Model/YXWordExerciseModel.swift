//
//  YXExerciseWordModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

class YXWordExerciseModel: NSObject {
    var type: YXExerciseType = .none
    // 题目: 填空题
    var wordArray = [String]()
    // 答题:填空题,选择字母
    var charModelArray = [YXCharacterModel]()
    // 答题: 连词
    var matix: Int = 0
    var word: String = "Notification"
    var subTitle = "n.咖啡"
    init(_ type: YXExerciseType = .none) {
        super.init()
        self.type = type
    }
}
