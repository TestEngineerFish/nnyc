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
- (NSString *)controllerName;
@end
NS_ASSUME_NONNULL_END
