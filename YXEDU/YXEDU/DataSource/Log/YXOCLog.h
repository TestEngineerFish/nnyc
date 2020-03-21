//
//  YXLog.h
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXOCLog : NSObject
+ (instancetype)shared;

-(NSString *)latestLog;

- (void)launch;
+(void)requestLog:(NSString *)msg level:(DDLogLevel)level;
+(void)eventLog:(NSString *)msg;

@end
