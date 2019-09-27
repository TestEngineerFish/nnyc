//
//  YXArticleDetailModel.m
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXArticleDetailModel.h"
#import "YXUnitIdModel.h"
#import "YXUnitDetailModel.h"

@implementation YXArticleDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"unit" : @"YXUnitDetailModel",
             @"unitIds" : @"YXUnitIdModel"
             };
}

@end
