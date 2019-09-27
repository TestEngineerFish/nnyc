//
//  YXBookListViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookListViewModel.h"
#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YXAPI.h"
#import "YXConfigure.h"
#import "NSObject+YR.h"
#import "YXModelArchiverManager.h"
#import "YXComHttpService.h"

@interface YXBookListViewModel ()

@end

@implementation YXBookListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
// 请求配置
- (void)requestConfigure:(finishBlock)block {
    [[YXHttpService shared]GET:DOMAIN_GETCONFIG3 parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            YXConfigure3Model *model = [YXConfigure3Model yrModelWithJSON:obj];
            [YXConfigure shared].conf3Model = model;
            [[YXModelArchiverManager shared] writeObject:model file:[DOMAIN_GETCONFIG3 lastPathComponent]];
            block(model, result);
        } else {
            YXConfigure3Model *model = [[YXModelArchiverManager shared]readObject:[DOMAIN_GETCONFIG3 lastPathComponent]];
            [YXConfigure shared].conf3Model = model;
            block(obj, result);
        }
    }];
}

- (NSArray *)titleArr {
    NSMutableArray *nameArr = [NSMutableArray array];
//    for (YXConfigure3GradeModel *gradeModel in [YXConfigure shared].conf3Model.config) {
//        [nameArr addObject:gradeModel.name];
//    }
//    return nameArr;
    NSArray *bookList = [YXConfigure shared].confModel.bookList;
    for (YXConfigGradeModel *gradeModel in bookList) {
        [nameArr addObject:gradeModel.name];
    }
    return nameArr;
}


// 设置学习的书本
- (void)setLearning:(NSString *)bookids finish:(finishBlock)block {
    [[YXComHttpService shared]setLearning:bookids finish:^(id obj, BOOL result) {
        if (obj == nil) {
            block(obj, NO);
        } else {
            block(obj, result);
        }
    }];
}

// 添加书本
- (void)addBook:(NSString *)bookids finish:(finishBlock)block {
    [[YXHttpService shared] POST:DOMAIN_ADDBOOK parameters:@{@"bookids":bookids} finshedBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}



@end
