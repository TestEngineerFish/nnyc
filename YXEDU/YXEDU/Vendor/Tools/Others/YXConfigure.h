//
//  YXConfigure.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXLoginModel.h"
#import <CoreLocation/CoreLocation.h>

#define userId [YXConfigure shared].uuid

@interface YXConfigure : NSObject
@property (nonatomic, strong, nullable) YXLoginModel *  loginModel;
// A/B Test,Q-B-1、Q-B-2显示软键盘，不显示可选项
@property (nonatomic, assign) BOOL isShowKeyboard;
// 是否开启新学跳过
@property (nonatomic, assign) BOOL isSkipNewLearn;
// 上报GIO是否为跳过组
@property (nonatomic, assign) BOOL isUploadGIO;

- (void)loginOut;

@property (nonatomic, strong, nullable) YXBookModel *learningModel; // 无网络状态下设置单前学习的书
@property (nonatomic, strong, nullable) CLLocation *location;
@property (nonatomic, strong, nullable) NSString *token;
@property (nonatomic, strong, nullable) NSString *uuid;
@property (nonatomic, strong, nullable) NSString *mobile;
@property (nonatomic, strong, nullable) NSString *time;
@property (nonatomic, strong, readonly, nonnull) NSString *deviceId;
@property (nonatomic, assign) BOOL needSpreadAnimation;
@property (nonatomic, assign) BOOL firstAppearKeyBoard;     // 首次是否需要显示键盘
@property (nonatomic, assign) BOOL isShowGuideView;         // 是否为重新启动
@property (nonatomic, assign) BOOL isNeedPlayAudio;         // 是否需要播放音频
@property (nonatomic, assign) BOOL isUSVoice;              // 是否是美式发音

@property (nonatomic, strong, nullable)NSArray *wordsInfos;
@property (nonatomic, strong, nullable)NSArray *wordsIds;

+ (instancetype _Nonnull)shared;
- (void)saveToken:(nonnull NSString *)token;
- (void)saveCurrentToken;
@end
