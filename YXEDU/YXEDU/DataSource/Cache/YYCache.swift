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
    //MARK: String，缓存数据不区分用户
    static func set(_ object: Any?, forKey: String) {
        UserDefaults.standard.archive(object: object, forkey: forKey)
    }
    static func object(forKey: String) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey:forKey)
    }
    static func remove(forKey: String) {
        return set(nil, forKey: forKey)
    }
    
    
    //MARK: YXLocalKey，缓存数据会区分用户
    static func set(_ object: Any?, forKey: YXLocalKey) {
        UserDefaults.standard.archive(object: object, forkey: YXLocalKey.key(forKey))
    }
    static func object(forKey: YXLocalKey) -> Any? {
        return UserDefaults.standard.unarchivedObject(forkey:YXLocalKey.key(forKey))
    }
    static func remove(forKey: YXLocalKey) {
        return set(nil, forKey: YXLocalKey.key(forKey))
    }
    
}
