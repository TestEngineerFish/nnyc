//
//  UIViewController+YXTrace.m
//  YXEDU
//
//  Created by yao on 2018/12/13.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIViewController+YXTrace.h"
static NSString *const kTraceTypeKey = @"TraceType";
@implementation UIViewController (YXTrace)

- (NSString *)controllerName {
    return NSStringFromClass([self class]);
}

//当前屏幕显示的viewcontroller
- (UIViewController *)currentVC{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *controller = [self getCurrentVCFrom:rootViewController];
    return controller;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;  

    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的

        rootVC = [rootVC presentedViewController];
    }

    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController

        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];

    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController

        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];

    } else {
        // 根视图为非导航类

        currentVC = rootVC;
    }

    return currentVC;
}
@end
