//
//  YXMainModel.m
//  YXEDU
//
//  Created by shiji on 2018/9/3.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMainModel.h"

@implementation ChartsData

@end

@implementation Note_Index

@end

@implementation Note_Record

@end


@implementation Note_Charts
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ChartsData class]};
}
@end


@implementation YXNoteCharts
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

@implementation YXNoteRecord

@end

@implementation YXNoteIndex


@end

@implementation YXMainModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"noteCharts" : [YXNoteCharts class]
             };
}
- (BOOL)bookFinished {
    return [self.noteIndex.learned isEqualToString:self.noteIndex.wordCount];
}
//+ (NSDictionary *)modelContainerPropertyGenericClass {
//
//    return @{@"note_index" : [Note_Index class], @"note_record": [Note_Record class],@"note_charts": [Note_Charts class],};
//}
@end
