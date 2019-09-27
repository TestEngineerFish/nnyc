//
//  YXBookMaterialManager.m
//  YXEDU
//
//  Created by yao on 2018/10/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookMaterialManager.h"
#import "YXFileDBManager.h"

#import "YXBookMaterialModel.h"
@implementation YXMaterialState
@end


#pragma mark -
@interface YXBookMaterialManager ()
@property (nonatomic, strong)NSMutableDictionary *taskDic;

@end

@implementation YXBookMaterialManager
{
    YRHttpTask *_curBookTask;
    NSString *_curTaskBookId;
}
+ (YXBookMaterialManager *)shareManager {
    static YXBookMaterialManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[YXBookMaterialManager alloc] init];
    });
    return _shareManager;
}

- (NSMutableDictionary *)taskDic {
    if (!_taskDic) {
        _taskDic = [NSMutableDictionary dictionary];
    }
    return _taskDic;
}

- (YRHttpTask *)downloadBookMaterial:(NSString *)resPath
                              bookId:(NSString *)bookId
                            progress:(void (^)(NSProgress *))downloadProgressBlock
                          completion:(YXFinishBlock)finishBlock
{
    YRHttpTask *task = [YXDataProcessCenter DOWNLOAD:resPath parameters:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        if(downloadProgressBlock) {
            dispatch_async_to_mainThread(^{
                downloadProgressBlock(downloadProgress);
            });
        }
    } completion:^(YRHttpResponse *response, BOOL result) {
//        if (result) {
//            dispatch_async_to_globalThread(^{
//                [[YXFileDBManager shared] saveAndUnzip:response.responseObject andOriFileName:resPath.lastPathComponent];
//                dispatch_async_to_mainThread(^{
//                    YXBookMaterialModel *model = [[YXBookMaterialModel alloc] init];
//                });
//            });
//        }
        finishBlock(response,result);
        [self resetCurBookTask];
    }];
    _curBookTask = task;
    _curTaskBookId = bookId;
    return task;
}


//- (void)successDownLoadWith:(NSData *)data andStudyModel:(YXStudyBookModel *)model {
//    dispatch_async_to_globalThread(^{
//        NSString *subPath = [model.bookId stringByAppendingPathComponent:model.resUrl.lastPathComponent];
//        BOOL isSuccess = [[YXFileDBManager shared] saveAndUnzip:data andOriFileName:subPath]; //model.resPath.lastPathComponent
//        dispatch_async_to_mainThread(^{
//            if (isSuccess) {
//                YXBookMaterialModel *bModel = [[YXBookMaterialModel alloc] init];
//                bModel.bookId = model.bookId;
//                bModel.bookName = model.bookName;
//                bModel.materialSize = [NSString stringWithFormat:@"%.2f",1.0 * (data.length) / (1024 * 1024)];
//                bModel.resPath = [[YXUtils resourcePath] DIR:model.bookId];
//                bModel.isFinished = @"1";
//                [[YXFMDBManager shared] insertBookMaterial:@[bModel]  completeBlock:^(id obj, BOOL result) {
//                    if (result) {
//                        //                        [self checkBookState];
//                        model.materialState = kBookMaterialDownloaded;
//                        [self.accountTalbe reloadData];
//                    }
//                }];
//            }else {
//                [YXUtils showHUD:self.view title:@"下载失败"];
//            }
//        });
//    });
//}


- (void)resetCurBookTask {
    _curBookTask = nil;
    _curTaskBookId = nil;
}

- (BOOL)hasBookDownTask {
    return _curBookTask ? YES : NO;;
}

- (void)quaryBookStates:(NSArray *)bookIds completeBlock:(finishBlock)block {
    [YXFMDBManager.share queryBookMaterialWithBookIds:bookIds completeBlock:^(id obj, BOOL result) {
        NSMutableArray *materialStats = nil;
        if (result) {
            materialStats = [YXBookMaterialModel mj_objectArrayWithKeyValuesArray:obj];
        }
        block(materialStats,result);
    }];
}

- (void)quaryMaterialOfAllBooksCompleteBlock:(finishBlock)block {
    [YXFMDBManager.share queryMaterialOfAllBooksWithCompleteBlock:^(id obj, BOOL result) {
        NSMutableArray *materialStats = [NSMutableArray array];
        if (result) {
            materialStats = [YXBookMaterialModel mj_objectArrayWithKeyValuesArray:obj];
        }
        block(materialStats,result);
    }];
}
@end
