//
//  YXCacheKey.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


enum YXLocalKey: String {
    case updateVersionTips             = "kUpdateVersionTips" // 版本更新提示
    case oldUserVersionTips            = "kOldUserVersionTips" // 版本更新提示
    case alreadShowNewLearnGuideView   = "kAlreadShowNewLearnGuideView" // 显示学习引导图
    case alreadShowMakeReviewGuideView = "kAlreadShowMakeReviewGuideView" // 显示制作复习计划引导图
    case learningState                 = "kLearningState"      // 学习中状态
    case newFeedbackReply              = "newFeedbackReply"    // 反馈回复消息
    
}


extension YXLocalKey {
    /// 根据本地用户，创建新的Key，如果数据缓存不区分用户，可以直接使用，不用调用此方法
    /// - Parameter key: 标识
    static func key(_ key: YXLocalKey) -> String {
        return "\(YXConfigure.shared().uuid ?? "")_" + key.rawValue
    }
}
