//
//  Date+Extension.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/4/27.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation

extension Date {
    func local() -> Date {
        guard let zone = TimeZone(identifier: "Asia/Shanghai") else {
            return self
        }
        let interval = zone.secondsFromGMT(for: self)
        return self.addingTimeInterval(Double(interval))
    }

    /// 获得*分钟后的时间
    func offsetMinutes(minutes: Int) -> Date? {
        let gregorian = Calendar(identifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.minute = minutes
        let result = gregorian.date(byAdding: offsetComponents, to: self)
        return result
    }
}
