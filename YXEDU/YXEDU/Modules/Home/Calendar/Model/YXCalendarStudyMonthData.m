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
             @"study_detail" : [YXNodeModel class]
             };
}

- (NSDictionary<NSString *,UIImage *> *)punchedDateDict {
    NSMutableDictionary<NSString *,UIImage *> *images = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.study_detail) {
        for (YXNodeModel *model in self.study_detail) {
            if ([model.status isEqual: @1]) {
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                dateformatter.dateFormat = @"yyyy-MM-dd";
                NSString *key = [dateformatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:model.date.doubleValue]];
                [images setValue:[UIImage imageNamed:@"calendar_icon_punched"] forKey:key];
            }
        }
    }
    return images;
}

- (NSDictionary<NSString *,UIColor *> *)studiedDateDict {
    NSMutableDictionary *colors = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.study_detail) {
        for (YXNodeModel *model in self.study_detail) {
            if ([model.status isEqual: @0]) {
                NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
                dateformatter.dateFormat = @"yyyy-MM-dd";
                NSString *key = [dateformatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSince1970:model.date.doubleValue]];
                [colors setValue:UIColorOfHex(0xBEEEFD) forKey:key];
            }
        }
    }
    return colors;
}
@end
