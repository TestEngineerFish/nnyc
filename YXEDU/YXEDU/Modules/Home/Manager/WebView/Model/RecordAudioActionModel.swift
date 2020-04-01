//
//  RecordAudioActionModel.swift
//  SongShuAI
//
//  Created by sunwu on 2020/3/18.
//  Copyright © 2020 yx. All rights reserved.
//
import ObjectMapper

struct RecordAudioActionModel: Mappable {
    
    struct Question: Mappable {
        var id: String?
        var titleId: String?
        init?(map: Map) {
            self.mapping(map: map)
        }
        mutating func mapping(map: Map) {
            id      <- map["id"]
            titleId <- map["title_id"]
        }
    }
    
    
    var duration: Int = 0
    var type: Int = 0
    var question: Question?
    init?(map: Map) {
        self.mapping(map: map)
    }
    mutating func mapping(map: Map) {
        duration <- map["duration"]
        type     <- map["type"]
        question <- map["question"]
    }
    
}
