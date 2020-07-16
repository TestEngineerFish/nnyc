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
    var type: YXLearnType = .base
    
    var planId: Int = 0
    var planName: String?
    var allWordNum: Int = 0
    var knowWordNum: Int = 0
    var remainWordNum: Int = 0
    var score: Int = 0
    var studyDay: Int = 0
    var isShowCoin = false
    /// 完成状态
    var state: Bool = false
    var words: [YXWordModel]?
    var sharedPeople: Int = 0
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        processStatus <- map["count_status"]
        state         <- map["plan_status"]
        type          <- (map["learn_type"], EnumTransform<YXLearnType>())
        planName      <- map["learn_name"]
        allWordNum    <- map["all_words_num"]
        knowWordNum   <- map["know_words_num"]
        remainWordNum <- map["remain_words_num"]
        score         <- map["score"]
        studyDay      <- map["study_day"]
        isShowCoin    <- map["is_show_coin"]
        words         <- map["list"]
        sharedPeople  <- map["which_people"]
    }
    
}



struct YXExerciseResultDisplayModel {
    /// 学习类型
    var type: YXLearnType = .base
    
    /// 完成状态
    var state: Bool = false
    
    var id: Int = 0
    var title: String?
    
    /// 所有的单词
    var allWordNum: Int = 0
        
    /// 新学的单词
    var newStudyWordNum: Int = 0
    
    /// 巩固的单词
    var reviewWordNum: Int = 0
    
    /// 掌握的单词（更好）
    var knowWordNum: Int = 0

    /// 剩余的单词
    var remainWordNum: Int = 0
        
    var score: Int = 0
    var studyDay: Int = 0
    var isShowCoin = false
    
    /// 需要加强的单词
    var words: [YXWordModel]?
    var unitList: [YXLearnMapUnitModel]?
    var sharedPeople: Int = 0

    /// 是否在活动时间内
    var isAction: Bool = false
    
    static func displayModel(model: YXReviewResultModel) -> YXExerciseResultDisplayModel {
        var displayModel = YXExerciseResultDisplayModel()
        displayModel.type = model.type
        displayModel.id = model.planId
        displayModel.title = model.planName
        displayModel.reviewWordNum = model.allWordNum
        displayModel.knowWordNum = model.knowWordNum
        displayModel.remainWordNum = model.remainWordNum
        displayModel.score = model.score
        displayModel.studyDay = model.studyDay
        displayModel.isShowCoin = model.isShowCoin
        displayModel.state = model.state
        displayModel.words = model.words
        displayModel.sharedPeople = model.sharedPeople
        return displayModel
    }
    
    static func displayModel(newStudyWordCount: Int, reviewWordCount: Int, model: YXLearnResultModel) -> YXExerciseResultDisplayModel {
        
        var displayModel = YXExerciseResultDisplayModel()
        displayModel.type = .base
        displayModel.title = model.unitName
        
        displayModel.allWordNum = model.allWordCount // 今日所学单词数
        displayModel.studyDay = model.studyDay  // 坚持多少天
        
        
        displayModel.newStudyWordNum = newStudyWordCount //新学
        displayModel.reviewWordNum = reviewWordCount //巩固

        displayModel.score = model.score
        
        displayModel.isShowCoin = model.isShowCoin
        displayModel.state      = model.status
        displayModel.unitList   = model.unitList
        displayModel.isAction   = model.isAction
        displayModel.sharedPeople = model.sharedPeople
        return displayModel
    }
}




struct YXLearnResultModel2: Mappable {
    enum CountStatusType: Int {
        case end, ing
    }
    var countStatus: CountStatusType?
    var unitList: [YXLearnMapUnitModel]?
    var allWordCount: Int     = 0
    var studyDay: Int         = 0
    var learnWordsNumber: Int = 0
    

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        countStatus      <- map["count_status"]
        allWordCount     <- map["all_words_num"]
        unitList         <- map["list"]
        studyDay         <- map["study_day"]
    }
}
