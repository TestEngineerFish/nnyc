//
//  YXShareRequest.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/31.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


public enum YXShareRequest: YYBaseRequest {
    case punch(type: Int, bookId: Int, learnType: Int) // 1 分享到qq 2 分享到微信好友 3分享到朋友圈
    case changeBackgroundImage(type: Int)
    case getQRCode
    case getActivityShareImage

    var method: YYHTTPMethod {
        switch self {
        case .punch:
            return .post
        case .changeBackgroundImage, .getQRCode, .getActivityShareImage:
            return .get
        }
    }

    var path: String {
        switch self {
        case .punch:
            return YXAPI.Share.punch
        case .changeBackgroundImage:
            return YXAPI.Share.changeBackgroundImage
        case .getQRCode:
            return YXAPI.Share.getQRCode
        case .getActivityShareImage:
            return YXAPI.Share.getActivityShareImage
        }
    }

    public var parameters: [String : Any?]? {
        switch self {
        case .punch(let type, let bookId, let learnType):
            return ["type" : type, "book_id" : bookId, "learn_type" : learnType]
        case .changeBackgroundImage(let type):
            return ["type" : type]
        default:
            return nil
        }
    }
}


