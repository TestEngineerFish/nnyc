//
//  YXNetworkManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/12.
//  Copyright © 2019 sunwu. All rights reserved.
//

import UIKit


/// 网络授权管理
class YXNetworkAuthManager: NSObject {
    
    static let `default` = YXNetworkAuthManager()
    
    var state: ZYNetworkAccessibleState?
    
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkChange(_:)), name: YXNotification.kNetworkAuth, object: nil)
    }
    
    func check() {
        ZYNetworkAccessibity.start()
        ZYNetworkAccessibity.setAlertEnable(true)
    }
    
    @objc func networkChange(_ notification: Notification) {
        
        self.state = ZYNetworkAccessibity.currentState()
        YXLog(state?.rawValue ?? -1, "网络权限变化")
    }
}
