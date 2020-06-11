//
//  YXUserModel.swift
//  YXEDU
//
//  Created by Jake To on 10/29/19.
//  Copyright © 2019 shiji. All rights reserved.
//

class YXUserModel: NSObject {
    @objc static var `default` = YXUserModel()

    var uuid: String? {
        set {
            YYCache.set(newValue, forKey: "UserUUID")
        }
        get {
            return YYCache.object(forKey: "UserUUID") as? String
        }
    }

    var didLogin: Bool {
        set {
            YYCache.set(newValue, forKey: "DidLogin")
        }
        get {
            return YYCache.object(forKey: "DidLogin") as? Bool ?? false
        }
    }

    var didUseAmericanPronunciation: Bool {
        set {
            YYCache.set(newValue, forKey: .didUseAmericanPronunciation)
        }
        get {
            return YYCache.object(forKey: .didUseAmericanPronunciation) as? Bool ?? false
        }
    }

    var token: String? {
        set {
            YYCache.set(newValue, forKey: .userToken)
        }
        get {
            return YYCache.object(forKey: .userToken) as? String
        }
    }

    var userName: String? {
        set {
            YYCache.set(newValue, forKey: .userName)
        }

        get {
            return YYCache.object(forKey: .userName) as? String
        }
    }

    var userAvatarPath: String? {
        set {
            YYCache.set(newValue, forKey: .userAvatarPath)
            do {
                guard let url = URL(string: newValue ?? ""), let imageData = try? Data(contentsOf: url) else {
                    return
                }
                // 保存当前用户头像
                self.userAvatarImage = UIImage(data: imageData)
            }
        }

        get {
            return YYCache.object(forKey: .userAvatarPath) as? String
        }
    }

    var userAvatarImage: UIImage? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentAvatarImage)
        }

        get {
            return YYCache.object(forKey: .currentAvatarImage) as? UIImage
        }
    }

    var coinExplainUrl: String? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.coinExplainUrl)
        }

        get {
            return YYCache.object(forKey: .coinExplainUrl) as? String
        }
    }

    var gameExplainUrl: String? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.gameExplainUrl)
        }

        get {
            return YYCache.object(forKey: .gameExplainUrl) as? String
        }
    }

    var currentGrade: Int? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentGrade)
        }

        get {
            return YYCache.object(forKey: .currentGrade) as? Int
        }
    }
    
    var currentBookId: Int? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentChooseBookId)
        }
        get {
            return YYCache.object(forKey: YXLocalKey.currentChooseBookId) as? Int
        }
    }

    func login() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        
        self.didLogin = true
        YXWordBookResourceManager.stop = false
        // 登录后设置别名给友盟
        let alias = YXUserModel.default.uuid ?? ""
        UMessage.setAlias(alias, type: kUmengAliasType) { (response, error) in
            if let _error = error {
                YXLog("设置别名\(alias)失败, error: ", _error)
            } else {
                YXLog("设置别名\(alias)成功")
            }
        }
    }
    
    @objc
    func updateToken(closure: ((_ result: Bool) -> Void)? = nil) {
        let request = YXHomeRequest.updateToken
        YYNetworkService.default.request(YYStructResponse<YXResultModel>.self, request: request, success: { (response) in
            if let date = response.data, let token = date.token, token.isEmpty == false {
                YXUserModel.default.token  = token
                YXConfigure.shared().token = YXUserModel.default.token
                YXConfigure.shared().saveCurrentToken()

                closure?(true)
                
            } else {
                YXLog("更新Token失败，退出登录，token为空，data:", response)
                self.logout()
                closure?(false)
            }
            
        }) { error in
            YXLog("更新Token失败，退出登录，error：", error.message)
            self.logout()
            closure?(false)
        }
    }
    
    @objc
    func logout() {
        self.didLogin = false
        YYCache.set(nil, forKey: "LastStoredDate")
        YYCache.set(nil, forKey: "LastStoreTokenDate")
        YXUserModel.default.currentBookId = nil
        YXWordBookResourceManager.stop    = true
        YYDataSourceManager.default.close()
        YYDataSourceQueueManager.default.close()
        YXMediator().loginOut()
        
        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
