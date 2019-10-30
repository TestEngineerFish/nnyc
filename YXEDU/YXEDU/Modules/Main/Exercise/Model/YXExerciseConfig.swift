//
//  YXExerciseConfig.swift
//  YXEDU
//
//  Created by sunwu on 2019/10/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXExerciseConfig {
    static let headerViewHeight: CGFloat = 28
    
    static let headerViewTop: CGFloat = 18 + (iPhoneXLater ? 34 : 0)
    
    static let questionViewTop: CGFloat = 80 + (iPhoneXLater ? 34 : 0)
    
    static let answerViewBottom: CGFloat = 86
    
    static let contentViewTop: CGFloat = 45 + (iPhoneXLater ? 34 : 0)
    static let contentViewBottom: CGFloat = 86 + (iPhoneXLater ? 34 : 0)
    
    /// 底部提示view距离边框底部的间距
    static let bottomViewBottom: CGFloat = -19 - (iPhoneXLater ? 34 : 0)
}
