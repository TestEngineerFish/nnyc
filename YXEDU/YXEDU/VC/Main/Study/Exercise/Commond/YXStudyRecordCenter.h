//
//  YXStudyRecordCenter.h
//  YXEDU
//
//  Created by shiji on 2018/6/5.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXStudyRecordModel.h"
#import "YXCommHeader.h"

@interface YXStudyRecordCenter : NSObject
@property (nonatomic, strong, readonly) NSString *recordId;
@property (nonatomic, strong, readonly) NSString *startTime;
+ (instancetype)shared;
- (void)startRecord;
- (void)createRecordId;
- (void)createPackage:(finishBlock)block;

- (void)insertRecord:(YXStudyRecordModel *)model
       completeBlock:(finishBlock)block;

- (void)queryRecord:(finishBlock)block;

- (void)queryRecordByRecordId:(NSString *)recordId
                completeBlock:(finishBlock)block;

- (void)deleteRow:(YXStudyRecordModel *)model
    completeBlock:(finishBlock)block;

- (void)deleteAll:(finishBlock)block;

- (void)batchDelete:(NSMutableArray *)recordArr
      completeBlock:(finishBlock)block;
@end
