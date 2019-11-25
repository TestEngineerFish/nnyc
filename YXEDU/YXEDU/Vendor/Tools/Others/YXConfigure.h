//
//  YXConfigure.h
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXLoginModel.h"
#import "YXConfigure3Model.h"
#import "YXStudyBookUnitModel.h"
#import <CoreLocation/CoreLocation.h>
#import "YXConfigModel.h"

#define userId [YXConfigure shared].uuid

@interface YXConfigure : NSObject
@property (nonatomic, strong) YXLoginModel *loginModel;

@property (nonatomic, strong) YXConfigModel *confModel;
@property (nonatomic, copy)NSString *currLearningBookId;
@property (nonatomic, assign)BOOL isUsStyle;

- (void)loginOut;
- (YXBadgeModelOld *)badgeModelWith:(NSString *)badgeId;


@property (nonatomic, strong) YXConfigure3Model *conf3Model;
@property (nonatomic, strong) YXStudyBookUnitModel *bookUnitModel;
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
+ (instancetype)shared;
- (void)saveToken:(NSString *)token;
- (void)saveCurrentToken;
@end
