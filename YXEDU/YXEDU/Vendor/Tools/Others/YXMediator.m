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
#import "AVAudioPlayerManger.h"
#import "IQKeyboardManager.h"
#import "YXGuideView.h"
#import "BSCommon.h"
#import "YXConfigure.h"
#import "YXAPI.h"
//#import "JPushManager.h"
#import "NetWorkRechable.h"
#import "YXNavigationController.h"
#import "YXUtils.h"
#import "YXStudyRecordCenter.h"
#import "YXModelArchiverManager.h"
#import "YXComHttpService.h"
#import "SJCall.h"
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

- (void)configure {
    
    [[WXApiManager shared] registerWX:wechatId];
//    [[QQApiManager shared] registerQQ:qqId];
    [NetWorkRechable shared];
    
    [[AVAudioPlayerManger shared] configuration];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"收起";
    [YXConfigure shared].needSpreadAnimation = YES;
    //    [YXUtils removeScreenShout];
    [self checkVersion];
    [[SJCall shareInstance]carrierInfo:^(SJCarrierInfo *carrier) {
        
    }];
    [[BaiduLocManager shared] registerBaiduKey:baiduId];
    [[BaiduLocManager shared] startLocation:^(CLLocation *obj) {
        [YXConfigure shared].location = obj;
    }];
//    [[JPushManager shared] registerJPush:jpushId];
}



- (void)clearData {
    [[YXModelArchiverManager shared] clearAllMemory];
    [YXConfigure shared].mobile = @"";
    [[YXConfigure shared] saveToken:@""];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kCurrentLearnWordListIdKey];
    [defaults setObject:kDefaultWordListName forKey:kUnfinishedWordListNameKey];
    
    [[YXConfigure shared] loginOut];
}

- (void)afterLogout {
    [[YXModelArchiverManager shared] clearAllMemory];
    [YXConfigure shared].mobile = @"";
    [[YXConfigure shared] saveToken:@""];
    [[YXConfigure shared] loginOut];
    [self clearData];
    
    [[YXUserModel default] logout];
}

- (void)userKickedOut {
    [self clearData];
    
    if (_kickedOutAlertVC) {
        return;
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = app.window;
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号已在其他设备登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[YXUserModel default] logout];
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

- (void)tokenExpired {
    if ([YXConfigure shared].token.length) { //  防止被挤掉同时发请求报token失效
        [self clearData];
        
        [[YXUserModel default] logout];
    } else {
        [[YXUserModel default] logout];
    }
}


- (void)loginOut {
    [self clearData];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"tencent101475072"]) {
        [[QQApiManager shared] handleOpenURL:url];
    } else {
        [[WXApiManager shared] handleOpenURL:url];
    }
    return YES;
}

-(BOOL)handleOpenUnivrsalLinkURL:(NSURL *)url {
//    [QQApiInterface handleOpenURL:url delegate:(id<QQApiInterfaceDelegate>)[QQApiManager class]];
    return [TencentOAuth HandleUniversalLink:url];
}

- (void)checkVersion {
    YXVersionModel *versionModel = [[YXVersionModel alloc]init];
    versionModel.pf = @"ios";
    versionModel.channel = @"AppStore";
    versionModel.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[YXComHttpService shared] checkVersion:versionModel complete:^(id obj, BOOL result) {
        if (result) {
            YXVersionResModel *resModel = obj;
            if (resModel.update.flag.intValue == 1) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"报告小主！发现新版本，快点我更新！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { YXEventLog(@"action = %@", action); }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resModel.update.url]];
                }];
                
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
            } else if (resModel.update.flag.intValue == 2) {
//                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"大事不好了！当前版本过低，请更新后继续使用！" preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resModel.update.url]];
//                }];
//                [alert addAction:cancelAction];
//                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
                [self forceUpdate:resModel.update.url];
            }
        }
    }];
}

- (void)forceUpdate:(NSString *)appUrl {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"大事不好了！当前版本过低，请更新后继续使用！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        [self forceUpdate:appUrl];
    }];
    [alert addAction:cancelAction];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
// jpush
//- (void)registerDeviceToken:(NSData *)deviceToken {
//    [[JPushManager shared]registerDeviceToken:deviceToken];
//}


@end
