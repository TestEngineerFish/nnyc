//
//  YXReviewPageModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/13.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

enum ReviewPlanState: Int {
    case normal     = 0 // 未开始
    case learning   = 1 // 进行中
    case finish     = 2 // 完成
}


class YXReviewPageModel: Mappable {

    var canMakeReviewPlans: Int = 0
    var learnNum: Int = 0
    var familiarNum: Int = 0
    var knowNum: Int = 0
    var fuzzyNum: Int = 0
    var forgetNum: Int = 0
    
    var reviewPlans: [YXReviewPlanModel]?
    
    required init?(map: Map) {
    }

    func mapping(map: Map) {
        canMakeReviewPlans <- map["is_can_artificial_review"]
        learnNum <- map["learn_num"]
        familiarNum <- map["familiar_num"]
        knowNum <- map["know_num"]
        fuzzyNum <- map["blur_num"]
        forgetNum <- map["forget_num"]
        reviewPlans <- map["list"]
    }
}


class YXReviewPlanModel: Mappable {
    
    var planId: Int = -1
    var planName: String = ""
    var listen: Int = 0
    var review: Int = 0
    var wordCount: Int = 0
    var reviewState: ReviewPlanState = .normal
    var listenState: ReviewPlanState = .normal

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        planId <- map["review_plan_id"]
        planName <- map["review_plan_name"]
        listen <- map["listen"]
        review <- map["review"]
        wordCount <- map["words_num"]
        reviewState <- (map["review_state"] , YXReviewPlanStateTransform())
        listenState <- (map["listen_state"] , YXReviewPlanStateTransform())
    }
}



struct YXReviewPlanStateTransform: TransformType {
        
    typealias Object = ReviewPlanState
    typealias JSON = Int
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> ReviewPlanState? {
        if let v = value as? Int, let state = ReviewPlanState(rawValue: v) {
            return state
        }
        return .normal
    }
    
    func transformToJSON(_ value: ReviewPlanState?) -> Int? {
        return value?.rawValue
    }

}
