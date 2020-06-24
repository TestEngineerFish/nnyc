//
//  YXUserModel.swift
//  YXEDU
//
//  Created by Jake To on 10/29/19.
//  Copyright © 2019 shiji. All rights reserved.
//

class YXUserModel: NSObject {
    @objc static var `default` = YXUserModel()
    /// 当前用户UUID
    var uuid: String? {
        set {
            YYCache.set(newValue, forKey: "UserUUID")
        }
        get {
            return YYCache.object(forKey: "UserUUID") as? String
        }
    }
    /// 是否已登录
    var didLogin: Bool {
        set {
            YYCache.set(newValue, forKey: "DidLogin")
        }
        get {
            return YYCache.object(forKey: "DidLogin") as? Bool ?? false
        }
    }
    /// 当前用户是否使用美式发音
    var didUseAmericanPronunciation: Bool {
        set {
            YYCache.set(newValue, forKey: .didUseAmericanPronunciation)
        }
        get {
            return YYCache.object(forKey: .didUseAmericanPronunciation) as? Bool ?? false
        }
    }
    /// 用户Token
    var token: String? {
        set {
            YYCache.set(newValue, forKey: .userToken)
        }
        get {
            var _token = YYCache.object(forKey: .userToken) as? String
            // 兼容老版本
            if _token == nil || _token == .some("") {
                _token = UserDefaults.standard.string(forKey: "token")
            }
            return _token
        }
    }
    /// 用户名称
    var userName: String? {
        set {
            YYCache.set(newValue, forKey: .userName)
        }

        get {
            return YYCache.object(forKey: .userName) as? String
        }
    }
    var mobile: String? {
        set {
            YYCache.set(newValue, forKey: .mobile)
        }

        get {
            return YYCache.object(forKey: .mobile) as? String
        }
    }
    var time: String {
        get {
            return String(format: "%ld", Int(Date().timeIntervalSince1970))
        }
    }
    /// 用户头像地址
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
    /// 当前用户头像
    var userAvatarImage: UIImage? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentAvatarImage)
        }

        get {
            return YYCache.object(forKey: .currentAvatarImage) as? UIImage
        }
    }
    /// 金币使用、获取说明
    var coinExplainUrl: String? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.coinExplainUrl)
        }

        get {
            return YYCache.object(forKey: .coinExplainUrl) as? String
        }
    }
    /// 游戏挑战规则说明
    var gameExplainUrl: String? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.gameExplainUrl)
        }

        get {
            return YYCache.object(forKey: .gameExplainUrl) as? String
        }
    }
    /// 当前学习的年级
    var currentGrade: Int? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentGrade)
        }

        get {
            return YYCache.object(forKey: .currentGrade) as? Int
        }
    }
    /// 当前学习的书ID
    var currentBookId: Int? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.currentChooseBookId)
        }
        get {
            return YYCache.object(forKey: YXLocalKey.currentChooseBookId) as? Int
        }
    }
    /// 是否已加入班级
    var isJoinClass: Bool {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.isJoinClass)
        }
        get {
            return YYCache.object(forKey: YXLocalKey.isJoinClass) as? Bool ?? false
        }
    }
    /// 是否有新作业
    var hasNewWork: Bool {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.hasNewWork)
        }
        get {
            return YYCache.object(forKey: YXLocalKey.hasNewWork) as? Bool ?? false
        }
    }
    /// 最后一次主流程学习的时间
    var lastStoredDate: Date? {
        set {
            YYCache.set(newValue, forKey: YXLocalKey.lastStoredDate)
        }
        get {
            var _data =  YYCache.object(forKey: YXLocalKey.lastStoredDate) as? Date
            // 兼容老版本
            if _data == nil {
                _data = UserDefaults.standard.object(forKey: "LastStoredDate") as? Date
            }
            return _data
        }
    }

    func login() {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "YXTabBarViewController") as? UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
        
        self.didLogin = true
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
    func logout() {
        YXLog("推出前用户Token=====", YXUserModel.default.token ?? "")
        self.didLogin = false
        self.uuid     = nil
        // 停止资源管理器队列任务
        YXWordBookResourceManager.stop = true
        // 断开数据库连接
        YYDataSourceManager.default.close()
        YYDataSourceQueueManager.default.close()
        
        let storyboard = UIStoryboard(name:"RegisterAndLogin", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "YXRegistrationAndLoginNavigationController") as? UINavigationController
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
