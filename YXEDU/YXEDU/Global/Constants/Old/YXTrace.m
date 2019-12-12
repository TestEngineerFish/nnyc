//
//  YXTrace.m
//  YXEDU
//
//  Created by sunwu on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTrace.h"

NSString *const kTraceIdentifyCode           = @"IdentifyCode";
NSString *const kTraceLogin                  = @"login";
NSString *const kTracePlatformLogin          = @"PlatformLogin";
NSString *const kTracePlatformLoginResult    = @"PlatformLoginResult";
NSString *const kTraceRecordQuestion         = @"RecordQuestion";
NSString *const kTraceChoiceQuestion         = @"ChoiceQuestion";
NSString *const kTraceSpellQuestion          = @"SpellQuestion";
NSString *const kTraceBindMobile             = @"BindMobile";
NSString *const kTraceWordInfo               = @"WordInfo";
NSString *const kTraceStudyFinish            = @"StudyFinish";
NSString *const kTraceBadgeWatchTime         = @"BadgeWatchTime";
NSString *const kTracePunchCardTime          = @"PunchCardTime";
NSString *const kTracePunchCardResult        = @"PunchCardResult";
NSString *const kTraceStudyTime              = @"StudyTime";
NSString *const kTraceAppTime                = @"AppTime";
NSString *const kTraceBadgeShare             = @"BadgeShare";
NSString *const kTraceWordFavourite          = @"WordFavourite";
NSString *const kTraceQuestionReportError    = @"QuestionReportError";
NSString *const kTracePlayWordSound          = @"PlayWordSound";
NSString *const kTraceSkipSpokenQuestions    = @"SkipSpokenQuestions";
NSString *const kTraceAnswerQuestion         = @"AnswerQuestion";
NSString *const kTraceReportError            = @"ReportError";
NSString *const kTraceWordDetailTime         = @"WordDetailTime";

NSString *const kGrowingTraceOpenWordKit            = @"OpenWordKit"; // 单词工具箱
NSString *const kGrowingTraceBookReset              = @"BookReset"; // 重置词书
NSString *const kGrowingTracePunchShare             = @"PUNCH_SHARE"; // 打卡日历分享
NSString *const kGrowingTraceSelectBookPage         = @"SelectBookPage"; // Ad-选择词书
NSString *const kGrowingTraceAppDiscover            = @"AppDiscover"; // Ad-发现页
NSString *const kGrowingTraceUnicursalGameJump      = @"UnicursalGameJump"; // Ad-一笔画跳过单词
NSString *const kGrowingTraceUnicursalGameTime      = @"UnicursalGameTime"; // Ad-一笔画作答
NSString *const kGrowingTraceFeedBack               = @"FeedBack"; // Ad-学习流程-题目报错
NSString *const kGrowingTraceStudyPlanClick         = @"StudyPlanClick"; // Ad-点击设置学习计划
NSString *const kGrowingTraceStudyPlan              = @"StudyPlan"; // Ad-保存学习计划
NSString *const kGrowingTraceBookSelect             = @"BookSelect"; // Ad-选择词书
NSString *const kGrowingTraceGetTaskScore           = @"GetTaskScore"; // Ad-获取任务奖励（任务中心+首页）
NSString *const kGrowingTraceStudyTime              = @"StudyTime"; // Ad-学习流程-学习耗时
NSString *const kGrowingTracePunchCardResult        = @"PunchCardResult"; // Ad-学习流程-打卡结果
NSString *const kGrowingTracePunchCardTime          = @"PunchCardTime"; // Ad-学习流程-打卡
NSString *const kGrowingTraceBadgeShare             = @"BadgeShare"; // Ad-我的徽章-徽章分享
NSString *const kGrowingTraceBadgeWatchTime         = @"BadgeWatchTime"; // Ad-查看勋章详情
NSString *const kGrowingTraceCollectWord            = @"CollectWord"; // Ad-学习流程-单词收藏
NSString *const kGrowingTraceVoicePlay              = @"VoicePlay"; // Ad-学习流程-口语题-语音播放
NSString *const kGrowingTraceRecordUpload           = @"RecordUpload"; // Ad-学习流程-口语题-录音上报
NSString *const kGrowingTraceRecordPlay             = @"RecordPlay"; // Ad-学习流程-口语题-录音播放
NSString *const kGrowingTraceRecordReupload         = @"RecordReupload"; // Ad-学习流程-口语题-重新录音
NSString *const kGrowingTraceWordInfo               = @"WordInfo"; // Ad-学习流程-查看单词详情
NSString *const kGrowingTraceBindMobile             = @"BindMobile"; // Ad-登录-绑定手机
NSString *const kGrowingTraceLogin                  = @"Login "; // Ad-登录-手机号登录
NSString *const kGrowingTraceIdentifyCode           = @"IdentifyCode"; // Ad-登录-获取验证码
NSString *const kGrowingTracePlatformLoginResult    = @"PlatformLoginResult"; // Ad-第三方登录回调


#pragma mark - eventDescKey
NSString *const kTracePageKey                = @"TracePageKey";
NSString *const kTraceDescKey                = @"TraceDescKey";
NSString *const kTraceQuestionTypeKey        = @"TraceQuestionTypeKey";
NSString *const kTraceQuestionIDKey          = @"TraceQuestionIDKey";
NSString *const kTraceQuestionViewNameKey    = @"TraceQuestionViewNameKey";
NSString *const kTraceExerciseKey            = @"TraceExerciseKey";

#pragma mark - eventDesc
NSString *const kSharePunch = @"SharePunch";
NSString *const kShareBadge = @"ShareBadge";
NSString *const kShareGameResult = @"ShareGameResult";

NSString *const kPlayRecordDesc    = @"PlayRecordDes";
NSString *const kRecordVoiceDesc   = @"RecordVoiceDesc";
NSString *const kSpeechXResult     = @"SpeechXResult";
NSString *const kPlayWordVoiceDesc = @"PlayWordVoiceDesc";

// 题目大类
/** 常规题 */
NSString *const kExerciseNormal      = @"ExerciseNormal";
/** 复习题 */
NSString *const kExerciseReview      = @"ExerciseNormal";
/** 抽查复习题 */
NSString *const kExercisePickError   = @"ExerciseNormal";
/** 单词列表学习 */
NSString *const kExerciseWordListStudy   = @"ExerciseWordListStudy";
/** 单词列表听写 */
NSString *const kExerciseWordListListen   = @"ExerciseWordListListen";


NSString *const kWechatLogin = @"osc_wechat_login";



// 按钮的确认与取消
NSString *const kConfirmDesc = @"Confirm";
NSString *const kCancleDesc  = @"Cancle";

/** 三方平台相关 */
NSString *const kPlatformQQ          = @"qq";
NSString *const kPlatformWX          = @"wechat";
NSString *const kPlatformWXTimeLine  = @"WXTimeLine";



//typedef NSString * YXTraceType;
/** 数量统计 */
YXTraceType const kTraceCount    = @"TraceCount";
/** 结果统计 */
YXTraceType const kTraceResult   = @"TraceResult";
/** 时长统计 */
YXTraceType const kTraceTime     = @"TraceTime";
/** other统计 */
YXTraceType const kTraceOther    = @"TraceOther";
