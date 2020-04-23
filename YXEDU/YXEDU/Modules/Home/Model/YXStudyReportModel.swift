//
//  YXStudyReportModel.swift
//  YXEDU
//
//  Created by Jake To on 4/23/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXStudyReportModel: Mappable {

    var user: YXStudyReportUserModel?
    var registerDaysCount: Int?
    var date: TimeInterval?
    var studyDuration: Int?
    var newWordsCount: Int?
    var reviewWordsCount: Int?
    var studyResult: YXStudyReportResultModel?
    var studyContent: [YXStudyReportResultContentModel]?
    var studyAnaliysis: YXStudyReportResultAnaliysisModel?
    var studyBadge: [String]?

    var wordModelList: [YXWordModel] = []
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.user <- map["user_info"]
        self.registerDaysCount <- map["reg_day"]
        self.date <- map["current_date"]
        self.studyDuration <- map["study_duration"]
        self.newWordsCount <- map["new_word_num"]
        self.reviewWordsCount <- map["review_word_num"]
        self.studyResult <- map["study_fruits"]
        self.studyContent <- map["study_items"]
        self.studyAnaliysis <- map["study_analysis"]
        self.studyBadge <- map["badge"]
    }
    
    struct YXStudyReportUserModel: Mappable {
        var avatar: String?
        
        init?(map: Map) {}

        mutating func mapping(map: Map) {
            self.avatar <- map["avatar"]
        }
    }
    
    struct YXStudyReportResultAnaliysisModel: Mappable {
        var studyWordsCount: Int?
        var studyWordsCountPercent: Int?
        var studyDaysCount: Int?
        var studyDaysCountPercent: Int?

        init?(map: Map) {}

        mutating func mapping(map: Map) {
            self.studyWordsCount <- map["word_total"]
            self.studyWordsCountPercent <- map["word_ranking"]
            self.studyDaysCount <- map["clock_total"]
            self.studyDaysCountPercent <- map["clock_ranking"]
        }
    }
}

struct YXStudyReportResultModel: Mappable {
    var betterWords: [YXWordModel]?
    var improveWords: [YXWordModel]?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.betterWords <- map["know_word_list"]
        self.improveWords <- map["blur_word_list"]
    }
}

struct YXStudyReportResultContentModel: Mappable {
    var name: String?
    var count: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.count <- map["num"]
    }
}
