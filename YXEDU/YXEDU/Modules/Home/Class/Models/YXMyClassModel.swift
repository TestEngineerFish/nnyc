//
//  YXMyClassModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/23.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

enum YXHomeworkType: Int {
    /// 打卡
    case share  = 1
    /// 听写
    case listen = 2
    /// 单词练习
    case word   = 3
}

enum YXWorkCompletionStatus: Int {
    case normal   = 0
    case leanring = 1
    case finished = 2
}

enum YXShareWorkStatusType: Int {
    /// 未到期，当天未学习
    case unexpiredUnlearned      = 1
    /// 未到期，当天已学习，未打卡
    case unexpiredLearnedUnshare = 2
    /// 未到期，当前已学习，已打卡
    case unexpiredLearnedShare   = 3
    /// 已到期，总目标未完成
    case beExpiredUnfinished     = 4
    /// 已到期，总目标已完成
    case beExpiredFinished       = 5
}

enum YXExerciseWorkStatusTypes: Int {
    /// 未到期，未完成
    case unexpiredUnfinished = 1
    /// 未到期，已完成
    case unexpiredFinished   = 2
    /// 已到期，未完成
    case beExpiredUnfinished = 3
    /// 已到期，已完成
    case beExpiredFinished   = 4
}

struct YXMyClassModel: Mappable {

    var id: Int?
    var name: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id   <- map["class_id"]
        name <- map["class_name"]
    }
}

struct YXMyWorkModel: Mappable {

    var studentId: String?
    var workId: String?
    var classId: String?
    var type: YXHomeworkType = .share
    var status: YXWorkCompletionStatus = .normal
    var shareWorkStatus: YXShareWorkStatusType = .unexpiredUnlearned
    var exerciseWorkStatus: YXExerciseWorkStatusTypes = .unexpiredUnfinished
    var progress: CGFloat = 0
    var shareCount: Int   = 0
    var workName: String  = ""
    var className: String = ""
    var shareAmount: Int  = 0
    var timeStr: String   = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        studentId   <- map["student_id"]
        workId      <- map["work_id"]
        classId     <- map["class_id"]
        type        <- (map["type"], EnumTransform<YXHomeworkType>())
        status      <- (map["status"], EnumTransform<YXWorkCompletionStatus>())
        progress    <- map["progress"]
        shareCount  <- map["clock_day_num"]
        workName    <- map["work_name"]
        className   <- map["class_name"]
        shareAmount <- map["day_num"]
        timeStr     <- map["date_desc"]
        if type == .share {
            shareWorkStatus    <- (map["no_status"], EnumTransform<YXShareWorkStatusType>())
        } else {
            exerciseWorkStatus <- (map["no_status"], EnumTransform<YXExerciseWorkStatusTypes>())
        }
    }
}
