//
//  YXStudentModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/3/28.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXStudentListModel: Mappable  {
    var list: [YXStudentModel]?
    var hasMore = false
    
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        list <- map["list"]
        hasMore <- map["has_more"]
    }
}

struct YXStudentModel: Mappable  {
    var userInfo: YXStudentInfoModel?
    var learnInfo: YXStudentLearnModel?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        userInfo  <- map["user_info"]
        learnInfo <- map["plan_info"]
    }
}

struct YXStudentInfoModel: Mappable {

    var name: String = "--"
    var avatarUrl: String?
    var id: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name      <- map["nick"]
        avatarUrl <- map["avatar"]
        id        <- map["user_id"]
    }
}

struct YXStudentLearnModel: Mappable {

    var reviewState: ReviewPlanState = .normal
    var listenState: ReviewPlanState = .normal
    var reviewPlanId: Int = 0
    var reviewStar: Int   = 0
    var listenStar: Int   = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        reviewState  <- (map["review_state"], YXReviewPlanStateTransform())
        listenState  <- (map["listen_state"], YXReviewPlanStateTransform())
        reviewPlanId <- map["review_plan_id"]
        reviewStar   <- map["review"]
        listenStar   <- map["listen"]
    }
}
