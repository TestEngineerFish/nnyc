//
//  YXComHttpService.h
//  YXEDU
//
//  Created by shiji on 2018/6/6.
//  Copyright © 2018年 shiji. All rights reserved.
//
/** 通用请求累 */
#import <Foundation/Foundation.h>
#import "YXAPI.h"
#import "YXVersionModel.h"
#import "YXBookModel.h"
#import "YXConfigModel.h"
@interface YXComHttpService : NSObject
+ (instancetype)shared;

/**
 用户信息

 @param block 用户信息
 */
- (void)requestUserInfo:(finishBlock)block;

- (void)requestBadgesInfo:(finishBlock)block;
- (void)requestPunchShareURL:(finishBlock)block;
- (void)requestBadgeShareURL:(NSDictionary *)parameter block:(finishBlock)block;

- (void)setLearning:(NSString *)bookid
             finish:(finishBlock)block ;

/**
 检查app版本

 @param model 模型版本
 @param block 返回版本信息
 */
- (void)checkVersion:(YXVersionModel *)model
            complete:(finishBlock)block;

@end
