//
//  YXWrongWordListModel.swift
//  YXEDU
//
//  Created by Jake To on 12/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXWrongWordListModel: Mappable {
    var familiarList: [YXWordModel]? = []
    var recentWrongList: [YXWordModel]? = []
    var reviewList: [YXWordModel]? = []
    
    init() {}

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        familiarList <- map["familiar_list"]
        recentWrongList <- map["latest_list"]
        reviewList <- map["wait_list"]
    }
}
