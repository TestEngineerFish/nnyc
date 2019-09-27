//
//  YRDateFormater.h
//  pyyx
//
//  Created by Chunlin Ma on 15/5/20.
//  Copyright (c) 2015年 朋友印象. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRDateFormater : NSObject

@property(nonatomic,strong) NSDateFormatter *dateFormatter;

+ (YRDateFormater *)shareDateFormater;
- (NSString *)dateToStringDay:(NSNumber *)time;
- (NSString *)dateToStringYMD:(NSDate *)date;
- (NSString *)dateToStringHour:(NSDate *)date;
- (NSDate *)dateFromYMD:(NSString *)dateStr;
/**
 *  根据过去的时间获取一个表达 距离当前时间多久 的字符串
 *
 *  @param timeInterval 过去的时间
 *
 *  @return
 */
- (NSString *)timeDistanceWitholdTime:(NSTimeInterval)timeInterval;

- (NSString *)timeDistanceWitholdTime:(NSTimeInterval)timeInterval allowFuture:(BOOL)allowFuture;

- (NSString *)dateFormateFromString:(NSString *)dateString;

@end
