//
//  YXCheckApp.swift
//  YXEDU
//
//  Created by sunwu on 2019/7/16.
//  Copyright © 2019 sunwu. All rights reserved.
//

import UIKit

enum YXPlatformType {
    case qq, qzone, wechatSession, wechatTimeLine
}

/// App 安装检测
struct YXCheckApp {
    static func canOpen(type: YXPlatformType) -> Bool {
        if type == .qq || type == .qzone {
            return TencentOAuth.iphoneQQInstalled() || TencentOAuth.iphoneTIMInstalled()
        }
        
        let appScheme = "wechat://"
        guard let url = URL(string: appScheme) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
    
    static func openApp(type: YXPlatformType) {
        var appScheme = "wechat://"
        if type == .qq || type == .qzone {
            appScheme = "mqq://"
        }
        
        guard let url = URL(string: appScheme) else {
            return
        }
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
        
    }
}
