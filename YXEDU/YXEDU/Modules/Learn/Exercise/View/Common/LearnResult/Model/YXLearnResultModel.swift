//
//  YXLearnResultModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXLearnResultModel: Mappable {
    enum CountStatusType: Int {
        case end, ing
    }
    var countStatus: CountStatusType?
    var unitList: [YXLearnMapUnitModel]?
    
    /// 所学单词数
    var allWordCount: Int  = 0
    /// 天数
    var studyDay: Int      = 0
    var isShowCoin         = false
    ///新学单词数
    var learnWordsNum: Int = 0
    /// 复习单词数
    var reviewWordsNum: Int = 0
    var unitName: String?
    var score: Int         = 0
    var status: Bool       = false
    var isAction:Bool      = false
    var sharedPeople: Int  = 0
    var calendarStudyModelList: [YXCalendarStudyModel] = []
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        countStatus    <- map["count_status"]
        status         <- map["status"]
        unitName       <- map["unit_name"]
        allWordCount   <- map["all_words_num"]
        learnWordsNum  <- map["learn_words_num"]
        reviewWordsNum <- map["know_words_num"]
        isShowCoin     <- map["is_show_coin"]
        score          <- map["score"]
        unitList       <- map["list"]
        studyDay       <- map["study_day"]
        isAction       <- map["activity_clock_notice"]
        sharedPeople   <- map["which_people"]
        calendarStudyModelList <- map["study_detail"]
    }
}
