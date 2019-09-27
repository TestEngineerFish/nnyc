//
//  YXUnitDetailModel.m
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXUnitDetailModel.h"
#import "YXUnitDetailTextModel.h"

@implementation YXUnitDetailModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"text" : @"YXUnitDetailTextModel"
             };
}

@end
