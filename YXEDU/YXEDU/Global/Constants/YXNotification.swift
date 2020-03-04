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
    
    static let kRefreshReviewTabPage = NSNotification.Name("kRefreshReviewTabPage")   // 刷新review tab页
    static let kRefreshReviewDetailPage = NSNotification.Name("kRefreshReviewDetailPage")   // 刷新review tab页
    
    static let kCloseWordDetailPage = NSNotification.Name("kCloseWordDetailPage")   // 详情页关闭的时候
    /// 更新反馈回复红点
    static let kUpdateFeedbackReplyBadge = NSNotification.Name("kUpdateFeedbackReplyBadge")
}
