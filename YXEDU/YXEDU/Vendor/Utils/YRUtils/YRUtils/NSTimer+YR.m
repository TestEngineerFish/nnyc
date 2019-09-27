//
//  NSTimer+YR.m
//  YRUtils
//
//  Created by shiji on 2018/3/29.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "NSTimer+YR.h"

@implementation NSTimer (YR)


+ (NSTimer *)yr_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(yr_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (NSTimer *)yr_timerWithTimeInterval:(NSTimeInterval)interval
                                block:(void(^)(void))block
                              repeats:(BOOL)repeats {
    return [self timerWithTimeInterval:interval
                                target:self
                              selector:@selector(yr_blockInvoke:)
                              userInfo:[block copy]
                               repeats:repeats];
}

+ (void)yr_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}


@end
