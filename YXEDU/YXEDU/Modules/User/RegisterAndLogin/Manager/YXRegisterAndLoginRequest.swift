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
    case bind(platfrom: String, phoneNumber: String, code: String)
    case bind2(platfrom: String, openId: String, code: String)
    case unbind(platfrom: String)
    case uploadAppInfo(clipboard: String, platform: String, systomVersion: String, screen: String)

    var method: YYHTTPMethod {
        switch self {
        case .sendSms, .login, .logout, .thirdLogin, .bind, .bind2, .unbind, .uploadAppInfo:
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
            
        case .bind:
            return YXAPI.RegisterAndLogin.bind
            
        case .bind2:
            return YXAPI.RegisterAndLogin.bind2
            
        case .unbind:
            return YXAPI.RegisterAndLogin.unbind

        case .uploadAppInfo:
            return YXAPI.RegisterAndLogin.upladAppInfo
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
            
        case .bind(let platfrom, let phoneNumber, let code):
            return ["pf": platfrom, "mobile": phoneNumber, "code": code]
            
        case .bind2(let platfrom, let openId, let code):
            return ["bind_pf": platfrom, "openid": openId, "code": code]
            
        case .unbind(let platfrom):
            return ["unbind_pf": platfrom]

        case .uploadAppInfo(let clipboard, let platform, let systomVersion, let screen):
            return ["clipboard" : clipboard, "platform" : platform, "system_version" : systomVersion, "screen" : screen]
            
        default:
            return nil
        }
    }
}
