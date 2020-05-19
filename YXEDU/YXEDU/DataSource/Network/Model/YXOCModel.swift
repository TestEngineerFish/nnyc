//
//  YXOCModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

@objc
class YXOCModel: NSObject, Mappable {

    @objc var summary: YXSummaryModel?

    required init?(map: Map) {}

    func mapping(map: Map) {
        summary <- map["summary"]
    }
}

@objc
class YXSummaryModel: NSObject, Mappable {

    @objc var days: Int     = 0
    @objc var words: Int    = 0
    @objc var duration: Int = 0

    required init?(map: Map) {}

    func mapping(map: Map) {
        days     <- map["study_days"]
        words    <- map["study_words"]
        duration <- map["study_duration"]
    }
}
