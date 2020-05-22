//
//  YXReviewDataManager+AB.swift
//  YXEDU
//
//  Created by sunwu on 2020/3/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YXReviewDataManager {
    
    static func makePlanName(defailt: String) -> String {
        return "我的词单\(planNameIndex)"
    }
    
    
    static var planNameIndex: Int {
        if var index = YYCache.object(forKey: .makePlanNameIndex) as? Int {
            index += 1
            YYCache.set(index, forKey: .makePlanNameIndex)
            return index
        } else {
            YYCache.set(1, forKey: .makePlanNameIndex)
            return 1
        }
    }
    
    
}
