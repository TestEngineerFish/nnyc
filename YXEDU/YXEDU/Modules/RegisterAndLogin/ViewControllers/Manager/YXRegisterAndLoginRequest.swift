//
//  YXRegisterAndLoginRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/18/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXRegisterAndLoginRequest: YYBaseRequest {
    case sendSms(phoneNumber: String, loginType: String, SlidingVerificationCode: String?)
    case login(phoneNumber: String, code: Int)
    case userInfomation
    
    var method: YYHTTPMethod {
        switch self {
        case .sendSms, .login:
            return .post
            
        case .userInfomation:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return YXAPI.RegisterAndLogin.login
            
        case .sendSms:
            return YXAPI.RegisterAndLogin.sendSms
            
        case .userInfomation:
            return YXAPI.Profile.userInformation
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .login(let phoneNumber, let code):
            return ["phone": phoneNumber, "code": code]
            
        case .sendSms(let phoneNumber, let loginType, let SlidingVerificationCode):
            if let SlidingVerificationCode = SlidingVerificationCode {
                return ["mobile": phoneNumber, "type": loginType, "slide_code": SlidingVerificationCode]

            } else {
                return ["mobile": phoneNumber, "type": loginType]
            }
            
        default:
            return nil
        }
    }
}
