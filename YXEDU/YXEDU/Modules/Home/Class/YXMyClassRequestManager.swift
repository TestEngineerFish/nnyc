//
//  YXMyClassRequestManager.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/6/23.
//  Copyright © 2020 shiji. All rights reserved.
//


import Foundation

public enum YXMyClassRequestManager: YYBaseRequest {
    case workList
    case classList
    case classDetail(id: Int)
    case leaveClass(id: Int)
    case workReport(workId: Int)
    case remindHomework
    case notificationList(page: Int)
    case workDetail(id: Int)
}

extension YXMyClassRequestManager {
    var method: YYHTTPMethod {
        switch self {
        case .workList, .classList, .classDetail, .leaveClass, .workReport, .remindHomework, .notificationList, .workDetail:
            return .get
        }
    }
}

extension YXMyClassRequestManager {
    var path: String {
        switch self {
        case .workList:
            return YXAPI.MyClass.workList
        case .classList:
            return YXAPI.MyClass.classList
        case .classDetail:
            return YXAPI.MyClass.classDetail
        case .leaveClass:
            return YXAPI.MyClass.leaveClass
        case .workReport:
            return YXAPI.MyClass.workReport
        case .remindHomework:
            return YXAPI.MyClass.remindHomework
        case .notificationList:
            return YXAPI.MyClass.notificationList
        case .workDetail:
            return YXAPI.MyClass.workDetail
        }
    }
}

extension YXMyClassRequestManager {
    var parameters: [String : Any?]? {
        switch self {
        case .classDetail(let id):
            return ["class_id" : id]
        case .leaveClass(let id):
            return ["class_id" : id]
        case .workReport(let workId):
            return ["work_id" : workId]
        case .notificationList(let page):
            return ["page" : page]
        case .workDetail(let id):
            return ["work_id" : id]
        default:
            return nil
        }
    }
}
