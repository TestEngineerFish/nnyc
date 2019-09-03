//
//  AppDelegate.m
//  YXEDU
//
//  Created by shiji on 2018/3/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "AppDelegate.h"
#import "YXMediator.h"
#import "YXCrashReport.h"
#import "YXConfigure.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"-----------------------%@", NSHomeDirectory());
    [YXCrashReport shared];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [YXMediator shared].window = self.window;
//
    [[YXMediator shared]configure];
    
    //
    if ([YXConfigure shared].mobile.length) {
        [[YXMediator shared]showMainVC];
    } else {
        [[YXMediator shared]showLoginVC];
    }
    
    [self.window makeKeyAndVisible];
    
    if (![YXConfigure shared].isShowGuideView) {
        [[YXMediator shared]showGuideView];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[YXMediator shared]handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YXMediator shared]registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    
}



@end
