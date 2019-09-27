//
//  NSTimer+YR.h
//  YRUtils
//
//  Created by shiji on 2018/3/29.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YR)

+ (NSTimer *)yr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats;
+ (NSTimer *)yr_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(void(^)(void))block
                              repeats:(BOOL)repeats;

@end
