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

struct YXShareImageListModel: Mappable {
    var imageUrlList = [YXShareImageModel]()
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        imageUrlList <- map["img_urls"]
    }
}

struct YXShareImageModel: Mappable {
    var name: Int            = 0
    var bgUrlStr: String     = ""
    var qrCodeUrlStr: String = ""

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name         <- (map["name"], IntTransform())
        bgUrlStr     <- (map["bg_url"], StringTransform())
        qrCodeUrlStr <- (map["qr_code_url"], StringTransform())
    }
}
