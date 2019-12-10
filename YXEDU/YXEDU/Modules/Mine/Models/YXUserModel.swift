//
//  YXUserModel.swift
//  YXEDU
//
//  Created by Jake To on 10/29/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation

class YXUserModel: NSObject {
    @objc static var `default` = YXUserModel()

    private override init() {
        if let didLogin = YYCache.object(forKey: "DidLogin") as? Bool {
            self.didLogin = didLogin
        }
        
        if let didUseAmericanPronunciation = YYCache.object(forKey: "DidUseAmericanPronunciation") as? Bool {
            self.didUseAmericanPronunciation = didUseAmericanPronunciation
        }
        
        if let token = YYCache.object(forKey: "UserToken") as? String {
            self.token = token
        }
        
        if let uuid = YYCache.object(forKey: "UserUUID") as? String {
            self.uuid = uuid
        }
        
        if let username = YYCache.object(forKey: "UserName") as? String {
            self.username = username
        }
        
        if let userAvatarPath = YYCache.object(forKey: "UserAvatarPath") as? String {
            self.userAvatarPath = userAvatarPath
        }
    }
    
    var didLogin = false {
        didSet {
            YYCache.set(didLogin, forKey: "DidLogin")
        }
    }
    
    var didUseAmericanPronunciation = false {
        didSet {
            YYCache.set(didLogin, forKey: "DidUseAmericanPronunciation")
        }
    }
    
    var token: String? {
        didSet {
            YYCache.set(token, forKey: "UserToken")
        }
    }
    
    var uuid: String? {
        didSet {
            YYCache.set(uuid, forKey: "UserUUID")
        }
    }
    
    var username: String? {
        didSet {
            YYCache.set(username, forKey: "UserName")
        }
    }
    
    var userAvatarPath: String? {
        didSet {
            YYCache.set(userAvatarPath, forKey: "UserAvatarPath")
        }
    }

    func login() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        
        tabBarController?.selectedIndex = 2
    }
    
    @objc
    func logout() {
        self.didLogin = false
        YYCache.set(nil, forKey: "LastStoredDate")
        
        YXMediator().loginOut()
        
        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
