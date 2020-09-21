//
//  YYNetworkError.swift
//  YouYou
//
//  Created by pyyx on 2018/11/10.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import ObjectMapper

//
//enum YYErrorCode {
//    case 
//}



class YYNetworkError: NSObject {
    
    var code: Int?
    var message: String?
    var warning: String?
    
    init(codeDesc: Int, messageDesc: String?, warningDesc: String?) {
        code = codeDesc
        message = messageDesc
        warning = warningDesc
    }
}

extension NSError {

    /** Runtime关联Key*/
    private struct AssociatedKeys {
        static var customMessage: String = "kIsLargeTitle"
    }
    
    /**
     * 错误内容
     */
    var message: String {
        if let msg = customErrorMsg {
            return msg
        } else if let msg = self.userInfo[NSLocalizedDescriptionKey] as? String {
            return msg
        } else {
            return self.domain
        }
    }

    var customErrorMsg: String? {
        set (newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.customMessage, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.customMessage) as? String else {
                return nil
            }
            return value
        }
    }
}
