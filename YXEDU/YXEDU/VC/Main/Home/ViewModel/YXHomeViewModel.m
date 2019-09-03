//
//  YXMainViewModel.m
//  YXEDU
//
//  Created by shiji on 2018/4/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeViewModel.h"
#import "YXHttpService.h"
#import "NSObject+YR.h"
#import "YXConfigure.h"
#import "YX_URL.h"
#import "YXCommHeader.h"
#import "YXBookModel.h"
#import "YXInterfaceCacheService.h"
#import "YXStudyRecordCenter.h"
#import "YXComHttpService.h"



@interface YXHomeViewModel ()
{
    dispatch_semaphore_t semaphore;
}
@property (nonatomic, strong) NSMutableArray <YXUnitModel *>*dataArr;
@property (nonatomic, strong) NSMutableArray <YXUnitModel *>*learnedArr;
@property (nonatomic, strong) NSMutableArray <YXUnitModel *>*readyLearnedArr;
@end

@implementation YXHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dataArr = [NSMutableArray array];
        self.learnedArr = [NSMutableArray array];
        self.readyLearnedArr = [NSMutableArray array];
        [self configure];
    }
    return self;
}

- (void)configure {
    [self resetAllData:[YXConfigure shared].loginModel.learning.unit];
}

- (NSInteger)itemCount {
    return self.dataArr.count;
}

- (id)itemModel:(NSInteger)idx {
    return self.dataArr[idx];
}

- (NSInteger)getAllWord {
    NSNumber *sum = [self.dataArr valueForKeyPath:@"@sum.word"];
    return sum.integerValue;
}

- (NSInteger)getAllLearned {
    NSNumber *sum = [self.dataArr valueForKeyPath:@"@sum.learned"];
    return sum.integerValue;
}

- (NSInteger)learnedUnitCount {
    return [self.learnedArr count];
}

- (NSInteger)readyLearnedUnitCount {
    return [self.readyLearnedArr count];
}


- (id)readyLearnedUnitModel:(NSInteger)idx {
    return self.readyLearnedArr[idx];
}

- (id)learnedUnitModel:(NSInteger)idx {
    return self.learnedArr[idx];
}

- (NSString *)getTitle {
    return [YXConfigure shared].loginModel.learning.desc;
}

// 请求用户信息
- (void)requestUserInfo:(finishBlock)block {
//    [yx]
    [[YXComHttpService shared]requestUserInfo:^(id obj, BOOL result) {
        if (result) {
            YXLoginModel *model = obj;
            [self resetAllData:model.learning.unit];
        }
        block(obj, result);
    }];
}

// 设置学习记录
- (void)requestLearning:(finishBlock)block {
    YXBookModel *bookModel = [[YXInterfaceCacheService shared]read:STRCAT(@"learningModel", userId)];
    if (bookModel) {
        [[YXComHttpService shared]setLearning:bookModel.bookid finish:^(id obj, BOOL result) {
            block(obj, result);
        }];
    } else {
        block(nil, YES);
    }
    
}


- (void)refreshMainView:(finishBlock)block {
    [self requestLearning:^(id obj, BOOL result) {
        [self requestUserInfo:^(id obj, BOOL result) {
            if (result) {
                [[YXStudyRecordCenter shared]createPackage:^(id obj, BOOL result) { // upload study progress
                    if (result) { // if have study progress should refresh mainview
                        [self refreshMainView:^(id obj, BOOL result) {
                            block(obj, result);
                        }];
                    } else {
                        block(obj, YES);
                    }
                }];
            } else {
                block(obj, result);
            }
        }];
    }];
}

- (void)resetAllData:(NSArray<YXUnitModel *>*)unitArr {
    self.dataArr = [NSMutableArray arrayWithArray:unitArr];
    [self.learnedArr removeAllObjects];
    [self.readyLearnedArr removeAllObjects];
    [self.dataArr enumerateObjectsUsingBlock:^(YXUnitModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.learned.integerValue == obj.word.integerValue) {
            [self.learnedArr addObject:obj];
        } else {
            [self.readyLearnedArr addObject:obj];
        }
    }];
}

@end
