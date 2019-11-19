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
        
        if let currentLearningWordBookId = YYCache.object(forKey: "CurrentLearningWordBookId") as? Int {
            self.currentLearningWordBookId = currentLearningWordBookId
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
    
    var currentLearningWordBookId = 0 {
        didSet {
            YYCache.set(didLogin, forKey: "CurrentLearningWordBookId")
        }
    }
    
    var token: String?
    var uuid: String?
    var username: String?
    var userAvatarPath: String?
    var phoneNumber: String? 
    var integral: Int?

    func login() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
    
    @objc
    func logout() {
        self.didLogin = false
        
        YXMediator().loginOut()
        
        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
