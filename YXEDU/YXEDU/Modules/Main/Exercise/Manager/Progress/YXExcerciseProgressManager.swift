//
//  YXExcerciseProgressManager.swift
//  
//
//  Created by sunwu on 2019/10/28.
//

import UIKit

/// 练习进度管理器
class YXExcerciseProgressManager: NSObject {
    
    
    /// 是否存在学完，未上报的关卡
    class func isExistUnReport() -> Bool {
        return true
    }
    
    /// 是否存在未学完的关卡
    class func isExistUnCompletion() -> Bool {
        return false
    }
        
    
    /// 记录进度，每学习一个step
    class func addProgress() {
        
    }
    
    /// 对错判断
//    class func isRight() -> Bool {
//         return false
//    }
    
    /// 当前关卡是否学完
    class func isCompletion() -> Bool {
        return false
    }
    
}
