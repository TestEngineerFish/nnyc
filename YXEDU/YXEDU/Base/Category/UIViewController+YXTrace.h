//
//  UIViewController+YXTrace.h
//  YXEDU
//
//  Created by yao on 2018/12/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXTrace.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YXTrace)
@property (nonatomic, strong ,readonly) UIViewController * _Nullable currentVC;

- (void)traceEvent:(NSString *)eventId descributtion:(NSString *)desc;
/** 细分 */
- (void)traceEvent:(NSString *)eventId traceType:(YXTraceType)traceType descributtion:(NSString *)desc;
+ (void)traceEvent:(NSString *)eventId descributtion:(NSString *)desc;
- (NSString *)controllerName;
@end
NS_ASSUME_NONNULL_END
