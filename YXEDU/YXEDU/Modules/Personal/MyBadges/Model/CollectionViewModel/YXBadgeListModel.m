
//
//  YXBadgeTypeModel.m
//  YXEDU
//
//  Created by yao on 2018/10/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBadgeListModel.h"
@implementation YXBadgeModel

@end




@implementation YXBadgeListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"options" : [YXBadgeModel class]
             };
}

- (void)setOptions:(NSMutableArray *)options {
    _options = options;
}
//- (NSMutableArray *)options {
//    return _options;
//}
@end

