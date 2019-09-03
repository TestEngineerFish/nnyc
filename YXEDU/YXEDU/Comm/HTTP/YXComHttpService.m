
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
#import "YX_URL.h"
#import "YXPersonalBookModel.h"
#import "YXInterfaceCacheService.h"

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
    [[YXHttpService shared]GET:DOMAIN_GETUSERINFO parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXLoginModel *model = [YXLoginModel yrModelWithJSON:obj];
            [YXConfigure shared].loginModel = model;
            [[YXInterfaceCacheService shared]write:model key:kGetUserInfo];
            block(model, result);
        } else {
            YXLoginModel *model = [[YXInterfaceCacheService shared]read:kGetUserInfo];
            if (model) {
                if (![YXConfigure shared].loginModel.learning.bookid.length) {
                    [YXConfigure shared].loginModel = model;
                }
                block(model, YES);
            } else {
                block(obj, NO);
            }
        }
    }];
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
        } else {
            // 无网络状态设置学习的书
            YXPersonalBookModel *model = [[YXInterfaceCacheService shared]setLearning:bookid];
            if (model) {
                block(nil, YES);
            } else {
                block(nil, result);
            }
        }
    }];
}

// 检测版本号r
- (void)checkVersion:(YXVersionModel *)model complete:(finishBlock)block {
    NSDictionary *dic = [model yrModelToDictionary];
    [[YXHttpService shared]GET:DOMAIN_CHKVER parameters:dic finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXVersionResModel *resModel = [YXVersionResModel yrModelWithJSON:obj];
            block(resModel, result);
        } else {
            
        }
    }];
}

@end
