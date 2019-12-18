//
//  YXTaskCenterRequest.swift
//  YXEDU
//
//  Created by Jake To on 12/17/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXTaskCenterRequest: YYBaseRequest {
    case punchIn
    case punchData
    case taskList
    case getIntegral(taskId: Int)

    var method: YYHTTPMethod {
        switch self {
        case .punchData, .taskList, .getIntegral:
            return .get
            
        case .punchIn:
            return .post
        }
    }

    var path: String {
        switch self {
        case .punchIn:
            return YXAPI.TaskCenter.punchIn
            
        case .punchData:
            return YXAPI.TaskCenter.punchData
            
        case .taskList:
            return YXAPI.TaskCenter.taskList
            
        case .getIntegral:
            return YXAPI.TaskCenter.getIntegral
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getIntegral(let taskId):
            return ["task_id": taskId]
            
        default:
            return nil
        }
    }
}
