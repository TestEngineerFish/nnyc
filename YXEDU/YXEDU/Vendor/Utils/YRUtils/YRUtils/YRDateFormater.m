//
//  YRDateFormater.m
//  pyyx
//
//  Created by Chunlin Ma on 15/5/20.
//  Copyright (c) 2015年 朋友印象. All rights reserved.
//

#import "YRDateFormater.h"

NSString* const kDataFormatter = @"kDataFormatter";

@implementation YRDateFormater

+(YRDateFormater *)shareDateFormater
{
    YRDateFormater *dateFormater;
    if (!dateFormater) {
        dateFormater = [[YRDateFormater alloc] init];
    }
    return dateFormater;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        //TODO 因为NSDateFormatter是线程不安全操作, 所以针对多线程场景下每个线程生成NSDateFormatter实例。
        NSMutableDictionary* _thredDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter* _dataFormatter = _thredDictionary[kDataFormatter];
        if (!_dataFormatter) {
            @synchronized(self) {
                if (!_dataFormatter) {
                    _dataFormatter = [[NSDateFormatter alloc] init];
                    [_dataFormatter setDateStyle:NSDateFormatterMediumStyle];
                    [_dataFormatter setTimeStyle:NSDateFormatterNoStyle];
                    [_dataFormatter setLocale:[NSLocale currentLocale]];
                    
                    _thredDictionary[kDataFormatter] = _dataFormatter;
                }
                self.dateFormatter = _dataFormatter;
            }
        }else{
            self.dateFormatter = _dataFormatter;
        }
    }
    
    return self;
}

-(NSString *)dateToStringDay:(NSNumber *)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSLocale *locale=[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setLocale:locale];
    NSCalendar *calendar=[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger nFlags=NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitSecond;
    NSDateComponents *dateComponents=[calendar components:nFlags fromDate:date];
    NSInteger nYear=[dateComponents year];
    NSInteger nDay=[dateComponents day];
    NSDate *currentDate=[NSDate date];
    NSDateComponents *currentDateComponents=[calendar components:nFlags fromDate:currentDate];
    NSInteger nCurrentYear=[currentDateComponents year];
    NSInteger nCurrentDay=[currentDateComponents day];
    NSString *szFormat=nil;
    NSString *szFormatDateTime=nil;
    NSInteger interval=[currentDate timeIntervalSinceDate:date];
    
    NSInteger nCurrentHour=[currentDateComponents hour];
    NSInteger nHour=[dateComponents hour];
    NSInteger nCurrentMin=[currentDateComponents minute];
    NSInteger nMin=[dateComponents minute];
    NSInteger nCurrentSecond=[currentDateComponents second];
    NSInteger nSecond=[dateComponents second];
    
    if (interval<60){
        szFormatDateTime=[NSString stringWithFormat:@"刚刚"];
    }else if (interval<3600){
        szFormatDateTime= [NSString stringWithFormat:@"%ld分钟前", interval/60];
    }else if (interval<86400) {
        if (nDay==nCurrentDay){
            szFormat=@"今天H:mm";
        } else {
            szFormat=@"昨天H:mm";
        }
    }else if (interval<86400 *2 && (nHour<nCurrentHour || (nHour==nCurrentHour && nMin<nCurrentMin) || (nHour==nCurrentHour && nMin==nCurrentMin && nSecond<nCurrentSecond))){
        szFormat=@"昨天H:mm";
    }else{
        if (nYear==nCurrentYear){
            szFormat=@"M月d日 H:mm";
        }else{
            szFormat=@"yyyy-M-d";
            
        }
    }
    
    if (nil==szFormatDateTime){
        [dateFormatter setDateFormat:szFormat];
        szFormatDateTime=[dateFormatter stringFromDate:date];
    }
    return szFormatDateTime;
}

- (NSString *)dateFormateFromString:(NSString *)dateString {
    NSDate *date = [self dateFromYMDHM:dateString];
    return [[YRDateFormater shareDateFormater] timeDistanceWitholdTime:[date timeIntervalSince1970]];
}

- (NSString *)dateToStringYMD:(NSDate *)date
{
    [self.dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)dateToStringHour:(NSDate *)date
{
    [self.dateFormatter setDateFormat:@"H:mm"];
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromYMD:(NSString *)dateStr {
    [self.dateFormatter setDateFormat:@"YYYY-MM-dd"];
    return [self.dateFormatter dateFromString:dateStr];
}

- (NSDate *)dateFromYMDHM:(NSString *)dateStr {
    [self.dateFormatter setDateFormat:@"YYYY-MM-dd H:mm:ss"];
    return [self.dateFormatter dateFromString:dateStr];
}

/**
 *  根据过去的时间获取一个表达 距离当前时间多久 的字符串
 *
 *  @param time 过去的时间
 *
 *  @return
 */

- (NSString *)timeDistanceWitholdTime:(NSTimeInterval)timeInterval{
    return [self timeDistanceWitholdTime:timeInterval allowFuture:YES];
}

- (NSString *)timeDistanceWitholdTime:(NSTimeInterval)timeInterval allowFuture:(BOOL)allowFuture{
    
    NSTimeInterval oldTime = timeInterval;
    //获取当前系统时间
    NSTimeInterval date = [[NSDate date] timeIntervalSince1970];
    //timeDis
    
    float timedis = date - oldTime;
    timedis = (!allowFuture && timedis < 0) ? 0 : timedis;

    // 几秒前
    if (timedis < 60) {
        return @"刚刚";
    }
    //X分钟之前
    if (timedis / 60 < 60) {
        return [NSString stringWithFormat:@"%d 分钟前", (int)(timedis / 60)];
    } else if (timedis / 60 / 60 < 24) { //几个小时前 < 24小时
        return [NSString stringWithFormat:@"%d 小时前", (int)(timedis / 60 / 60)];
    } else if (timedis / 60 / 60 / 24 <= 7) { //几天前 < 7天
        
        if ((int)(timedis / 60 / 60 / 24) < 2) {
            return @"昨天";
        } else {
            return [NSString stringWithFormat:@"%d 天前", (int)(timedis / 60 / 60 / 24)];
        }
    } else {
        NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timeInterval]; //评论时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        //当前年份
        NSString *nowYear = [dateFormatter stringFromDate: [NSDate date]];
        //评论年份
        NSString *oldYear = [dateFormatter stringFromDate: detaildate];
        
        if ([nowYear isEqualToString:oldYear]) {
            [dateFormatter setDateFormat:@"M月d日"];
        } else {
            [dateFormatter setDateFormat:@"yyyy年M月d日"];
        }

        return [dateFormatter stringFromDate: detaildate];
    }
    
}


@end
