
//
//  YXPreviousRankModel.m
//  YXEDU
//
//  Created by yao on 2018/12/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPreviousRankModel.h"

@implementation YXPreviousRankModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"currentRankings" : [YXUserRankModel class]
             };
}
@end
