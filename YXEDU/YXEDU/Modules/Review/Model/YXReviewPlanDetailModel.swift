//
//  YXReviewPlanDetailModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

class YXReviewPlanDetailModel: YXReviewPlanModel {
    var words: [YXWordModel]?
    
    var fromUser: String?

    override func mapping(map: Map) {
        super.mapping(map: map)
        words    <- map["list"]
        fromUser <- map["share_plan_name"]
    }
}

