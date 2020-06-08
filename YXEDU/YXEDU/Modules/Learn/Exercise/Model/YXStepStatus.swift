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
    
    /// 跳过
    case skip   = 3
    
    static func getStatus(_ value: Int) -> YXStepStatus {
        switch value {
            case 0:
                return .normal
            case 1:
                return .wrong
            case 2:
                return .right
            case 3:
                return .skip
            default:
            return .normal
        }
    }
}
