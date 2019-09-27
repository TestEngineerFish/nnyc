//
//  YXGroupQuestionModel.h
//  YXEDU
//
//  Created by yao on 2018/10/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXWordQuestionModel.h"
#import "YXStudyModulHeader.h"
@interface YXGroupInfo : NSObject
@property (nonatomic, assign)NSInteger totalGroup;
@property (nonatomic, assign)NSInteger currentGroup;
@end

@interface YXQuestionsInfo : NSObject
@property (nonatomic, assign)BOOL isFinish;
@property (nonatomic, strong)NSMutableArray *data;
- (instancetype)initWith:(BOOL)isFinish data:(NSMutableArray *)data;
@end

@interface YXGroupQuestionModel : NSObject
//@property (nonatomic, assign)BOOL isFinish;
//@property (nonatomic, assign) BOOL isReviewGroup;

@property (nonatomic, strong)YXQuestionsInfo *questions;
@property (nonatomic, strong)YXGroupInfo *groupInfo;
@property (nonatomic, assign)YXExerciseType groupExeType;
@property (nonatomic, assign) NSInteger trueQuestionsCount;

- (instancetype)initWith:(YXQuestionsInfo *)questions groupExeType:(YXExerciseType)groupExeType;
@end

