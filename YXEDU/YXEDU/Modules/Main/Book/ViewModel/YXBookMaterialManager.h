//
//  YXBookMaterialManager.h
//  YXEDU
//
//  Created by yao on 2018/10/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXMaterialState : NSObject
//@property (nonatomic, strong)YRHttpTask *task;
//@property (nonatomic, assign)NSString *currentProgress;
//@property (nonatomic, copy)progressBlock progressBlock;
//@property (nonatomic, copy)NSString *bookId;
//@property (nonatomic, copy)NSString *resPath;
//@property (nonatomic, assign)BOOL isFinish;
//@property (nonatomic, assign)NSInteger fileSize;
@end

@interface YXBookMaterialManager : NSObject
@property (nonatomic, readonly, assign)BOOL hasBookDownTask;
@property (nonatomic, readonly,  strong)YRHttpTask *curBookTask;
@property (nonatomic, readonly,  strong)NSString *curTaskBookId;
+ (YXBookMaterialManager *)shareManager;
- (YRHttpTask *)downloadBookMaterial:(NSString *)resPath
                              bookId:(NSString *)bookId
                            progress:(void (^)(NSProgress *downloadProgress))downloadProgressBlock
                          completion:(YXFinishBlock)finishBlock;

- (void)quaryBookStates:(NSArray *)bookIds completeBlock:(finishBlock)block;
- (void)quaryMaterialOfAllBooksCompleteBlock:(finishBlock)block;
@end


