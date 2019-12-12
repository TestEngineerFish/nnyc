//
//  YYNetworkService+Moniter.swift
//  lamantou
//
//  Created by sunwu on 2019/12/12.
//  Copyright © 2019 sunwu. All rights reserved.
//

import Foundation
import Alamofire

extension YYNetworkService {
    /** 是否有网络 */
    var isReachable: Bool {
        return networkManager?.isReachable ?? false
    }
    
    /** 判断网络权限 */
    var isAuth: Bool {
        let status = YXNetworkAuthManager.default.state
        if status == .restricted {
            return false
        }
        return true
    }
    
    var networkError: NSError {
        return NSError(domain: "没有网络", code: 0, userInfo: [NSLocalizedDescriptionKey : "网络不给力"])
    }
    
    var authError: NSError {
        return NSError(domain: "网络权限被关闭", code: 0, userInfo: [NSLocalizedDescriptionKey : ""])
//        return NSError(domain: "网络权限被关闭", code: 0, userInfo: [NSLocalizedDescriptionKey : "请到设置中开启网络权限"])
    }
    
    func startMonitorNetwork() {
        networkManager?.listener = { (status) in
            NotificationCenter.default.post(name: YXNotification.kNetwork, object: status)
            
            switch status {
            case .unknown, .notReachable:
                print("没有网络")
                
                UIView.toast("网络不给力")
                //YWAlertManager.showAlert(title: "网络问题", message: "请检查您的网络", actionTitle: "关闭", action: nil, completion: nil)
            case .reachable(let type):
                //                UIView.cleanTopWindow(anyClass: YYNetworkErrorAlertView.classForCoder())
                if type == .wwan {
                    print("手机网络")
                } else if type == .ethernetOrWiFi {
                    print("wifi网络")
                }
            }
        }
        networkManager?.startListening()
    }
    
    
    

}
