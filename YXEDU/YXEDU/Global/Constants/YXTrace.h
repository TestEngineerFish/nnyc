//
//  YXTrace.h
//  YXEDU
//
//  Created by sunwu on 2019/9/10.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const kTraceIdentifyCode;
UIKIT_EXTERN NSString *const kTraceLogin;
UIKIT_EXTERN NSString *const kTracePlatformLogin;
UIKIT_EXTERN NSString *const kTracePlatformLoginResult;
UIKIT_EXTERN NSString *const kTraceRecordQuestion;
UIKIT_EXTERN NSString *const kTraceChoiceQuestion;
UIKIT_EXTERN NSString *const kTraceSpellQuestion;
UIKIT_EXTERN NSString *const kTraceBindMobile;
UIKIT_EXTERN NSString *const kTraceWordInfo;
UIKIT_EXTERN NSString *const kTraceStudyFinish;
UIKIT_EXTERN NSString *const kTraceBadgeWatchTime;
UIKIT_EXTERN NSString *const kTracePunchCardTime;
UIKIT_EXTERN NSString *const kTracePunchCardResult;
UIKIT_EXTERN NSString *const kTraceStudyTime;
UIKIT_EXTERN NSString *const kTraceAppTime;
UIKIT_EXTERN NSString *const kTraceBadgeShare;
UIKIT_EXTERN NSString *const kTraceWordFavourite;
UIKIT_EXTERN NSString *const kTraceQuestionReportError;
UIKIT_EXTERN NSString *const kTracePlayWordSound;
UIKIT_EXTERN NSString *const kTraceSkipSpokenQuestions;
UIKIT_EXTERN NSString *const kTraceAnswerQuestion;
UIKIT_EXTERN NSString *const kTraceReportError;
UIKIT_EXTERN NSString *const kTraceWordDetailTime;//单词详情页面

#pragma mark - Growing io
UIKIT_EXTERN NSString *const kGrowingTraceOpenWordKit; // 单词工具箱
UIKIT_EXTERN NSString *const kGrowingTraceBookReset; // 重置词书
UIKIT_EXTERN NSString *const kGrowingTracePunchShare; // 打卡日历分享
UIKIT_EXTERN NSString *const kGrowingTraceSelectBookPage; // Ad-选择词书
UIKIT_EXTERN NSString *const kGrowingTraceAppDiscover; // Ad-发现页
UIKIT_EXTERN NSString *const kGrowingTraceUnicursalGameJump; // Ad-一笔画跳过单词
UIKIT_EXTERN NSString *const kGrowingTraceUnicursalGameTime; // Ad-一笔画作答
UIKIT_EXTERN NSString *const kGrowingTraceFeedBack; // Ad-学习流程-题目报错
UIKIT_EXTERN NSString *const kGrowingTraceStudyPlanClick; // Ad-点击设置学习计划
UIKIT_EXTERN NSString *const kGrowingTraceStudyPlan; // Ad-保存学习计划
UIKIT_EXTERN NSString *const kGrowingTraceBookSelect; // Ad-选择词书
UIKIT_EXTERN NSString *const kGrowingTraceGetTaskScore; // Ad-获取任务奖励（任务中心+首页）
UIKIT_EXTERN NSString *const kGrowingTraceStudyTime; // Ad-学习流程-学习耗时
UIKIT_EXTERN NSString *const kGrowingTracePunchCardResult; // Ad-学习流程-打卡结果
UIKIT_EXTERN NSString *const kGrowingTracePunchCardTime; // Ad-学习流程-打卡
UIKIT_EXTERN NSString *const kGrowingTraceBadgeShare; // Ad-我的徽章-徽章分享
UIKIT_EXTERN NSString *const kGrowingTraceBadgeWatchTime; // Ad-查看勋章详情
UIKIT_EXTERN NSString *const kGrowingTraceCollectWord; // Ad-学习流程-单词收藏
UIKIT_EXTERN NSString *const kGrowingTraceVoicePlay; // Ad-学习流程-口语题-语音播放
UIKIT_EXTERN NSString *const kGrowingTraceRecordUpload; // Ad-学习流程-口语题-录音上报
UIKIT_EXTERN NSString *const kGrowingTraceRecordPlay; // Ad-学习流程-口语题-录音播放
UIKIT_EXTERN NSString *const kGrowingTraceRecordReupload; // Ad-学习流程-口语题-重新录音
UIKIT_EXTERN NSString *const kGrowingTraceWordInfo; // Ad-学习流程-查看单词详情
UIKIT_EXTERN NSString *const kGrowingTraceBindMobile; // Ad-登录-绑定手机
UIKIT_EXTERN NSString *const kGrowingTraceLogin; // Ad-登录-手机号登录
UIKIT_EXTERN NSString *const kGrowingTraceIdentifyCode; // Ad-登录-获取验证码
UIKIT_EXTERN NSString *const kGrowingTracePlatformLoginResult; // Ad-第三方登录回调

#pragma mark - eventDescKey
UIKIT_EXTERN NSString *const kTracePageKey;
UIKIT_EXTERN NSString *const kTraceDescKey;
UIKIT_EXTERN NSString *const kTraceQuestionTypeKey;
UIKIT_EXTERN NSString *const kTraceQuestionIDKey;
UIKIT_EXTERN NSString *const kTraceQuestionViewNameKey;
UIKIT_EXTERN NSString *const kTraceExerciseKey;

#pragma mark - eventDesc
UIKIT_EXTERN NSString *const kSharePunch;
UIKIT_EXTERN NSString *const kShareBadge;
UIKIT_EXTERN NSString *const kShareGameResult;

UIKIT_EXTERN NSString *const kPlayRecordDesc;
UIKIT_EXTERN NSString *const kRecordVoiceDesc;
UIKIT_EXTERN NSString *const kSpeechXResult;
UIKIT_EXTERN NSString *const kPlayWordVoiceDesc;

// 题目大类
/** 常规题 */
UIKIT_EXTERN NSString *const kExerciseNormal;
/** 复习题 */
UIKIT_EXTERN NSString *const kExerciseReview;
/** 抽查复习题 */
UIKIT_EXTERN NSString *const kExercisePickError;
/** 单词列表学习 */
UIKIT_EXTERN NSString *const kExerciseWordListStudy ;
/** 单词列表听写 */
UIKIT_EXTERN NSString *const kExerciseWordListListen;

// 按钮的确认与取消
UIKIT_EXTERN NSString *const kConfirmDesc;
UIKIT_EXTERN NSString *const kCancleDesc;

/** 三方平台相关 */
UIKIT_EXTERN NSString *const kPlatformQQ;
UIKIT_EXTERN NSString *const kPlatformWX;
UIKIT_EXTERN NSString *const kPlatformWXTimeLine;

UIKIT_EXTERN NSString *const kWechatLogin;


typedef NSString * YXTraceType;
/** 数量统计 */
UIKIT_EXTERN YXTraceType const kTraceCount;
/** 结果统计 */
UIKIT_EXTERN YXTraceType const kTraceResult;
/** 时长统计 */
UIKIT_EXTERN YXTraceType const kTraceTime;
/** other统计 */
UIKIT_EXTERN YXTraceType const kTraceOther;
