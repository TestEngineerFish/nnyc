//
//  NSObject+YR.m
//  YRUtils
//
//  Created by shiji on 2018/3/26.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "NSObject+YR.h"
#import "YXModel.h"

@implementation NSObject (YR)

+ (id)yrModelWithJSON:(id)json {
    return [self yy_modelWithJSON:json];
}

- (NSString *)yrModelToJSONString {
    return [self yy_modelToJSONString];
}

- (id)yrModelToDictionary {
    return [self yy_modelToJSONObject];
}

// 转换DeviceToken
+ (NSString *)deviceTokenToStringWith: (NSData *)deviceToken {
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return hexToken;
}

@end
