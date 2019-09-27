//
//  AppDelegate+Guaid.m
//  KSGuaidViewDemo
//
//  Created by Mr.kong on 2017/5/31.
//  Copyright © 2017年 Bilibili. All rights reserved.
//

#import "AppDelegate+Guaid.h"
#import "KSGuaidViewController.h"
#import "YXGuideView.h"
#import <objc/runtime.h>

const char* kGuaidWindowKey = "kGuaidWindowKey";
NSString * const kLastVersionKey = @"kLastVersionKey";
@interface AppDelegate()<YXGuideViewDelegate>
@end
@implementation AppDelegate (Guaid) 

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString* lastVersion = [[NSUserDefaults standardUserDefaults] stringForKey:kLastVersionKey];
        NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        
        if ([curtVersion compare:lastVersion] == NSOrderedDescending) {
            Method originMethod = class_getInstanceMethod(self.class, @selector(application:didFinishLaunchingWithOptions:));
            Method customMethod = class_getInstanceMethod(self.class, @selector(guaid_application:didFinishLaunchingWithOptions:));
            
            method_exchangeImplementations(originMethod, customMethod);

        }
    });
}

- (BOOL)guaid_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     BOOL finish = [self guaid_application:application didFinishLaunchingWithOptions:launchOptions];
    if (![YXConfigure shared].isShowGuideView) {
        self.guaidWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        self.guaidWindow.rootViewController = vc;
        
        self.guaidWindow.backgroundColor = [UIColor clearColor];
        self.guaidWindow.windowLevel = UIWindowLevelStatusBar + 1;
        YXGuideView *guideView = [[YXGuideView alloc]initWithFrame:[UIScreen mainScreen].bounds];//CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        guideView.delegate = self;
        [vc.view addSubview:guideView];
        [self.guaidWindow makeKeyWindow];
        self.guaidWindow.hidden = NO;
//        [self.guaidWindow makeKeyAndVisible];
//        [self showGuideView];
    }
    
//    self.guaidWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
////    self.guaidWindow.frame = self.guaidWindow.screen.bounds;
//    self.guaidWindow.backgroundColor = [UIColor clearColor];
//    self.guaidWindow.windowLevel = UIWindowLevelStatusBar + 1;
//    [self.guaidWindow makeKeyAndVisible];
//
//    KSGuaidViewController* vc = [[KSGuaidViewController alloc] init];
//
//    __weak typeof(self) weakSelf = self;
//
//    vc.shouldHidden = ^{
//
//        NSString* curtVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
////        if (kIsShowLaunchController) {
//            [[NSUserDefaults standardUserDefaults] setObject:curtVersion forKey:kLastVersionKey];
////        }
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//        [weakSelf.guaidWindow resignKeyWindow];
//
//        weakSelf.guaidWindow.hidden = YES;
//        weakSelf.guaidWindow = nil;
//    };
//
//    self.guaidWindow.rootViewController = vc;
    
    return finish;
}

- (void)guideViewDidFinished:(YXGuideView *)guideView {
    [self.guaidWindow resignKeyWindow];
    self.guaidWindow.hidden = YES;
    self.guaidWindow = nil;
}
- (UIWindow *)guaidWindow{
    return  objc_getAssociatedObject(self, kGuaidWindowKey);
}
- (void)setGuaidWindow:(UIWindow *)guaidWindow{
    objc_setAssociatedObject(self, kGuaidWindowKey, guaidWindow, OBJC_ASSOCIATION_RETAIN);
}

@end
