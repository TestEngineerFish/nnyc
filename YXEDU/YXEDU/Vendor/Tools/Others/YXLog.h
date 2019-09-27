//
//  YXLog.h
//  YXEDU
//
//  Created by shiji on 2018/3/14.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXLog : NSObject
+ (instancetype)shared;

-(NSString *)latestLog;
@end
