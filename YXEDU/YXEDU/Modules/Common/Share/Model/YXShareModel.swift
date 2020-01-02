//
//  YXShareModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

struct YXShareModel: Mappable {

    var state: Bool = true
    var coin: Int   = 0

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        state <- map["state"]
        coin  <- map["credits"]
    }
}
