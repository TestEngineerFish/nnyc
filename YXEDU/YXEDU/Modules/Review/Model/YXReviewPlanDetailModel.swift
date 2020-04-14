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

class YXResetReviewPlanModel: Mappable {

    var isSuccess = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        self.isSuccess <- map["is_success"]
    }
}

