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

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        state <- map["state"]
    }
}
