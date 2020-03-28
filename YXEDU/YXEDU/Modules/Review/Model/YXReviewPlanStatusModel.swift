//
//  YXReviewPlanStatusModel.swift
//  YXEDU
//
//  Created by Jake To on 3/28/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

class YXReviewPlanStatusListModel: Mappable {
    var user: YXReviewPlanStatusUserModel?
    var reviewStatus: YXReviewPlanStatusInfoModel?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        user <- map["user_info"]
        reviewStatus <- map["plan_info"]
    }
}

class YXReviewPlanStatusUserModel: Mappable {
    var name: String?
    var avatarPath: String?

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        name <- map["nick"]
        avatarPath <- map["avatar"]
    }
}

class YXReviewPlanStatusInfoModel: Mappable {
    var reviewStars: Int?
    var reviewStatus:ReviewPlanState = .normal
    var listenStars: Int?
    var listenStatus: ReviewPlanState = .normal

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        reviewStars <- map["review"]
        reviewStatus <- (map["review_state"] , YXReviewPlanStateTransform())
        listenStars <- map["listen"]
        listenStatus <- (map["listen_state"] , YXReviewPlanStateTransform())
    }
}

