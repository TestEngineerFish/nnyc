
//
//  YXBadgeTypeModel.m
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBadgeListModelOld.h"
@implementation YXBadgeModelOld

@end




@implementation YXBadgeListModelOld
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"options" : [YXBadgeModelOld class]
             };
}

- (void)setOptions:(NSMutableArray *)options {
    _options = options;
}
//- (NSMutableArray *)options {
//    return _options;
//}
@end

