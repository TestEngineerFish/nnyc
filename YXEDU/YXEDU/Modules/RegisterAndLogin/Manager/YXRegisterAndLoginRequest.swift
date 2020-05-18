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
    case login(platfrom: String, phoneNumber: String, code: String)
    case thirdLogin(platfrom: String, openId: String, code: String)
    case userInfomation
    case logout
    case SYGetPhoneNumber(token: String)
    case SYLogin(phoneNumber: String)

    var method: YYHTTPMethod {
        switch self {
        case .sendSms, .login, .logout, .thirdLogin:
            return .post
            
        case .userInfomation, .SYGetPhoneNumber, .SYLogin:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login, .thirdLogin:
            return YXAPI.RegisterAndLogin.login
            
        case .sendSms:
            return YXAPI.RegisterAndLogin.sendSms
            
        case .userInfomation:
            return YXAPI.Profile.userInformation
            
        case .logout:
            return YXAPI.RegisterAndLogin.logout
            
        case .SYGetPhoneNumber(let token):
            return YXAPI.RegisterAndLogin.SYGetPhoneNumber + token
            
        case .SYLogin(let phoneNumber):
            return YXAPI.RegisterAndLogin.SYLogin + phoneNumber
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        case .login(let platfrom, let phoneNumber, let code):
            return ["pf": platfrom, "mobile": phoneNumber, "code": code]
            
        case .thirdLogin(let platfrom, let openId, let code):
            return ["pf": platfrom, "openid": openId, "code": code]
            
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
