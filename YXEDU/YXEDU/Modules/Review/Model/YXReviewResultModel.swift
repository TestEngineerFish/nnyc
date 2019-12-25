//
//  YXReviewResultModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXReviewResultModel: Mappable {
    
    var type: YXExerciseDataType = .normal
    var planName: String?
    var allWordNum: Int = 0
    var knowWordNum: Int = 0
    var remainWordNum: Int = 0
    var score: Int = 0
    var studyDay: Int = 0
    var planState: ReviewPlanState = .normal
    var words: [YXWordModel]?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        planState <- (map["plan_status"] , YXReviewPlanStateTransform())
    }
    
}
