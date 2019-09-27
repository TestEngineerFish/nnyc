//
//  YXGroupQuestionModel.m
//  YXEDU
//
//  Created by yao on 2018/10/30.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGroupQuestionModel.h"

@implementation YXGroupInfo

@end


@implementation YXQuestionsInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"data" : [YXWordQuestionModel class]
             };
}

- (instancetype)initWith:(BOOL)isFinish data:(NSMutableArray *)data {
    if (self = [super init]) {
        self.isFinish = isFinish;
        self.data = data;
    }
    return self;
}
@end





@implementation YXGroupQuestionModel
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//        @"data" : [YXWordQuestionModel class]
//    };
//}

- (instancetype)initWith:(YXQuestionsInfo *)questions  groupExeType:(YXExerciseType)groupExeType {
    if (self = [super init]) {
        self.questions = questions;
        self.groupExeType = groupExeType;
    }
    return self;
}

- (NSInteger)trueQuestions {
    if (!_trueQuestionsCount) {
        NSInteger i = 0;
        for (YXWordQuestionModel *questionModel in self.questions.data) {
            if (!questionModel.end) {
                i++;
            }
        }
        _trueQuestionsCount = i;
    }
    return _trueQuestionsCount;
}
@end
