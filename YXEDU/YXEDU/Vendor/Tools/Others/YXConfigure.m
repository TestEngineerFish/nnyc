//
//  YXConfigure.m
//  YXEDU
//
//  Created by shiji on 2018/4/9.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXConfigure.h"
#import "YRDevice.h"
#import "YXUtils.h"
#import "YXInterfaceCacheService.h"
#import "YXAPI.h"


@interface YXConfigure ()
@property (nonatomic, strong) NSString *deviceId;
@end

@implementation YXConfigure
@synthesize token =_token;
@synthesize time = _time;
@synthesize mobile = _mobile;
@synthesize uuid = _uuid;
@synthesize isShowGuideView = _isShowGuideView;
@synthesize isUSVoice = _isUSVoice;
@synthesize learningModel = _learningModel;

+ (instancetype)shared {
    static YXConfigure *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXConfigure new];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loginModel = [[YXLoginModel alloc]init];
        self.conf3Model = [[YXConfigure3Model alloc]init];
        self.bookUnitModel = [[YXStudyBookUnitModel alloc]init];
        _token = [[NSString alloc]init];
    }
    return self;
}

- (BOOL)isUsStyle {
    return self.confModel.baseConfig.speech;
}

- (NSString *)mobile {
    if (_mobile.length) {
        return _mobile;
    }
    _mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    return _mobile;
}

- (NSString *)uuid {
    if (_uuid.length) {
        return _uuid;
    }
    _uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"uuid"];
    return _uuid;
}

- (void)setUuid:(NSString *)uuid {
    _uuid = uuid;
    [[NSUserDefaults standardUserDefaults]setObject:uuid forKey:@"uuid"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)setMobile:(NSString *)mobile {
    _mobile = mobile;
    [[NSUserDefaults standardUserDefaults]setObject:mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

//- (void)setToken:(NSString *)token {
//    _token = token;
//    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}

- (void)saveToken:(NSString *)token {
    if (!token) {
        token  = @"";
    }
    _token = token;
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)saveCurrentToken {
    [self saveToken:self.token];
}

- (NSString *)token {
    if (_token.length) {
        return _token;
    }
    _token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    return _token;
}

- (void)setTime:(NSString *)time {
    _time = time;
    [[NSUserDefaults standardUserDefaults]setObject:time forKey:@"time"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (NSString *)time {
    if (_time.length) {
        return _time;
    }
    _time = [[NSUserDefaults standardUserDefaults]objectForKey:@"time"];
    return _time;
}

- (NSString *)deviceId {
    return [YXUtils UUID];
}

- (BOOL)isShowGuideView {
    _isShowGuideView = [[NSUserDefaults standardUserDefaults]boolForKey:@"isShowGuideView"];
    return _isShowGuideView;
}

- (void)setIsShowGuideView:(BOOL)isShowGuideView {
    _isShowGuideView = isShowGuideView;
    [[NSUserDefaults standardUserDefaults]setBool:isShowGuideView forKey:@"isShowGuideView"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)isUSVoice {
    _isUSVoice = [[NSUserDefaults standardUserDefaults]boolForKey:@"isUSVoice"];
    return _isUSVoice;
}

- (void)setIsUSVoice:(BOOL)isUSVoice {
    _isUSVoice = isUSVoice;
    [[NSUserDefaults standardUserDefaults]setBool:isUSVoice forKey:@"isUSVoice"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

// 设置学习的model
- (void)setLearningModel:(YXBookModel *)learningModel {
    _learningModel = learningModel;
    [[YXInterfaceCacheService shared]write:learningModel key:STRCAT(@"learningModel", userId)];
}

- (YXBookModel *)learningModel {
    if (_learningModel) {
        return _learningModel;
    }
    return [[YXInterfaceCacheService shared]read:STRCAT(@"learningModel", userId)];
}

- (void)setWordsInfos:(NSMutableArray *)wordsInfos {
    _wordsInfos = [wordsInfos copy];
    _wordsIds = nil;
}

- (NSArray *)wordsIds {
    if (!_wordsIds) {
        _wordsIds = [_wordsInfos valueForKey:@"wordid"];
    }
    return _wordsIds;
}

- (NSString *)currLearningBookId {
    return _currLearningBookId ? _currLearningBookId : @"";
}

- (void)loginOut {
    _currLearningBookId = nil;
    [kNotificationCenter postNotificationName:kLogoutNotify object:nil];
}

- (YXBadgeModelOld *)badgeModelWith:(NSString *)badgeId {
    return [self.confModel.badgesDic objectForKey:badgeId];
}
@end
