//
//  YXStudyRecordCenter.m
//  YXEDU
//
//  Created by shiji on 2018/6/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXStudyRecordCenter.h"
#import "NSObject+YR.h"
#import "YXUtils.h"
#import "NetWorkRechable.h"
#import "YXStudyViewModel.h"
#import "YXStudyBatchModel.h"
#import "YXConfigure.h"

@interface YXStudyRecordCenter () {
    BOOL isBatching; // 是否在上报中状态
}
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *recordId;
@property (nonatomic, strong) NSMutableString *logStr;
@property (nonatomic, strong) NSMutableDictionary *logDic;
@property (nonatomic, strong) YXStudyViewModel *viewModel;
@end
@implementation YXStudyRecordCenter

+ (instancetype)shared {
    static YXStudyRecordCenter *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXStudyRecordCenter new];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logStr = [NSMutableString string];
        self.logDic = [NSMutableDictionary dictionary];
        self.viewModel = [[YXStudyViewModel alloc]init];
        isBatching = NO;
    }
    return self;
}

- (void)startRecord {
    self.startTime = [YXUtils getCurTime];
    NSLog(@"startTime------::%@", self.startTime);
}

// create new recordid
- (void)createRecordId {
    self.recordId = [NSString stringWithFormat:@"%d",[YXUtils randomNumber]];
}

// create package
- (void)createPackage:(finishBlock)block {
    // 无网络学完一单元
    if ([NetWorkRechable shared].netWorkStatus != NetWorkStatusReachableViaWWAN &&
        [NetWorkRechable shared].netWorkStatus != NetWorkStatusReachableViaWiFi) { // 打添加记录
        block(nil, NO);
    } else {
        @synchronized(self) {
            [self forceCreatePackage:block];
        }
    }
}


// need force Package
- (void)forceCreatePackage:(finishBlock)block {
    if (isBatching) {
        block(nil, NO);
        return;
    }
    isBatching = YES;
    [self createRecordId]; // 创建一条记录
    __block NSMutableArray *dataArr = [NSMutableArray array];
    [self queryRecord:^(id obj, BOOL result) {
        if (result) {
            dataArr = [NSMutableArray arrayWithArray:obj];
            NSMutableArray *batchDataArr = [NSMutableArray array];
            NSMutableArray *logCollectionArr = [NSMutableArray array];
            NSMutableArray *removeLastCollectionArr = [NSMutableArray array];
            for (YXStudyRecordModel *recordModel in dataArr) {
                YXStudyBatchDataModel *dataModel = [[YXStudyBatchDataModel alloc]init];
                dataModel.bookid = recordModel.bookid;
                dataModel.unitid = recordModel.unitid;
                dataModel.questionidx = recordModel.questionidx;
                dataModel.questionid = recordModel.questionid;
                dataModel.learn_status = recordModel.learn_status;
                if ([recordModel.uuid isEqualToString:[YXConfigure shared].uuid]) {
                    [logCollectionArr addObjectsFromArray:[[recordModel.log stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]] componentsSeparatedByString:@"\n"]];
                    [batchDataArr addObject:dataModel];
                } else {
                    [removeLastCollectionArr addObject:recordModel];
                }
            }
            
            // 删除上一次登录用户的数据
            [self batchDelete:removeLastCollectionArr completeBlock:^(id obj, BOOL result) {
            }];
            
            // 上报数据
            YXStudyBatchModel *batchModel = [[YXStudyBatchModel alloc]init];
            batchModel.data = batchDataArr;
            batchModel.learning_log = logCollectionArr;
            [self.viewModel batchReportStudy:batchModel finish:^(id obj, BOOL result) {
                if (result) { // 数据上报成功之后删除数据库
                    [dataArr removeObjectsInArray:removeLastCollectionArr];
                    [self batchDelete:dataArr completeBlock:^(id obj, BOOL result) {
                        if (result) {
                            // TODO:: 可以加递归，
                            block(obj, result); // 上报成功
                        } else {
                            block(obj, result);
                        }
                        isBatching = NO;
                    }];
                } else {
                    block(obj, result);
                    isBatching = NO;
                }
            }];
        } else {
            block(obj, result);
            isBatching = NO;
        }
    }];
}


- (void)insertRecord:(YXStudyRecordModel *)model completeBlock:(finishBlock)block {
    if ([self.logDic objectForKey:model.recordid]) {
        [self.logStr appendString:model.log];
    } else {
        [self.logStr setString:model.log];
    }
    [self.logDic setObject:self.logStr forKey:model.recordid];
    model.log = self.logStr;
    [YXFMDBManager.share replaceStudyRecordWithModel:model completeBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}


- (void)queryRecord:(finishBlock)block {
    [YXFMDBManager.share queryAllStudyRecordWithCompleteBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)queryRecordByRecordId:(NSString *)recordId completeBlock:(finishBlock)block {
    [YXFMDBManager.share queryStudyRecordBy:recordId completeBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)deleteRow:(YXStudyRecordModel *)model completeBlock:(finishBlock)block {
    [YXFMDBManager.share deleteStudyRecordWithModel:model completeBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)deleteAll:(finishBlock)block  {
    [YXFMDBManager.share deleteAllStudyRecordWithCompleteBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

- (void)batchDelete:(NSMutableArray *)recordArr completeBlock:(finishBlock)block {
    if (recordArr.count == 0) return;
    [YXFMDBManager.share deleteBatchStudyRecordWithRecordArray:recordArr completeBlock:^(id obj, BOOL result) {
        block(obj, result);
    }];
}

@end
