//
//  YXUserModel.swift
//  YXEDU
//
//  Created by Jake To on 10/29/19.
//  Copyright © 2019 shiji. All rights reserved.
//

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

        if let gameExplainUrl = YYCache.object(forKey: "GameExplainUrl") as? String {
            self.gameExplainUrl = gameExplainUrl
        }

        if let coinExplainUrl = YYCache.object(forKey: "CoinExplainUrl") as? String {
            self.coinExplainUrl = coinExplainUrl
        }
        
        if let reviewNameType = YYCache.object(forKey: "YXReviewNameType") as? Int {
            self.reviewNameType = YXUserInfomationModel.ReviewNameType(rawValue: reviewNameType) ?? .reviewPlan
        }
    }
    
    var didLogin = false {
        didSet {
            YYCache.set(didLogin, forKey: "DidLogin")
        }
    }
    
    var didUseAmericanPronunciation = false {
        didSet {
            YYCache.set(didUseAmericanPronunciation, forKey: "DidUseAmericanPronunciation")
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

    var coinExplainUrl: String? {
        didSet {
            YYCache.set(coinExplainUrl, forKey: "CoinExplainUrl")
        }
    }

    var gameExplainUrl: String? {
        didSet {
            YYCache.set(gameExplainUrl, forKey: "GameExplainUrl")
        }
    }
    
    var reviewNameType: YXUserInfomationModel.ReviewNameType = .reviewPlan {
        didSet {
            YYCache.set(reviewNameType.rawValue, forKey: "YXReviewNameType")
        }
    }
    
    var didFinishDownloadAllStudyWordBooks = false

    func login() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
    
    @objc
    func updateToken(closure: ((_ result: Bool) -> Void)? = nil) {
        let request = YXHomeRequest.updateToken
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            if let date = response.data, let token = date.token, token.isEmpty == false {
                YXUserModel.default.token = token
                YXConfigure.shared().token = YXUserModel.default.token
                YXConfigure.shared().saveCurrentToken()

                closure?(true)
                
            } else {
                self.logout()
                closure?(false)
            }
            
        }) { error in
            print("❌❌❌\(error)")
            self.logout()
            closure?(false)
        }
    }
    
    @objc
    func logout() {
        self.didLogin = false
        YYCache.set(nil, forKey: "LastStoredDate")
        YYCache.set(nil, forKey: "LastStoreTokenDate")

        YXMediator().loginOut()
        
        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
