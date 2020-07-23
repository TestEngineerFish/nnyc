//
//  Mappable+Transform.swift
//  LianLianLife
//
//  Created by luluyou on 17/2/10.
//  Copyright © 2017年 luluyou. All rights reserved.
//

import Foundation
import ObjectMapper

let transformIntToBool = TransformOf<Bool, Int>(fromJSON: { (value: Int?) -> Bool? in
    guard let _value = value else {
        return false
    }
    return _value > 0
    
}, toJSON: { (value: Bool?) -> Int? in
    guard let _value = value else {
        return 0
    }
    return _value ? 1 : 0
})

let transformInt = TransformOf<String, Int>(fromJSON: { (value: Int?) -> String? in
    if let _value = value {
        return String(_value)
    }
    return nil
}, toJSON: { (value: String?) -> Int? in
    if let _value = value {
        return Int(_value)
    }
    return nil
})

let transformString = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
    if let _value = value {
        return Int(_value)
    }
    return 0
}, toJSON: { (value: Int?) -> String? in
    if let _value = value {
        return String(_value)
    }
    return nil
})

let transformDouble = TransformOf<String, Double>(fromJSON: { (value: Double?) -> String? in
    if let value = value {
        return String(format: "%.2f", value)
    }
    return nil
}, toJSON: { (value: String?) -> Double? in
    guard let _value = value else {
        return .zero
    }
    return Double(_value)
})

let transformFloat = TransformOf<String, Float>(fromJSON: { (value: Float?) -> String? in
    if let value = value {
        return String(format: "%.2f", value)
    }
    return nil
}, toJSON: { (value: String?) -> Float? in
    guard let _value = value else {
        return .zero
    }
    return Float(_value)
})

let transformBool = TransformOf<String, Bool>(fromJSON: { (value: Bool?) -> String? in
    if let value = value {
        return String(value)
    }
    return nil
}, toJSON: { (value: String?) -> Bool? in
    guard let _value = value else {
        return false
    }
    return Bool(_value)
})
