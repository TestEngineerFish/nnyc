//
//  YXNotification.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXNotification {
    
    static let kNetwork = Notification.Name("kNetworkNotification") // 网络状态变化
    static let kNetworkAuth = NSNotification.Name.ZYNetworkAccessibityChanged   // 网络授权变化
    
    static let kServiceStop = NSNotification.Name("kServiceStopNotification")   // 停服
    
    static let kCloseWordDetailPage = NSNotification.Name("kCloseWordDetailPage")   // 详情页关闭的时候
    static let kCloseResultPage = NSNotification.Name("kCloseResultPage")   // 学习结果页关闭的时候
    static let kUpdatePlanName = NSNotification.Name("kUpdatePlanName")   // 
}
