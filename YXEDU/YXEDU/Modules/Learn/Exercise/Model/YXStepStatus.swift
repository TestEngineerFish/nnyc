//
//  YXStepStatus.swift
//  YXEDU
//
//  Created by sunwu on 2020/6/5.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

// Step 状态枚举
enum YXStepStatus: Int {
    /// 未做
    case normal = 0
    /// 做错
    case wrong  = 1
    /// 做对
    case right  = 2
}

/// 显示详情类型
enum YXShowWordDetailType: Int {
    /// 不显示
    case none = 0
    
    /// 做对进入详情
    case right  = 1
    
    /// 做错进详情
    case wrong  = 2
    
    /// 无论对错都进详情
    case all   = 3
    
}
