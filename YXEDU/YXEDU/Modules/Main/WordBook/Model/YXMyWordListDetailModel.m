//
//  YXMyWordListDetailModel.m
//  YXEDU
//
//  Created by yao on 2019/2/26.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordListDetailModel.h"

@implementation YXMyWordListDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"words" : [YXMyWordListCellModel class]
             };
}


- (NSArray *)markTexts {
    if (!_markTexts) {
        NSMutableArray *markTexts = [NSMutableArray array];
        if (self.createTime) {
            [markTexts addObject:[NSString stringWithFormat:@"%@ 创建", self.createDateDesc]];
        }
        
        if (self.finishLearnTime) {
            [markTexts addObject:self.finishLearnDateDesc];
        }
        
        if (self.finishListenTime) {
            [markTexts addObject:self.finishListenDateDesc];
        }
        _markTexts = markTexts;
    }
    return _markTexts;
}

@end
