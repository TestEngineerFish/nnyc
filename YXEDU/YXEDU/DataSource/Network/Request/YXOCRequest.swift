//
//  YXOCRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/5/19.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

public enum YXOCRequest: YYBaseRequest {
    case getMonthlyInfo(time: Double)
    case getDayInfo(time: Double)
    case feedback(feed: String, env: String, file: Data?)
    case errorWordFeedback(wordId: String, word: String, content: String, type: String)
    case changeName(name: String)
    case changeAvatar(file: Data)
    case changeUserInfo(params: [String: String])

    public var method: YYHTTPMethod {
        switch self {
        case .getMonthlyInfo, .getDayInfo:
            return .get
            
        case .feedback, .errorWordFeedback, .changeName, .changeAvatar, .changeUserInfo:
            return .post
        }
    }
    
    public var path: String {
        switch self {
        case .getMonthlyInfo:
            return YXAPI.Calendar.getMonthly
            
        case .getDayInfo:
            return YXAPI.Calendar.getDayInfo
        
        case .feedback:
            return YXAPI.Other.feedback
            
        case .errorWordFeedback:
            return YXAPI.Other.errorWordFeedback
            
        case .changeName, .changeUserInfo:
            return YXAPI.Setting.setup
            
        case .changeAvatar:
            return YXAPI.Setting.setAvatar
        }
    }

    public var parameters: [String : Any?]? {
        switch self {
        case .feedback(let feed, let env, let file):
            if let file = file {
                return ["feed": feed, "env": env, "file": file]

            } else {
                return ["feed": feed, "env": env]
            }
            
        case .errorWordFeedback(let wordId, let word, let content, let type):
            return ["word_id": wordId, "word": word, "content": content, "type": type]
            
        case .changeName(let name):
            return ["nick": name]
            
        case .changeAvatar(let file):
            return ["file": file]
            
        case .changeUserInfo(let params):
            return [params.first?.key ?? "": params.first?.value ?? ""]
            
        case .getMonthlyInfo(let time):
            return ["time": time]
            
        case .getDayInfo(let params):
            return ["time": time]

        default:
            return nil
        }
    }
}
