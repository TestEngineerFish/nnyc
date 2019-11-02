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
    }
    
    var didLogin = false {
        didSet {
            YYCache.set(didLogin, forKey: "DidLogin")
        }
    }
    
    var token: String?
    var uuid: String?
    var username: String?
    var userAvatarPath: String?
    var phoneNumber: String? 
    var integral: Int?

    func login() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadMainPage()
    }
    
    @objc
    func logout() {        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loadRegistrationAndLoginPage(shouldShowShanYan: false)
    }
}
