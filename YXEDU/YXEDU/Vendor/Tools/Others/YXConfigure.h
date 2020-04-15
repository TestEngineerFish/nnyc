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
@property (nonatomic, strong) YXLoginModel *loginModel;
@property (nonatomic, copy)NSString *currLearningBookId;
// A/B Test,Q-B-1、Q-B-2显示软键盘，不显示可选项
@property (nonatomic, assign) BOOL isShowKeyboard;
// 是否开启新学跳过
@property (nonatomic, assign) BOOL isSkipNewLearn;
// 上报GIO是否为跳过组
@property (nonatomic, assign) BOOL isUploadGIO;

- (void)loginOut;
@property (nonatomic, strong) YXBookModel *learningModel; // 无网络状态下设置单前学习的书
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong, readonly) NSString *deviceId;
@property (nonatomic, assign) BOOL needSpreadAnimation;
@property (nonatomic, assign) BOOL firstAppearKeyBoard;     // 首次是否需要显示键盘
@property (nonatomic, assign) BOOL isShowGuideView;         // 是否为重新启动
@property (nonatomic, assign) BOOL isNeedPlayAudio;         // 是否需要播放音频
@property (nonatomic, assign) BOOL isUSVoice;              // 是否是美式发音

@property (nonatomic, strong)NSArray *wordsInfos;
@property (nonatomic, strong)NSArray *wordsIds;
+ (instancetype _Nonnull)shared;
- (void)saveToken:(NSString *)token;
- (void)saveCurrentToken;
@end
