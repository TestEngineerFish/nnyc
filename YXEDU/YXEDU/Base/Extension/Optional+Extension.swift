//
//  Optional+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/11/1.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

public extension Optional where Wrapped: Collection {
    /// 是否为空
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

}

