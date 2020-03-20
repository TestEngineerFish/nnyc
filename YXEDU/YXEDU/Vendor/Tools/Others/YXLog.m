//
//  YXLog.m
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLog.h"
#import <libkern/OSAtomic.h>
#import "CocoaLumberjack/CocoaLumberjack.h"
#import "DDLegacyMacros.h"

@interface YXLogFormatter : NSObject <DDLogFormatter>
{
    int32_t atomicLoggerCount;
}
@end

@implementation YXLogFormatter

-(NSString *)_logLevelWithFlag:(DDLogFlag)flag{
    if (flag == DDLogFlagError){
        return @"Error";
    }else if (flag == DDLogFlagInfo){
        return @"Info";
    }else if (flag == DDLogFlagDebug){
        return @"Debug";
    }else if (flag == DDLogFlagWarning){
        return @"Warn";
    }else if (flag == DDLogFlagVerbose){
        return @"Verbose";
    }else{
        return @"Unknow";
    }
}

- (NSString *__nullable)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *path = [NSString stringWithCString:logMessage.file.UTF8String encoding:NSASCIIStringEncoding];
    NSString *fileName = [path lastPathComponent];
    NSString *functionName = [NSString stringWithCString:logMessage.function.UTF8String encoding:NSASCIIStringEncoding];
    NSString *level = [self _logLevelWithFlag:logMessage->_flag];
    return [NSString stringWithFormat:@"[%@]%@-%@(%lu): %@",level, fileName, functionName, (unsigned long)logMessage.line, logMessage.message];
}


/**
 *  协议方法
 */
- (void)didAddToLogger:(id <DDLogger> __unused)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

/**
 *  协议方法
 */
- (void)willRemoveFromLogger:(id <DDLogger> __unused)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}

@end

@interface YXLog ()
@property (nonatomic, strong)  DDFileLogger *fileLogger;
@end

@implementation YXLog

+ (void)output:(NSString *)msg {
    YXLogInfo(@"%@", msg);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
#if TARGET_IPHONE_SIMULATOR
        // Sends log statements to Xcode console - if available
        setenv("XcodeColors", "YES", 1);
#endif
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor blueColor] backgroundColor:nil forFlag:DDLogFlagInfo];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor greenColor] backgroundColor:nil forFlag:DDLogFlagDebug];
        [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor lightGrayColor] backgroundColor:nil forFlag:DDLogFlagVerbose];
        
        _fileLogger = [[DDFileLogger alloc] init];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.maximumFileSize=512*1024;//512kb
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
        
        YXLogFormatter *logFormatter = [[YXLogFormatter alloc]init];
        [_fileLogger setLogFormatter:logFormatter];
        
        [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
        [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
        
    }
    return self;
}

+ (instancetype)shared {
    static YXLog *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[YXLog alloc]init];
    });
    return shared;
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
