//
//  YXResultModel.swift
//  YXEDU
//
//  Created by Jake To on 12/16/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXResultModel: Mappable {
    // 是否收藏單詞
    var didCollectWord: Int?

    var token: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        didCollectWord <- map["is_favorite"]
        token <- map["token"]
    }
}
