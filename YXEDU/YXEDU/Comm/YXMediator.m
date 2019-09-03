//
//  YXMediator.m
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMediator.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "YXLoginVC.h"
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "BaiduLocManager.h"
#import "AVAudioPlayerManger.h"
#import "IQKeyboardManager.h"
#import "YXGuideView.h"
#import "BSCommon.h"
#import "YXConfigure.h"
#import "YXCommHeader.h"
#import "JPushManager.h"
#import "NetWorkRechable.h"
#import "YXNavigationController.h"
#import "YXHomeVC.h"
#import "YXSelectBookVC.h"
#import "YXUtils.h"
#import "YXStudyRecordCenter.h"
#import "YXModelArchiverManager.h"
#import "YXComHttpService.h"
#import "SJCall.h"

@interface YXMediator ()

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
    
    [[WXApiManager shared]registerWX:wechatId];
    [[QQApiManager shared]registerQQ:qqId];
    [NetWorkRechable shared];
    [[AVAudioPlayerManger shared]configuration];
    [[BaiduLocManager shared]registerBaiduKey:baiduId];
    [[BaiduLocManager shared]startLocation:^(CLLocation *obj) {
        [YXConfigure shared].location = obj;
    }];
    
    [[JPushManager shared]registerJPush:jpushId];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [YXConfigure shared].needSpreadAnimation = YES;
    [YXUtils removeScreenShout];
    [self checkVersion];
    [[SJCall shareInstance]carrierInfo:^(SJCarrierInfo *carrier) {
        
    }];
    
    
}

- (void)afterLogout {
    [[YXModelArchiverManager shared] clearAllMemory];
    [YXConfigure shared].mobile = @"";
    [YXConfigure shared].token = @"";
    [self showLoginVC];
}


- (void)showMainVC {
    YXHomeVC *backVC = [[YXHomeVC alloc]init];
    YXNavigationController *mainNav = [[YXNavigationController alloc]initWithRootViewController:backVC];
    self.window.rootViewController = mainNav;
}

- (void)showSelectVC {
    YXSelectBookVC *versionVC = [[YXSelectBookVC alloc]init];
    YXNavigationController *versionNav = [[YXNavigationController alloc]initWithRootViewController:versionVC];
    self.window.rootViewController = versionNav;
}

- (void)showLoginVC {
    YXLoginVC *loginVC = [[YXLoginVC alloc]init];
    YXNavigationController *loginNav = [[YXNavigationController alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = loginNav;
}

- (void)showGuideView {
    YXGuideView *guideView = [[YXGuideView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.window addSubview:guideView];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"tencent101475072"]) {
        [[QQApiManager shared] handleOpenURL:url];
    } else {
        [[WXApiManager shared] handleOpenURL:url];
    }
    return YES;
}

- (void)checkVersion {
    YXVersionModel *versionModel = [[YXVersionModel alloc]init];
    versionModel.pf = @"ios";
    versionModel.channel = @"";
    versionModel.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[YXComHttpService shared]checkVersion:versionModel complete:^(id obj, BOOL result) {
        if (result) {
            YXVersionResModel *resModel = obj;
            if (resModel.update.flag.intValue == 1) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"报告小主！发现新版本，快点我更新！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { NSLog(@"action = %@", action); }];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resModel.update.url]];
                }];
                
                [alert addAction:defaultAction];
                [alert addAction:cancelAction];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            } else if (resModel.update.flag.intValue == 2) {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"大事不好了！当前版本过低，请更新后继续使用！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resModel.update.url]];

                }];
                [alert addAction:cancelAction];
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            
        }
    }];
}


// jpush
- (void)registerDeviceToken:(NSData *)deviceToken {
    [[JPushManager shared]registerDeviceToken:deviceToken];
}


@end
