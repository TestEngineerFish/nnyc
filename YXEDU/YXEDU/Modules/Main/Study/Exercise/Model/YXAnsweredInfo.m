

//
//  YXAnsweredInfo.m
//  YXEDU
//
//  Created by yao on 2018/11/6.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXAnsweredInfo.h"

@implementation YXPerAnswer
- (instancetype)init {
    if (self = [super init]) {
        self.result = @"";
    }
    return self;
}

+ (YXPerAnswer *)anwerWithQuestionTip:(int)questionTip learnTime:(NSInteger)learnTime scanTime:(NSInteger)scanTime  isRight:(int)isRight {
    YXPerAnswer *pAnswer = [[YXPerAnswer alloc] init];
    pAnswer.learnTime = learnTime;
    pAnswer.scanTime = scanTime;
    pAnswer.isRight = isRight;
    pAnswer.questionTip = questionTip;
    return pAnswer;
}
@end


@implementation YXAnsweredInfo
- (instancetype)init {
    if (self = [super init]) {
        self.learnStart = @"";
        self.learnFinish = @"";
        self.question = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"question" : [YXPerAnswer class]
             };
}

- (NSMutableDictionary *)answerInfoDic {
    NSMutableDictionary *dic = [self mj_keyValues];
    return dic;
}

- (NSMutableDictionary *)answerInfoJson {
    return [self answerInfoJson];
}
@end
