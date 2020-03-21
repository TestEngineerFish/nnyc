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

@interface YXOCLog ()
@property (nonatomic, strong)  DDFileLogger *fileLogger;
@end

@implementation YXOCLog

+(void)requestLog:(NSString *)msg level:(DDLogLevel)level {
    YXRequestLog(@"%@", msg);
}

+ (void)eventLog:(NSString *)msg {
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
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    
    NSString *logsDirectory = [[DDFileLogger alloc] init].logFileManager.logsDirectory;

    DDLogFileManagerDefault *fileManagerForRequest = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Request"]];
    DDFileLogger *loggerFoRequest = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForRequest];
    YXLogFormatter *formatterForRequest = [[YXLogFormatter alloc] init];
    [formatterForRequest addToWhitelist:LOG_CONTEXT_REQUEST];
    [loggerFoRequest setLogFormatter:formatterForRequest];
    loggerFoRequest.maximumFileSize = 1024 * 1024 * 1;
    loggerFoRequest.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:loggerFoRequest withLevel:DDLogLevelVerbose | LOG_FLAG_REQUEST];
    
    DDLogFileManagerDefault *fileManagerForEvent = [[DDLogFileManagerDefault alloc] initWithLogsDirectory:[logsDirectory stringByAppendingPathComponent:@"Event"]];
    DDFileLogger *loggerForEvent = [[DDFileLogger alloc] initWithLogFileManager:fileManagerForEvent];
    YXLogFormatter *formatterForEvent = [[YXLogFormatter alloc] init];
    [formatterForEvent addToWhitelist:LOG_CONTEXT_EVENT];
    [loggerForEvent setLogFormatter:formatterForEvent];
    loggerFoRequest.maximumFileSize = 1024 * 1024 * 1;
     loggerFoRequest.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:loggerForEvent withLevel:DDLogLevelVerbose | LOG_FLAG_EVENT];
}

- (NSString *)log {
    return [NSString stringWithContentsOfFile:_fileLogger.currentLogFileInfo.filePath encoding:NSUTF8StringEncoding error:0];
}

-(NSString *)latestLog {
    NSString* log=[self log];
    NSInteger maxUploadLogLength=10*1024;
    if (log.length>maxUploadLogLength) {
        return [log substringFromIndex:log.length-maxUploadLogLength];
    }else{
        return log;
    }
}



@end
