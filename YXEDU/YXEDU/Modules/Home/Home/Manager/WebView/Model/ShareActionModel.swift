//
//  RecordAudioActionModel.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/18.
//  Copyright © 2020 yx. All rights reserved.
//
import ObjectMapper

struct ShareActionModel: Mappable {

    enum YXWebShareType: Int {
        case wechat   = 1 // 微信
        case timeLine = 2 // 朋友圈
        case qq       = 3 // QQ
        case qzone    = 4 // QQ空间

        func getShareChannel() -> YXShareChannel {
            switch self {
            case .wechat:
                return .wechat
            case .timeLine:
                return .timeLine
            case .qq:
                return .qq
            case .qzone:
                return .qzone
            }
        }
    }
    var type: YXWebShareType = .wechat
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        type <- (map["type"], EnumTransform<YXWebShareType>())
    }
}
