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
    
    // 更換分享頁背景圖片地址
    var imageUrls: [String]?
    
    var credits: Int?

    /// 是否有还有下一组
    var hasNextGroup: Bool = false

    /// 二维码地址
    var imageUrlStr: String = ""
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        didCollectWord <- map["is_favorite"]
        token          <- map["token"]
        imageUrls      <- map["img_urls"]
        credits        <- map["userCredits"]
        hasNextGroup   <- map["is_next_group"]
        imageUrlStr    <- map["image_url"]
    }
}
