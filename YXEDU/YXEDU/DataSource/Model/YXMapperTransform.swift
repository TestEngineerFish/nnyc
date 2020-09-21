//
//  YXMapperTransform.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2020/9/10.
//  Copyright © 2020 shiji. All rights reserved.
//

import Foundation
import ObjectMapper

open class DateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON   = Double

    public init() {}

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let timeInt = value as? Double {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        } else if let timeStr = value as? String, let timeInt = Int(timeStr) {
            return Date(timeIntervalSince1970: TimeInterval(timeInt))
        } else {
            return nil
        }
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let date = value {
            return Double(date.timeIntervalSince1970)
        } else {
            return nil
        }
    }
}

open class IntTransform: TransformType {
    public typealias Object = Int
    public typealias JSON   = Int

    public init() {}

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let valueInt = value as? Int {
            return valueInt
        } else if let valueStr = value as? String {
            return Int(valueStr)
        } else {
            return nil
        }
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let valueInt = value {
            return valueInt
        } else {
            return nil
        }
    }
}

open class StringTransform: TransformType {
    public typealias Object = String
    public typealias JSON   = String

    public init() {}

    public func transformFromJSON(_ value: Any?) -> Object? {
        if let valueStr = value as? String {
            return valueStr
        } else if let valueNumber = value as? NSNumber {
            return "\(valueNumber)"
        } else {
            return nil
        }
    }

    public func transformToJSON(_ value: Object?) -> JSON? {
        if let valueStr = value {
            return valueStr
        } else {
            return nil
        }
    }
}
