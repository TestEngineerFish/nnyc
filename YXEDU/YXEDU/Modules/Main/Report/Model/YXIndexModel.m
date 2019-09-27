//
//  YXIndexModel.m
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXIndexModel.h"

@implementation YXIndexModel
- (NSString *)dateStr {
    if (!_dateStr) {
        NSTimeInterval interval = self.date;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"MM.dd"];
        _dateStr = [dateFormatter stringFromDate:date];
    }
    return _dateStr;
}
@end
