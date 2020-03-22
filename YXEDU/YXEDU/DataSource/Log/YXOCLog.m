//
//  YXLog.m
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXOCLog.h"
#import <libkern/OSAtomic.h>
#import "CocoaLumberjack/CocoaLumberjack.h"
#import "DDLegacyMacros.h"
#import "YXLogFormatter.h"

@implementation YXOCLog

- (void)requestLog:(NSString *)msg {
    YXRequestLog(@"%@", msg);
}

- (void)eventLog:(NSString *)msg {
    YXEventLog(@"%@", msg);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
#if TARGET_IPHONE_SIMULATOR
        // Sends log statements to Xcode console - if available
        setenv("XcodeColors", "YES", 1);
#endif
    }
    return self;
}

+ (instancetype)shared {
    static YXOCLog *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[YXOCLog alloc]init];
    });
    return shared;
}

- (void)launch {
    NSString *logsDirectory = [[DDFileLogger alloc] init].logFileManager.logsDirectory;
    // 网络请求
    DDLogFileManagerDefault *fileManagerForRequest = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Request"]];
    self.loggerFoRequest = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForRequest];
    YXLogFormatter *formatterForRequest = [[YXLogFormatter alloc] init];
    [formatterForRequest addToWhitelist:LOG_CONTEXT_REQUEST];
    [self.loggerFoRequest setLogFormatter:formatterForRequest];
    self.loggerFoRequest.maximumFileSize = 1024 * 1024 * 1;
    self.loggerFoRequest.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.loggerFoRequest withLevel:DDLogLevelVerbose | LOG_FLAG_REQUEST];
    // 普通日志
    DDLogFileManagerDefault *fileManagerForEvent = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Event"]];
    self.loggerForEvent = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForEvent];
    YXLogFormatter *formatterForEvent = [[YXLogFormatter alloc] init];
    [formatterForEvent addToWhitelist:LOG_CONTEXT_EVENT];
    [self.loggerForEvent setLogFormatter:formatterForEvent];
    self.loggerForEvent.maximumFileSize = 1024 * 1024 * 1;
    self.loggerForEvent.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.loggerForEvent withLevel:DDLogLevelVerbose | LOG_FLAG_EVENT];
    // 控制台输出
    [DDLog addLogger:[DDOSLogger sharedInstance] withLevel:DDLogLevelInfo | LOG_FLAG_EVENT];
}


@end
