//
//  YXCalendarStudyMonthData.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarStudyMonthData.h"

@implementation YXStudyMonthSummaryModel

@end

@implementation YXNodeModel

@end

@implementation YXCalendarStudyMonthData
+(NSDictionary *)mj_objectClassInArray {
    return @{
             @"studyDetail" : [YXNodeModel class]
             };
}

- (NSDictionary<NSString *,UIImage *> *)punchedDateDict {
    NSMutableDictionary<NSString *,UIImage *> *images = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.studyDetail) {
        for (YXNodeModel *model in self.studyDetail) {
            if ([model.status  isEqual: @1]) {
                [images setValue:[UIImage imageNamed:@"calendar_icon_punched"] forKey:model.date];
            }
        }
    }
    return images;
}

- (NSDictionary<NSString *,UIColor *> *)studiedDateDict {
    NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.studyDetail) {
        for (YXNodeModel *model in self.studyDetail) {
            if ([model.status  isEqual: @0]) {
                [colors setValue:UIColorOfHex(0xBEEEFD) forKey:model.date];
            }
        }
    }
    return colors;
}
@end
