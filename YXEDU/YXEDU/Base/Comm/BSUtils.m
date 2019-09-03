

#import "BSUtils.h"
#import "BSCommon.h"

@implementation BSUtils


+ (NSString *)systemName {
    return [[UIDevice currentDevice]systemName];
}
+ (NSString *)systemVersion {
    return [[UIDevice currentDevice]systemVersion];
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSDate *)formatToDate:(NSString *)strDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    return [[dateFormatter dateFromString:strDate]dateByAddingTimeInterval:60*60*8];
}


/**
 检查手机号码是否有效
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3,})\\d{7,}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

/**
 检查身份证号码是否为有效
 */
+ (BOOL)isIDCardNumberCorrect:(NSString *)IDCardNumber
{
    NSUInteger length = IDCardNumber.length;
    
    //    if (length == 15) {
    //        return YES;
    //    }
    
    if (length == 18) {
        NSInteger sum = 0;
        NSArray *tupe = @[@(7), @(9), @(10), @(5), @(8), @(4), @(2), @(1), @(6), @(3), @(7), @(9), @(10), @(5), @(8), @(4), @(2)];
        
        for (int i = 0; i < (length - 1); i++) {
            NSRange range = NSMakeRange(i, 1);
            NSString *letter = [IDCardNumber substringWithRange:range];
            NSInteger number = [letter integerValue];
            sum += (number * [tupe[i] integerValue]);
        }
        
        NSInteger rest = sum % 11;
        NSArray *mask = @[@(1), @(0), @(10), @(9), @(8), @(7), @(6), @(5), @(4), @(3), @(2)];
        NSInteger mappedInteger = [mask[rest] integerValue];
        NSString *lastLetter = [IDCardNumber substringWithRange:NSMakeRange(IDCardNumber.length-1, 1)];
        NSInteger lastNumber = 0;
        if ([lastLetter isEqualToString:@"X"] || [lastLetter isEqualToString:@"x"]) {
            lastNumber = 10;
        } else {
            lastNumber = [lastLetter integerValue];
        }
        
        return lastNumber == mappedInteger;
    }
    
    return NO;
}

/**
 检查邮箱地址是否有效
 */
+ (BOOL)isEmailAddress:(NSString*)email{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateChinaChar:(NSString *)realname {
    NSString *regexStr = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexStr];
    return [predicate evaluateWithObject:realname];
}


@end
