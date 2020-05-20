//
//  YXWordListModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/3.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXWordListModel: Mappable {

    var page: Int = 0
    var haveMore: Bool = false
    var total: Int = 0
    var unitName: String?
    var wordModelList: [YXWordModel] = []

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.page          <- map["page"]
        self.haveMore      <- map["has_more"]
        self.total         <- map["total"]
        self.unitName <- map["unit_name"]
        self.wordModelList <- map["list"]
    }
}
