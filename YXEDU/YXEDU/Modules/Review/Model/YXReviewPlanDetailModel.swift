//
//  YXReviewPlanDetailModel.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/23.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

class YXReviewPlanDetailModel: YXReviewPageModel {

    var word: [YXWordModel]?

    override func mapping(map: Map) {
        word <- map["list"]
    }
}
