//
//  YXVersionModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/22.
//  Copyright © 2019 shiji. All rights reserved.
//
import ObjectMapper

struct YXVersionModel: Mappable {
    
    enum UpdateState {
        case latest         // 最新
        case recommend      // 推荐更新
        case force          // 强制更新
    }
    
    var flag: Int = 0
    var forceFlag: Int = 0
    var url: String?
    var content: String?
    
    var state: UpdateState {
        if forceFlag == 1 {
            return .force
        }
        if flag == 1 {
            return .recommend
        }
        return .latest
    }
    
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        flag <- map["flag"]
        forceFlag <- map["force_flag"]
        url <- map["url"]
        content <- map["content"]
    }
}


struct YXReviewPlanCommandModel: Mappable {

    var userId: Int = -1
    var nickname: String?
    var planId: Int = 0
    var planName: String?
    var wordCount: Int = 0
    
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        userId <- map["user_info.user_id"]
        nickname <- map["user_info.nick"]
        planId <- map["review_plan_id"]
        planName <- map["share_plan_name"]
        wordCount <- map["review_word_num"]
    }
}


struct YXReviewPlanShareCommandModel: Mappable {
    var content: String?
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        content <- map["content"]
    }
}

