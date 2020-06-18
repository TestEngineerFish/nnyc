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
    case normal = -1
    /// 做错
    case wrong  = 0
    /// 做对
    case right  = 1
    
    static func getStatus(_ value: Int) -> YXStepStatus {
        switch value {
            case -1:
                return .normal
            case 0:
                return .wrong
            case 1:
                return .right
            default:
            return .normal
        }
    }
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
