//
//  YXBookCateModel.m
//  YXEDU
//
//  Created by yao on 2018/11/28.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookCateModel.h"

@implementation YXBookCateModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"options" : [YXBookInfoModel class]
             };
}
@end
