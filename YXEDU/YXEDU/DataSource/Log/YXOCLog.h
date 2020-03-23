//
//  YXLog.h
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXOCLog : NSObject

@property (nonatomic, strong) DDFileLogger *loggerFoRequest;
@property (nonatomic, strong) DDFileLogger *loggerForEvent;

+ (instancetype)shared;
// 启动日志
- (void)launch;
// 提供给Swift函数调用
- (void)requestLog:(NSString *)msg;
- (void)eventLog:(NSString *)msg;

@end
