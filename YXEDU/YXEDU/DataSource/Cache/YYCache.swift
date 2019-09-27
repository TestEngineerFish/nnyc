//
//  YYCache.swift
//  YouYou
//
//  Created by sunwu on 2018/11/28.
//  Copyright © 2018 YueRen. All rights reserved.
//

import UIKit

/**
 * 全局统一缓存数据管理器
 */
struct YYCache {
    
    static func set(_ object: Any?, forKey: String) {
        UserDefaults.standard.archive(object: object, forkey: forKey)
    }
    
    static func object(forKey: String) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey:forKey)
    }
    
    
    static func remove(forKey: String) {
        return set(nil, forKey: forKey)
    }
    
}
