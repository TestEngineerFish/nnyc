//
//  RecordAudioActionModel.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/18.
//  Copyright © 2020 yx. All rights reserved.
//
import ObjectMapper

struct ShareActionModel: Mappable {
    var image: String?
    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        image <- map["image"]
    }
}
