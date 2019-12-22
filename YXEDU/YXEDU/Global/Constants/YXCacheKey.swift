//
//  YXCacheKey.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


enum YXLocalKey: String {
    case updateVersionTips = "kUpdateVersionTips" // 版本更新提示
    case kAlreadShowNewLearnGuideView = "kAlreadShowNewLearnGuideView"
    
    static func key(_ key: YXLocalKey) -> String {
        return "\(YXConfigure.shared().uuid ?? "")_" + key.rawValue
    }
}


