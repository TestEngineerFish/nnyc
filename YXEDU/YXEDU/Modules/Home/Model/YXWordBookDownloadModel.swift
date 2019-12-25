//
//  YXWordBookDownloadModel.swift
//  YXEDU
//
//  Created by Jake To on 12/24/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXWordBookDownloadModel: Mappable {
    var id: Int?
    var hash: String?
    var downloadUrl: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["book_id"]
        hash <- map["book_hash"]
        downloadUrl <- map["book_url"]
    }
}
