//
//  YXStepConfigModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/21.
//  Copyright © 2020 shiji. All rights reserved.
//

import ObjectMapper

struct YXStepConfigModel: Mappable {
    var hash: String = ""
    var stepList     = [YXStepModel]()

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        hash     <- map["hash"]
        stepList <- map["step_list"]
    }
}

struct YXStepModel: Mappable {
    var step: Int = 0
    var wordIdList: Set<Int> = []
    var tmpList: [Int] = [] {
        didSet {
            self.wordIdList = Set(tmpList)
        }
    }

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        step    <- map["step"]
        tmpList <- map["word_ids"]
    }
}
