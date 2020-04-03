//
//  NSString+FV.m
//  FunVideo
//
//  Created by shiji on 2018/1/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "NSString+YX.h"

@implementation NSString (YX)
- (NSString *)DIR:(NSString *)dir {
    return [self stringByAppendingPathComponent:dir];
}

- (NSString *)stringAppendType:(FILE_T)type {
    switch (type) {
        case T_MP4:
            return [self stringByAppendingString:@".mp4"];
            break;
        case T_ZIP:
            return [self stringByAppendingString:@".zip"];
            break;
        case T_JPG:
            return [self stringByAppendingString:@".jpg"];
            break;
        case T_MOV:
            return [self stringByAppendingString:@".mov"];
            break;
        case T_PLIST:
            return [self stringByAppendingString:@".plist"];
            break;
        case T_MP3:
            return [self stringByAppendingString:@".mp3"];
            break;
        default:
            return self;
            break;
    }
}

+ (NSString *)EXT:(FILE_T)type {
    switch (type) {
        case T_MP4:
            return @"mp4";
            break;
        case T_ZIP:
            return @"zip";
            break;
        case T_JPG:
            return @"jpg";
            break;
        case T_MOV:
            return @"mov";
            break;
        case T_PLIST:
            return @"plist";
            break;
        case T_MP3:
            return @"mp3";
            break;
        default:
            return @"";
            break;
    }
}

- (BOOL)MobileNumber {
    NSString * MOBILE = @"^1\\d{10}";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if (([regextestmobile evaluateWithObject:self] == YES)
        && self.length == 11) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)createCUID:(NSString *)prefix {
    NSString *result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@-%@", prefix,uuidStr];
    CFRelease(uuidStr);CFRelease(uuid);
    return result;
}

// 终于找到了点击顶部或者截屏必崩点了，谁干的？？？？
//- (NSString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)characterSet {
//    NSUInteger length = [self length];
//    unichar charBuffer[length];
//    [self getCharacters:charBuffer range:NSMakeRange(0, length)];
//
//    NSUInteger subLength = 0;
//    for (NSInteger i = length; i > 0; i--) {
//        if (![characterSet characterIsMember:charBuffer[i - 1]]) {
//            subLength = i;
//            break;
//        }
//    }
//
//    return [self substringWithRange:NSMakeRange(0, subLength)];
//}

- (NSNumber *)transitionNumber {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *result;
    result = [formatter numberFromString:self];
    return result;
}

// 转换成带有阴影的SttributedString
- (NSAttributedString *)convertAttributeString {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColorOfHex(0x3b91d6);
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 2.0;
    NSDictionary *attributeDic = @{
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSShadowAttributeName : shadow
                                   };
    return [[NSAttributedString alloc] initWithString:self attributes:attributeDic];
}

/**
 *  截取URL中的参数
 *
 *  @return NSMutableDictionary parameters
 */
- (NSMutableDictionary *)getURLParameters {

    // 查找参数
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) {
        return nil;
    }

    // 以字典形式将参数返回
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    // 截取参数
    NSString *parametersString = [self substringFromIndex:range.location + 1];

    // 判断参数是单个参数还是多个参数
    if ([parametersString containsString:@"&"]) {

        // 多个参数，分割参数
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];

        for (NSString *keyValuePair in urlComponents) {
            // 生成Key/Value
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

            // Key不能为nil
            if (key == nil || value == nil) {
                continue;
            }

            id existValue = [params valueForKey:key];

            if (existValue != nil) {

                // 已存在的值，生成数组
                if ([existValue isKindOfClass:[NSArray class]]) {
                    // 已存在的值生成数组
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];

                    [params setValue:items forKey:key];
                } else {

                    // 非数组
                    [params setValue:@[existValue, value] forKey:key];
                }

            } else {

                // 设置值
                [params setValue:value forKey:key];
            }
        }
    } else {
        // 单个参数

        // 生成Key/Value
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];

        // 只有一个参数，没有值
        if (pairComponents.count == 1) {
            return nil;
        }

        // 分隔值
        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

        // Key不能为nil
        if (key == nil || value == nil) {
            return nil;
        }

        // 设置值
        [params setValue:value forKey:key];
    }

    return params;
}

/**
 * hexString 转 十六进制
 */
- (unsigned int)conversionToHex {
    unsigned int outVal = 0;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner scanHexInt:&outVal];
    return outVal;
}

/**
 * 根据秒,转换得分钟,向上取整
 **/
-(NSString *)getMinuteFromSecond {
    NSInteger seconds = [self integerValue];
    NSInteger minute = seconds/60;
    if (seconds % 60 > 0) {
        minute++;
    }
    NSString *str_minute = [NSString stringWithFormat:@"%ld",minute];
    return str_minute;
}

/**
 * 根据秒,转换得小时,向下取整
 **/
-(NSString *)getHourFromSecond {
    NSInteger seconds = [self integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%ld",seconds/3600];
    return str_hour;
}



@end
