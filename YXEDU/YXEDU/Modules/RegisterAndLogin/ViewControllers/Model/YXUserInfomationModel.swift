//
//  YXUserInfomationModel.swift
//  YXEDU
//
//  Created by Jake To on 12/25/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXUserInfomationModel: Mappable {
    struct YXReminderModel: Mappable {
        var didOpen: Int?
        var timeStamp: Double?
        
        init?(map: Map) {
            self.mapping(map: map)
        }
        
        mutating func mapping(map: Map) {
            didOpen <- map["is_open"]
            timeStamp <- map["time"]
        }
    }
    
    enum ReviewNameType: Int {
        case wordList = 0   // 词单
        case reviewPlan = 1 // 复习计划
    }
    enum ExerciseFillType: Int {
        case keyboard = 0 // 选择填空
        case choose   = 1 // 软键盘输入
    }
    var didBindPhone: Int?
    var didSelectBook: Int?
    var oldUserUpdateMessage: String?
    var coinExplainUrl: String?  //松果币H5文件
    var gameExplainUrl: String? //游戏挑战H5文件
    var reviewNameType: ReviewNameType = .reviewPlan //
    var fillType: ExerciseFillType = .choose
    var reminder: YXReminderModel?

    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        oldUserUpdateMessage <- map["old_user_update_msg"]
        didBindPhone         <- map["is_bind_mobile"]
        didSelectBook        <- map["is_selected_book"]
        coinExplainUrl       <- map["coin_explain_url"]
        gameExplainUrl       <- map["game_explain_url"]
        reviewNameType       <- (map["plan_execute_ab"], EnumTransform<ReviewNameType>())
        fillType             <- (map["spell_execute_ab"], EnumTransform<ExerciseFillType>())
        reminder <- map["learn_remind"]
    }
}
