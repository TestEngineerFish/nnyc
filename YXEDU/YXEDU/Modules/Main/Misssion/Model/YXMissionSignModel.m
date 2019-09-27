//
//  YXMissionSignModel.m
//  YXEDU
//
//  Created by yixue on 2019/1/2.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXMissionSignModel.h"

@interface YXMissionSignModel ()

@end

@implementation YXMissionSignModel

- (BOOL)isTodayCheck {
    NSString *temstr = [self toBinarySystemWithDecimalSystem:_userSignIn.integerValue];
    NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0]];
    for (NSInteger i = 0; i < temstr.length; i++) {
        if ([[temstr substringWithRange:NSMakeRange(i, 1)]  isEqual: @"1"]) {
            ary[6 - (i + 7 - temstr.length)] = @"1";
        }
    }
    for (NSInteger i = 0; i < ary.count; i++) {
        if ([ary[i]  isEqual: @"1"] && i == [self getWeekDayFordate]) {
            return YES;
        }
    }
    return NO;
    
}

- (NSArray *)convertedBaseScore {
    if (!_convertedBaseScore) {
        NSString *str = [_baseScore componentsJoinedByString:@","];
        _convertedBaseScore = [str componentsSeparatedByString:@","];
    }
    return _convertedBaseScore;
}

- (NSString *)convertedUserSignIn {
    if (!_convertedUserSignIn) {
        NSString *temstr = [self toBinarySystemWithDecimalSystem:_userSignIn.integerValue];
        _convertedUserSignIn = [self convert10ToStrAry:temstr];
    }
    return _convertedUserSignIn;
}

//十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal {//"16"
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;//余数
    NSInteger divisor = 0;//除数
    NSString * prepare = @"";
    while (true){
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",(long)remainder];
        if (divisor == 0) {
            break;
        }
    }
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --) {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;//"10001"
}

- (NSString *)convert10ToStrAry:(NSString *)str {
    NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0]];
    for (NSInteger i = 0; i < str.length; i++) {
        if ([[str substringWithRange:NSMakeRange(i, 1)]  isEqual: @"1"]) {
            ary[6 - (i + 7 - str.length)] = @"1";
        }
    }
    NSMutableString *temStr = [[NSMutableString alloc] initWithString:@""];
    for (NSInteger i = 0; i < ary.count; i++) {
        if ([ary[i]  isEqual: @"1"]) {
            [temStr appendString: [NSMutableString stringWithFormat:@"%zd",(NSInteger)(i + 1)] ];
        }
    }
    return temStr; //"124"
}

- (NSInteger)getWeekDayFordate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDate *now = [NSDate date];// 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    if ([comps weekday] - 2 == -1) { return 6; }
    return [comps weekday] - 2;
}

@end
