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
    case punch  = 1
    /// 听写
    case listen = 2
    /// 单词练习
    case word   = 3

    func learnType() -> YXLearnType {
        switch self {
        case .punch:
            return .homeworkPunch
        case .listen:
            return .homeworkListen
        case .word:
            return .homeworkWord
        }
    }
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
    var isNew: Bool  = false

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        id   <- map["class_id"]
        name <- map["class_name"]
    }
}

struct YXMyWorkListModel: Mappable {
    var bookHash: [String:String]      = [:]
    var workModelList: [YXMyWorkModel] = []
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        bookHash      <- map["hashkey"]
        workModelList <- map["list"]
    }
}

struct YXMyWorkModel: Mappable {

    var studentId: Int?
    var workId: Int?
    var classId: Int?
    var type: YXHomeworkType = .punch
    var status: YXWorkCompletionStatus = .normal
    var shareWorkStatus: YXShareWorkStatusType = .unexpiredUnlearned
    var exerciseWorkStatus: YXExerciseWorkStatusTypes = .unexpiredUnfinished
    var progress: CGFloat = 0
    var shareCount: Int   = 0
    var workName: String  = ""
    var className: String = ""
    var shareAmount: Int  = 0
    var timeStr: String   = ""
    var bookIdList        = [Int]()
    var unitId: Int       = 0
    var studyWordCount    = 0
    var studyDayCount     = 0
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
        bookIdList  <- map["book_id_list"]
        unitId      <- map["unit_id"]
        studyWordCount <- map[""]
        studyDayCount  <- map[""]
        if type == .punch {
            shareWorkStatus    <- (map["no_status"], EnumTransform<YXShareWorkStatusType>())
        } else {
            exerciseWorkStatus <- (map["no_status"], EnumTransform<YXExerciseWorkStatusTypes>())
        }
    }
}

struct YXMyClassDetailModel: Mappable {

    var code: String       = ""
    var className: String  = ""
    var schoolName: String = ""
    var studentCount: Int  = 0
    var studentModelList   = [YXMyClassStudentInfoModel]()

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        code             <- map["class_code"]
        className        <- map["class_name"]
        schoolName       <- map["school_name"]
        studentCount     <- map["count_student"]
        studentModelList <- map["student_info"]
    }
}

struct YXMyClassStudentInfoModel: Mappable {

    var name: String      = ""
    var avatarUrl: String = ""
    var studentId: Int    = 0
    var learnCount: Int   = 0
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name       <- map["nick"]
        avatarUrl  <- map["avatar"]
        studentId  <- map["student_id"]
        learnCount <- map["study_day"]
    }
}

struct YXMyClassReportModel: Mappable {
    var studentName: String = ""
    var grade: String = ""
    var accuracy: Int = 0
    var finishedTime: String = ""
    var wordModelList = [YXMyClassReportWordModel]()
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        studentName   <- map["student_name"]
        grade         <- map["grade"]
        accuracy      <- map["accuracy"]
        finishedTime  <- map["finish_work_date"]
        wordModelList <- map["list"]
    }
}

struct YXMyClassReportWordModel: Mappable {
    var word: String = ""
    var paraphrase: YXWordPartOfSpeechAndMeaningModel?
    var meanWrongCount: Int   = 0
    var spellWrongCount: Int  = 0
    var listenWrongCount: Int = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        word             <- map["word"]
        paraphrase       <- map["paraphrase"]
        meanWrongCount   <- map["word_mean_error"]
        spellWrongCount  <- map["write_error"]
        listenWrongCount <- map["listen_error"]
    }

    func wrongTextList() -> [String] {
        var textList = [String]()
        if meanWrongCount > 0 {
            textList.append("词义错\(meanWrongCount)次")
        }
        if spellWrongCount > 0 {
            textList.append("拼写错\(spellWrongCount)次")
        }
        if listenWrongCount > 0 {
            textList.append("听音错\(listenWrongCount)次")
        }
        return textList
    }
}

struct YXMyClassRemindModel: Mappable {

    var teacherName: String = ""
    var workName: String    = ""
    var workId: Int         = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        teacherName <- map["nick"]
        workName    <- map["work_name"]
        workId      <- map["work_id"]
    }
}
