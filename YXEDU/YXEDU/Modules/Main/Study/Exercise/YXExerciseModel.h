//
//  YXExerciseModel.h
//  YXEDU
//
//  Created by yao on 2019/3/1.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXStudyModulHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXExerciseModel : NSObject
@property (nonatomic, copy) NSString *learningBookId;// 词单或词书
@property (nonatomic, assign) YXExerciseType exerciseType;

- (BOOL)isNormalStudyProcess;
@end

NS_ASSUME_NONNULL_END
