//
//  YXExerciseRequest.swift
//  YXEDU
//
//  Created by sunwu on 2019/11/7.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

public enum YXExerciseRequest: YYBaseRequest {
    case exercise
}


extension YXExerciseRequest {
    var method: YYHTTPMethod {
        switch self {
            case .exercise:
                    return .post
            default:
                return .get
        }
    }
}

extension YXExerciseRequest {
    var path: String {
        switch self {
        case .exercise:
            return YXAPI.Word.exercise
        }
    }
}


extension YXExerciseRequest {
//    var parameters: [String : Any?]? {
//        switch self {
//        case .recommend:
//            
//        default:
//            return nil
//        }
//    }
    
//    var postJson: Any? {  }
}
