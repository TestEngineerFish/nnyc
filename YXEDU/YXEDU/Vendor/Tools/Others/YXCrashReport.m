//
//  YXCrashReport.m
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCrashReport.h"
#import <Bugly/Bugly.h>
#import "YXOCLog.h"

#ifdef DEBUG
//do sth.
#define DEBUG_MODE 1
#else
#define DEBUG_MODE 0
#endif

@interface YXUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;

+ (NSString *)getException;
@end

@implementation YXUncaughtExceptionHandler

+ (void) setDefaultHandler {
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*) getHandler {
    return NSGetUncaughtExceptionHandler();
}


+ (NSString *)getException {
    NSError *error = nil;
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
}

static void UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     name,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

static NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end


@interface YXCrashReport () <BuglyDelegate>

@end

@implementation YXCrashReport

- (instancetype)init {
    self = [super init];
    if (self) {
        BuglyConfig *config = [[BuglyConfig alloc] init];
        config.blockMonitorEnable = YES;
        config.unexpectedTerminatingDetectionEnable = YES;
        config.delegate = self;
        config.debugMode = DEBUG_MODE;
        [Bugly startWithAppId:kBuglyAppId config:config];
       
        [YXUncaughtExceptionHandler setDefaultHandler];
    }
    return self;
}

+ (instancetype)shared {
    static YXCrashReport *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXCrashReport new];
    });
    return shared;
}

- (NSString * BLY_NULLABLE)attachmentForException:(NSException * BLY_NULLABLE)exception {
    NSLog(@"%@", [YXUncaughtExceptionHandler getException]);
    return [YXUncaughtExceptionHandler getException];
}

@end
