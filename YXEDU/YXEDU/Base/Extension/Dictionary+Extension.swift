//
//  Dictionary+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/1/17.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension Dictionary {
    func toJson() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []), let str = String(data: data, encoding: String.Encoding.utf8) else { return "" }
        return str
    }
}
