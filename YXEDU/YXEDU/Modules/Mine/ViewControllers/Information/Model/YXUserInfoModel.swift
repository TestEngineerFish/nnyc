//
//  YXUserInfoModel.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/7/30.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

struct YXUserInfoModel {
    var title: String
    var detail: String
    init(title:String? = nil, detail: String? = nil) {
        self.title  = title ?? ""
        self.detail = detail ?? ""
    }
}
