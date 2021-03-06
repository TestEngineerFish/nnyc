//
//  YXCacheKey.swift
//  YXEDU
//
//  Created by 沙庭宇 on 2019/12/19.
//  Copyright © 2019 shiji. All rights reserved.
//

import Foundation


enum YXLocalKey: String {
    case updateVersionTips             = "kUpdateVersionTips" // 版本更新提示
    case oldUserVersionTips            = "kOldUserVersionTips" // 版本更新提示
    case alreadShowNewLearnGuideView   = "kAlreadShowNewLearnGuideView" // 显示学习引导图
    case alreadShowMakeReviewGuideView = "kAlreadShowMakeReviewGuideView" // 显示制作复习计划引导图
    case learningState                 = "kLearningState"       // 学习中状态
    case newFeedbackReply              = "newFeedbackReply"     // 反馈回复消息
    case firstShowHome                 = "kFirstShowHome"       // 首次进入首页
    case taskCenterCanReceive          = "kTaskCenterCanReceive" // 任务中心未领任务
    case makePlanNameIndex             = "YX_Plan_Name_Index"
    case newLearnReportGIO             = "NewLearnReportGIO" // 新学完成上报GIO
    case didShowRate                   = "DidShowRate" // 是否弹过评分弹窗
    case punchCount                    = "PunchCount" // 打卡次数大于等于 4，弹出评分弹窗
    case didShowSetupReminderAlert     = "DidShowSetupReminderAlert" // 是否已展示提示弹框
    case reminder                      = "Reminder" // 提示学习时间

    // ==== UserModel ====
    case uuid                          = "kUUID"
    /// 当前用户ID
    case userId                        = "uid"
    /// 是否已登录
    case didLogin                      = "kDidLogin"
    /// 是否使用美式发音
    case didUseAmericanPronunciation   = "kDidUseAmericanPronunciation"
    /// 用户Token
    case userToken                     = "kUserToken"
    /// 当前用户学习年级
    case currentGrade                  = "kCurrentGrade"
    ///当前在学的词书ID
    case currentChooseBookId           = "currentChooseBookId"
    /// 当前学习的单元ID
    case currentUnitId                 = "kcurrentUnitId"
    /// 当前用户头像
    case currentAvatarImage            = "kCurrentAvatarImage"
    /// 用户名称
    case userName                      = "kUserName"
    /// 用户头像地址
    case userAvatarPath                = "kUserAvatarPath"
    /// 金币使用、获取说明（Web地址）
    case coinExplainUrl                = "kCoinExplainUrl"
    /// 游戏挑战规则说明（Web地址）
    case gameExplainUrl                = "kGameExplainUrl"
    /// 是否有新作业
    case hasNewWork                    = "kHasNewWork"
    /// 是否已加入班级
    case isJoinClass                   = "kIsJoinClass"
    /// 是否完成新用户学习流程
    case isFinishedNewUserStudy        = "kIsFinishedNewUserStudy"
    /// 是否需要显示选择学校
    case isShowSelectSchool            = "kIsShowSelectSchool"
    /// 是否需要显示选择词书
    case isShowSelectBool              = "kIsShowSelectBool"
    /// 最后一次主流程学习时间
    case lastStoredDate                = "kLastStoredDate"
    /// 是否当天首次学习
    case currentFirstStudy             = "kCurrentFirstStudy"

}


extension YXLocalKey {
    /// 根据本地用户，创建新的Key，如果数据缓存不区分用户，可以直接使用，不用调用此方法
    /// - Parameter key: 标识
    static func key(_ key: YXLocalKey) -> String {
        return "\(YXUserModel.default.uuid ?? "")_" + key.rawValue
    }
}
