//
//  YXReviewResultModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/25.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXReviewResultModel: Mappable {
    
    /// 统计状态
    var processStatus: Bool = false
    
    /// 学习类型
    var type: YXExerciseDataType = .base
    
    var planId: Int = 0
    var planName: String?
    var allWordNum: Int = 0
    var knowWordNum: Int = 0
    var remainWordNum: Int = 0
    var score: Int = 0
    var studyDay: Int = 0
    
    /// 完成状态
    var state: Bool = false
    var words: [YXWordModel]?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        processStatus <- map["count_status"]
        state <- map["plan_status"]
        type <- (map["learn_type"], EnumTransform<YXExerciseDataType>())
        planName <- map["learn_name"]
        allWordNum <- map["all_words_num"]
        knowWordNum <- map["know_words_num"]
        remainWordNum <- map["remain_words_num"]
        score <- map["score"]
        studyDay <- map["study_day"]
        words <- map["list"]
    }
    
}
