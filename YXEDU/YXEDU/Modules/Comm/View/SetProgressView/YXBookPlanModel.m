//
//  YXBookPlanModel.m
//  YXEDU
//
//  Created by yao on 2018/11/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookPlanModel.h"

static NSInteger const kDefaultPlanNum = 20;
@implementation YXBookPlanModel
+ (YXBookPlanModel *)planModelWith:(NSString *)bookId
                           planNum:(NSInteger)planNum
                         leftWords:(NSInteger)leftWords
                    todayLeftWords:(NSInteger)todayLeftWords
{
    YXBookPlanModel *planModel = [[self alloc] init];
    planModel.bookId = bookId ? bookId : @"";
    planModel.planNum = planNum;
    planModel.theNewBook = !planNum; // 如果是计划是零则为新书
    planModel.leftWords = leftWords;
    planModel.todayLeftWords = todayLeftWords;
    return planModel;
}

- (NSInteger)planNum {
    if (!_planNum) {
        _planNum = kDefaultPlanNum;
    }
    return _planNum;
}
@end
