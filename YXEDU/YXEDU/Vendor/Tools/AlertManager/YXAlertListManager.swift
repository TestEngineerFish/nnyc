//
//  YXAlertListManager.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/30.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXAlertWeightType {
    let stopService = 0         // A
    let updateVersion = 1       // B
    let oldUserTips = 2         // C
    let recommendUpdateVersion = 2  // C
    let scanCommand = 3             // D
    let latestBadge = 4         // E
}


class YXAlertListManager: NSObject {
    
    
    static var `default` = YXAlertListManager()
    
    private var alertArray: [YXTopWindowView] = []
    
    private override init() {}
    
    public func addAlert() {
        
    }
    
    
    public func showAlert() {
        
        var alertView: YXTopWindowView?
        for (i, alert) in alertArray.enumerated() {
            
            if alertView == nil {
                alertView = alert
            }
            
            if alert.tag < alertView.tag {
                alertView = alert
            }
            
        }
        
        alertView?.show()
        
    }
    
}
