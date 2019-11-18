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
    case learnMap(bookID: Int)
}


extension YXExerciseRequest {
    var method: YYHTTPMethod {
        switch self {
        case .exercise:
            return .get
        case .learnMap:
            return .get
        }
    }
}

extension YXExerciseRequest {
    var path: String {
        switch self {
        case .exercise:
            return YXAPI.Word.exercise
        case .learnMap:
            return YXAPI.Word.learnMap
        }
    }
}


extension YXExerciseRequest {
    var parameters: [String : Any]? {
        switch self {
        case .learnMap(let bookID):
            return ["book_id" : bookID]
        default:
            return nil
        }
    }
}
