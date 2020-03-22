//
//  YXNotification.swift
//  YXEDU
//
//  Created by sunwu on 2019/12/12.
//  Copyright © 2019 shiji. All rights reserved.
//

import UIKit

struct YXNotification {
    /// 网络状态变化
    static let kNetwork                  = Notification.Name("kNetworkNotification")
    /// 网络授权变化
    static let kNetworkAuth              = NSNotification.Name.ZYNetworkAccessibityChanged
    /// 停服
    static let kServiceStop              = NSNotification.Name("kServiceStopNotification")
    /// 刷新review tab页
    static let kRefreshReviewTabPage     = NSNotification.Name("kRefreshReviewTabPage")
    /// 刷新review tab页
    static let kRefreshReviewDetailPage  = NSNotification.Name("kRefreshReviewDetailPage")
    /// 详情页显示的时候
    static let kShowWordDetailPage       = NSNotification.Name("kShowWordDetailPage")
    /// 详情页关闭的时候
    static let kCloseWordDetailPage      = NSNotification.Name("kCloseWordDetailPage")
    /// 更新反馈回复红点
    static let kUpdateFeedbackReplyBadge = NSNotification.Name("kUpdateFeedbackReplyBadge")
    /// 更新任务中心小红点
    static let kUpdateTaskCenterBadge    = NSNotification.Name("kUpdateTaskCenterBadge")
    /// 跟读得分
    static let kRecordScore              = NSNotification.Name("kRecordScore")
    /// 播放松鼠动画
    static let kSquirrelAnimation        = NSNotification.Name("kSquirrelAnimation")
    
}
