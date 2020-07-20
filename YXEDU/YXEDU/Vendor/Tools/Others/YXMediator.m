//
//  YXMediator.m
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMediator.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "BaiduLocManager.h"
#import "IQKeyboardManager.h"
#import "BSCommon.h"
#import "YXAPI.h"
#import "NetWorkRechable.h"
#import "YXUtils.h"
#import "SJCall.h"
#import "YXVersionModel.h"

// #import "AppDelegate.h"
#import "Growing.h"

@interface YXMediator ()
@property (nonatomic, weak) UIAlertController *kickedOutAlertVC;
@end

@implementation YXMediator

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)shared {
    static YXMediator *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [YXMediator new];
    });
    return shared;
}

- (void)userKickedOut {
    
    if (_kickedOutAlertVC) {
        return;
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = app.window;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[YXUserModel default] logoutWithForce:NO finished:nil];
    }];
    [alert addAction:cancelAction];
    
    if (mainWindow.rootViewController.presentedViewController != nil) {
        [mainWindow.rootViewController dismissViewControllerAnimated:NO completion:^{
            [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
        }];
    }else {
        [mainWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
    _kickedOutAlertVC = alert;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"tencent101475072"]) {
        [[QQApiManager shared] handleOpenURL:url];
    } else {
        [[WXApiManager shared] handleOpenURL:url];
    }
    return YES;
}

-(BOOL)handleOpenUnivrsalLinkURL:(NSUserActivity *)userActivity {
    NSString *urlPre = [NSString stringWithFormat:@"%@%@", universalLink, wechatId];
    if ([userActivity.webpageURL.absoluteString hasPrefix:urlPre]) {
        return [[WXApiManager shared] handleOpenUniversalLink:userActivity];
    } else {
        return [TencentOAuth HandleUniversalLink:userActivity.webpageURL];
    }
}


@end
