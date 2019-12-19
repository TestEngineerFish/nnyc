//
//  YXSlidingVerificationCodeModel.swift
//  YXEDU
//
//  Created by Jake To on 12/18/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import ObjectMapper

struct YXSlidingVerificationCodeModel: Mappable {
    var shouldShowSlidingVerification: Int?
    var slidingVerificationCode: String?
    var isSuccessSendSms: Int?

    
    init?(map: Map) {
        self.mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        shouldShowSlidingVerification <- map["start_slide"]
        slidingVerificationCode <- map["slide_code"]
        isSuccessSendSms <- map["is_send_success"]
    }
}
