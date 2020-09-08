//
//  YXBaseLearnResultModel.swift
//  YXEDU
//
//  Created by sunwu on 2020/9/8.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXBaseLearnResultModel: Mappable {
    enum CountStatusType: Int {
        case end, ing
    }
    var countStatus: CountStatusType?
    
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
    
    var studyList: [YXStudyModel] = []
    var unit: YXUnitModel?
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        countStatus   <- map["count_status"]
        status        <- map["status"]
        unitName      <- map["unit_name"]
        allWordCount  <- map["all_words_num"]
        learnWordsNum <- map["learn_words_num"]
        reviewWordsNum <- map["know_words_num"]
        isShowCoin    <- map["is_show_coin"]
        score         <- map["score"]
        
        studyDay      <- map["study_day"]
        isAction      <- map["activity_clock_notice"]
        sharedPeople  <- map["which_people"]
        
        studyList     <- map["study_detail"]
        unit          <- map["unit_data"]
    }
    
    
    
    struct YXStudyModel: Mappable {
        var date: Int  = 0
        var status: Int = 0
        
        init?(map: Map) {}

        mutating func mapping(map: Map) {
            date   <- map["date"]
            status   <- map["status"]
        }
    }
    
    
    
    struct YXUnitModel: Mappable {
        var unitId = 0
        var unitName = ""
        var wordsNum = 0
        var bookId = 0
        var rate = 0.5      //单元进度
        var stars = 0       //单元学完后获得的星数0|1|2|3，默认为0
        var status = 0      //0-未学 1-学习中 2-完成
        var countStatus = 0 //统计状态，1：正在统计，0：统计完成
        
        init?(map: Map) {}

        mutating func mapping(map: Map) {
            unitId   <- map["unit_id"]
            unitName   <- map["unit_name"]
            wordsNum   <- map["words_num"]
            bookId   <- map["book_id"]
            rate   <- map["rate"]
            stars   <- map["stars"]
            status   <- map["status"]
            countStatus   <- map["count_status"]

        }
    }

}





