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
    static let kNetwork                    = Notification.Name("kNetworkNotification")
    /// 网络授权变化
    static let kNetworkAuth                = NSNotification.Name.ZYNetworkAccessibityChanged
    /// 停服
    static let kServiceStop                = NSNotification.Name("kServiceStopNotification")
    /// 刷新review tab页
    static let kRefreshReviewTabPage       = NSNotification.Name("kRefreshReviewTabPage")
    /// 刷新review tab页
    static let kRefreshReviewDetailPage    = NSNotification.Name("kRefreshReviewDetailPage")
    /// 详情页显示的时候
    static let kShowWordDetailPage         = NSNotification.Name("kShowWordDetailPage")
    /// 点击【提示一下】按钮
    static let kClickTipsButton            = NSNotification.Name("kClickTipsButton")
    /// 详情页关闭的时候
    static let kCloseWordDetailPage        = NSNotification.Name("kCloseWordDetailPage")
    /// 更新反馈回复红点
    static let kUpdateFeedbackReplyBadge   = NSNotification.Name("kUpdateFeedbackReplyBadge")
    /// 领取任务
    static let kCompletedTask              = NSNotification.Name("kCompletedTask")
    /// 更新任务中心小红点
    static let kUpdateTaskCenterBadge      = NSNotification.Name("kUpdateTaskCenterBadge")
    /// 跟读得分
    static let kRecordScore                = NSNotification.Name("kRecordScore")
    /// 播放松鼠动画
    static let kSquirrelAnimation          = NSNotification.Name("kSquirrelAnimation")
    /// 分享结果
    static let kShareResult                = NSNotification.Name("kShareResult")
    /// 下载单本词书结束
    static let kDownloadSingleFinished     = NSNotification.Name("kDownloadSingleFinished")
    /// 下载所有词书结束
    static let kDownloadAllFinished        = NSNotification.Name("kDownloadAllFinished")
    /// 下载所有词单结束
    static let kDownloadReviewPlanFinished = NSNotification.Name("kDownloadReviewPlanFinished")
    /// 下载作业结束
    static let kDownloadHomeworkFinished   = NSNotification.Name("kDownloadHomeworkFinished")
    /// 新学单词已掌握
    static let kNewWordMastered            = NSNotification.Name("kNewWordMastered")
    /// 加入班级
    static let kReloadClassList            = NSNotification.Name("kReloadClassList")
    /// 显示web页右上方的按钮
    static let kShowRightButton            = NSNotification.Name("kShowRightButton")
    /// 下载词书失败
    static let kDownloadWordError          = NSNotification.Name("kDownloadWordError")
    /// 单词动画播放完成
    static let kWordAnimationPlayFinished  = NSNotification.Name("kWordAnimationPlayFinished")
}
