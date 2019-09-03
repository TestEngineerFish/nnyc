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


@end
