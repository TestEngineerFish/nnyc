//
//  YXMyWordBookModel.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookModel.h"

@implementation YXMyWordBookModel
- (NSString *)descString {
    if (!_descString) {
        _descString = [NSString stringWithFormat:@"共%zd个单词：(已学习%zd个单词 已听写%zd个单词)",self.total,self.learn,self.listen];
    }
    return _descString;
}

- (NSString *)studyStateString {
    if (!_studyStateString) {
        NSString *studyStateString = @"开始学习";
        if (self.learnState == 2) {
            studyStateString = @"继续学习";
        }else if(self.learnState == 3) {
            studyStateString = @"重新学习";
        }
        _studyStateString = studyStateString;
    }
    return _studyStateString;
}

- (NSString *)listenStateString {
    if (!_listenStateString) {
        NSString *listenStateString = @"开始听写";
        if (self.listenState == 2) {
            listenStateString = @"继续听写";
        }else if(self.listenState == 3) {
            listenStateString = @"重新听写";
        }
        _listenStateString = listenStateString;
    }
    return _listenStateString;
}

- (NSString *)createDateDesc {
    if (!_createDateDesc) {
        _createDateDesc = [self dateDescributionWith:self.createTime];//[NSString stringWithFormat:@"%@ 创建", ];
    }
    return _createDateDesc;
}


- (NSString *)finishLearnDateDesc {
    if (!_finishLearnDateDesc) {
        _finishLearnDateDesc = [NSString stringWithFormat:@"%@ 完成学习",[self dateDescributionWith:self.finishLearnTime]];
    }
    return _finishLearnDateDesc;
}

- (NSString *)finishListenDateDesc {
    if (!_finishListenDateDesc) {
        _finishListenDateDesc = [NSString stringWithFormat:@"%@ 完成听写",[self dateDescributionWith:self.finishListenTime]];
    }
    return _finishListenDateDesc;
}

- (NSString *)sharingPersonDesc {
    if (!_sharingPersonDesc) {
        _sharingPersonDesc = [NSString stringWithFormat:@"来自%@的分享",self.sharingPerson];
    }
    return _sharingPersonDesc;
}

- (NSString *)dateDescributionWith:(NSTimeInterval)timeInterval {
    NSString *createDateDesc  = @"";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy.MM.dd hh:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *hourMinStr = [[dateStr componentsSeparatedByString:@" "] lastObject];
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        createDateDesc = [NSString stringWithFormat:@"今天 %@",hourMinStr];
    }else if([[NSCalendar currentCalendar] isDateInYesterday:date]) {
        createDateDesc = [NSString stringWithFormat:@"昨天 %@",hourMinStr];
    }else {
        NSDate *dateAfter24Hour = [date dateByAddingTimeInterval:24 * 60 * 60];
        if ([[NSCalendar currentCalendar] isDateInYesterday:dateAfter24Hour]) {
            createDateDesc = [NSString stringWithFormat:@"前天 %@",hourMinStr];
        }else {
            createDateDesc = [NSString stringWithFormat:@"%@",dateStr];
        }
    }
    return createDateDesc;
}
@end
