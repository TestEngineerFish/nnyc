//
//  YXUserModel.swift
//  YXEDU
//
//  Created by Jake To on 10/29/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

struct YXUserModel: Codable {
    static let `default` = YXUserModel()
    private init() {}
    
    var username: String?
    var userAvatarPath: String?
    var integral: Int?

}
