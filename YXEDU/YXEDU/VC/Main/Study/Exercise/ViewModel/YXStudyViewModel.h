//
//  YXStudyViewModel.h
//  YXEDU
//
//  Created by shiji on 2018/4/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXCommHeader.h"
#import "YXStudyProgressModel.h"
#import "YXStudyBatchModel.h"

@interface YXStudyViewModel : NSObject
- (void)reportStudyProgress:(YXStudyProgressModel *)model
                     finish:(finishBlock)block;

- (void)batchReportStudy:(YXStudyBatchModel *)model
                  finish:(finishBlock)block;
@end
