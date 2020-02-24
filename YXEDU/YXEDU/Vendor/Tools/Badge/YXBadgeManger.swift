//
//  YXBadgeManger.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/2/22.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

class YXBadgeManger: NSObject {
    
    static let share = YXBadgeManger()
    
    var mineBadge: Int     = 0
    var feedbackBadge: Int = 0
    let kHasNewFeedbackMsg = "hasNewFeedbackMsg"
    
    func updateMineBadge(_ num: Int) {
        YYCache.set(num, forKey: kHasNewFeedbackMsg)
    }
    
    func getFeedbackBadgeNum() -> Int {
        guard let badgeNum = YYCache.object(forKey: kHasNewFeedbackMsg) as? Int else {
            return 0
        }
        return badgeNum
    }
    
}
