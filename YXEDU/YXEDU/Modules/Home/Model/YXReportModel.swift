//
//  YXReportModel.swift
//  YXEDU
//
//  Created by Jake To on 1/9/20.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXReportModel: Mappable {
    var description: String?
    var reportUrl: String?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        description <- map["content"]
        reportUrl <- map["report_url"]
    }
}
