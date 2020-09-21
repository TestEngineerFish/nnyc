//
//  YXHomeworkDetailModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/8/18.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

struct YXHomeworkDetailModel: Mappable {
    var type: YXHomeworkType = .punch
    var className: String  = ""
    var workName: String   = ""
    var bookName: String   = ""
    var wordCount: Int     = 0
    var endDateStr: String = ""
    var learnDayCount: Int = 0
    var progress: Int      = 0
    var punchDayCount: Int = 0
    var learnWordCountWithDay: Int   = 0
    var wordModelList: [YXWordModel] = []
    var punchStatus: YXShareWorkStatusType     = .beExpiredFinished
    var otherStatus: YXExerciseWorkStatusTypes = .beExpiredFinished

    init?(map: Map) {}
    mutating func mapping(map: Map) {
        self.type          <- (map["type"], EnumTransform<YXHomeworkType>())
        self.bookName      <- map["book_name"]
        self.wordCount     <- map["word_num"]
        self.endDateStr    <- map["end_date"]
        self.learnDayCount <- map["learn_days"]
        self.className     <- map["class_name"]
        self.workName      <- map["work_name"]
        self.progress      <- map["progress"]
        self.punchDayCount <- map["clock_day_num"]
        self.punchStatus   <- (map["no_status"], EnumTransform<YXShareWorkStatusType>())
        self.otherStatus   <- (map["no_status"], EnumTransform<YXExerciseWorkStatusTypes>())
        self.wordModelList <- map["word_info"]
        self.learnWordCountWithDay <- map["average_word_num"]
    }
}
