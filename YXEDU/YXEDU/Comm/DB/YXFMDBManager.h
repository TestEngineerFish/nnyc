//
//  YXFMDBManager.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXMaterialModel.h"
#import "YXStudyRecordModel.h"

@interface YXFMDBManager : NSObject
+ (instancetype)shared;
// Material update
- (void)insertMaterial:(YXMaterialModel *)model
         completeBlock:(finishBlock)block;

- (void)queryMaterial:(finishBlock)block;

- (void)deleteRow:(YXMaterialModel *)model
    completeBlock:(finishBlock)block;

- (void)deleteAll:(finishBlock)block;

// Record Upload
- (void)insertRecord:(YXStudyRecordModel *)model
       completeBlock:(finishBlock)block;

- (void)replaceRecord:(YXStudyRecordModel *)model
        completeBlock:(finishBlock)block;

- (void)queryRecord:(finishBlock)block;

- (void)queryRecordByRecordId:(NSString *)recordId
                completeBlock:(finishBlock)block;

- (void)deleteRecordRow:(YXStudyRecordModel *)model
    completeBlock:(finishBlock)block;

- (void)deleteRecordAll:(finishBlock)block;

- (void)batchDeleteRecord:(NSMutableArray *)recordArr
            completeBlock:(finishBlock)block;
@end
