//
//  YXReviewDataManager+AB.swift
//  YXEDU
//
//  Created by sunwu on 2020/3/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import UIKit

extension YXReviewDataManager {
//    static var reviewPlanName: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "复习计划" : "词单"
//    }
//
//    static var tabReviewName: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "复习" : "词单"
//    }
//
//    static var reviewPlanTitle: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "复习计划" : "我的词单"
//    }
    
//    static var startStudy: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "开始复习" : "开始学习"
//    }
//
//    static var continueStudy: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "继续复习" : "继续学习"
//    }
//
//    static var continueStudy2: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "巩固复习" : "继续学习"
//    }
        
//    static var makePlanName_Button: String {
//        return YXUserModel.default.reviewNameType == .reviewPlan ? "制定复习计划" : "新建词单"
//    }
    
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
