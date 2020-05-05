//
//  YXExerciseConfig.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXExerciseConfig {
    static let headerViewHeight: CGFloat   = AdaptIconSize(28)
    static let headerViewTop: CGFloat      = AdaptIconSize(18) + kSafeBottomMargin
    static let questionViewTop: CGFloat    = AdaptSize(80) + kSafeBottomMargin
    static let answerViewBottom: CGFloat   = AdaptSize(86)
    static let exerciseViewTop: CGFloat    = AdaptSize(47) + kSafeBottomMargin
    static let exerciseViewBottom: CGFloat = AdaptIconSize(67) + kSafeBottomMargin
    static let exerciseViewHeight: CGFloat = screenHeight - YXExerciseConfig.exerciseViewTop - YXExerciseConfig.exerciseViewBottom
    /// 底部提示view距离边框底部的间距
    static let bottomViewBottom: CGFloat   = -kSafeBottomMargin
}
