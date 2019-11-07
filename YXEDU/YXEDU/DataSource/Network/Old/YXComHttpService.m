
//
//  YXComHttpService.m
//  YXEDU
//
//  Created by shiji on 2018/6/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXComHttpService.h"
#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YXConfigure.h"
#import "YXAPI.h"
#import "YXPersonalBookModel.h"
#import "YXInterfaceCacheService.h"
#import "YXWordModelManager.h"

@interface YXComHttpService ()

@end
@implementation YXComHttpService
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shared {
    static YXComHttpService *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXComHttpService new];
    });
    return shared;
}

// 请求用户信息
- (void)requestUserInfo:(finishBlock)block {
    [[YXHttpService shared] GET:DOMAIN_GETINFO parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXLoginModel *model = [YXLoginModel yrModelWithJSON:obj];
            [YXConfigure shared].loginModel = model;
            block(model, result);
        }else {
            block(obj,result);
        }
        
    }];
}

- (void)requestBadgesInfo:(finishBlock)block {
    [[YXHttpService shared] GET:DOMAIN_BADGES parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            block(obj, result);
        }
    }];
}

- (void)requestPunchShareURL:(finishBlock)block {
    [[YXHttpService shared] GET:DOMAIN_PUNCH parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            block(obj, result);
        }
        else if (block) {
            block(obj, result);
        }
    }];
}

- (void)requestBadgeShareURL:(NSDictionary *)parameter block:(finishBlock)block {
    [[YXHttpService shared] GET:DOMAIN_BADGESHARE parameters:parameter finshedBlock:^(id obj, BOOL result) {
        if (result) {
            block(obj, result);
        }
        else if (block) {
            block(obj, result);
        }
    }];
}

- (void)requestConfig:(YXFinishBlock)block {
    [YXDataProcessCenter GET:DOMAIN_GETCONFIG modelClass:[YXConfigModel class] parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            YXConfigModel *confModel = response.responseObject;
            [confModel.badgeList sortUsingComparator:^NSComparisonResult(YXBadgeListModel *obj1, YXBadgeListModel *obj2) {
                if ([obj1.type integerValue] > [obj2.type integerValue]) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedAscending;
                }
            }];
            [YXConfigure shared].confModel = confModel;
            NSString *localTime = [YXWordModelManager versionTime];
            if(!confModel.baseConfig.versionTime){
                confModel.baseConfig.versionTime = [[confModel.baseConfig.wordBookDict componentsSeparatedByString:@"="] lastObject];
            }
            if (![localTime isEqualToString:confModel.baseConfig.versionTime]) { // 更新单词资源
                [self getWordsInfo:confModel.baseConfig.wordBookDict andVersionTime:confModel.baseConfig.versionTime];
            }
        }
        if (block) {
            block(response, result);
        }
    }];
}

- (void)getWordsInfo:(NSString *)reqUrl andVersionTime:(NSString *)versionTime{
    [YXDataProcessCenter DOWNLOAD:reqUrl parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completion:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            [self analysisWordsInfo:response.responseObject andVersionTime:versionTime];
        }
    }];
}

- (void)analysisWordsInfo:(id)data andVersionTime:(NSString *)versionTime{
    dispatch_async_to_globalThread(^{
        NSError *error;
        NSArray *wordInfos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (!error) {
            NSLog(@"解析成功");
            dispatch_async_to_mainThread(^{
                [YXWordModelManager saveWordsDetails:wordInfos andVersionTime:versionTime]; 
            });
        }else {
            NSLog(@"解析失败");
        }
    });
}

- (void)setLearning:(NSString *)bookid finish:(finishBlock)block {
    [[YXHttpService shared]POST:DOMAIN_SETLEARNING parameters:@{@"bookids":bookid} finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXBookModel *learning = [YXBookModel yrModelWithJSON:obj[@"learning"]];
            NSMutableArray *bookList = [NSMutableArray array];
            for (NSDictionary *dic in obj[@"addBook"]) {
                YXBookModel *addBook = [YXBookModel yrModelWithJSON:dic];
                [bookList addObject:addBook];
            }
            [YXConfigure shared].loginModel.learning = learning;
            [YXConfigure shared].loginModel.booklist = bookList;
            
            [[YXInterfaceCacheService shared]remove:STRCAT(@"learningModel", userId)];
            block(obj, result);
        }
    }];
}

// 检测版本号r
- (void)checkVersion:(YXVersionModel *)model complete:(finishBlock)block { // 暂无包资源 待调试
    NSDictionary *dic = [model yrModelToDictionary];
    [[YXHttpService shared] GET:DOMAIN_CHKVER parameters:dic finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXVersionResModel *resModel = [YXVersionResModel yrModelWithJSON:obj];
            block(resModel, result);
        } else {
//            [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
        }
    }];
}

@end