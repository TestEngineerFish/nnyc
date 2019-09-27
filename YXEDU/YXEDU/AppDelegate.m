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
#import "YXMainVC.h"
#import "YXLoginVC.h"
#import "YXSelectBookVC.h"
#import "YXNavigationController.h"
#import "YXGuideView.h"
#import "BSCommon.h"
#import <UMCommon/UMCommon.h>
#import "YXBindPhoneVC.h"
#import "YXTabBarViewController.h"
#import "Growing.h"
#import "YXMyWordListDetailModel.h"
#import "YXWordDetailShareView.h"
#import "YXMyWordBookDetailVC.h"
#import "YXExerciseVC.h"
#import "YXGameViewController.h"
#import "YXReportViewController.h"
#import "YXWordDetailViewController.h"
#import "BSUtils.h"
#import "YXUserSaveTool.h"
#import "YXBookSettingViewController.h"
#import "YXStudyProgressView.h"
#import "YXPosterShareView.h"
#import "LEEAlert.h"
#import "YXBaseWebViewController.h"
#import "YXStudyResultVC.h"
#import "YXPersonalBookVC.h"
#import "YXMyWordBookListVC.h"
#import "Reachability.h"


@interface AppDelegate ()<YXWordDetailShareViewDelegate>
@property (nonatomic, strong)NSDate *becomeActiveDate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(@"-----------------------%@", NSHomeDirectory());
    [YXCrashReport shared];
    if (@available(iOS 11.0, *)) {  
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //中间件配置
    [[YXMediator shared] configure];
    //是否已经登录
    if ([YXConfigure shared].token.length) {
        [self showMainVC];
    } else {
        [self showLoginVC];
    }

    [self setUpUmengSDK];
    //埋点配置
    [self configGrowingIO];
    [self.window makeKeyAndVisible];
    //添加网络监控
    [[Reachability reachabilityForInternetConnection] startNotifier];
//    if (![YXConfigure shared].isShowGuideView) {
//        [self showGuideView];
//    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    //移除 YXWordDetailShareView
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([view isKindOfClass:[YXWordDetailShareView class]]) {
            [view removeFromSuperview];
        }
    }
    
}



- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //移除 YXWordDetailShareView
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        if ([view isKindOfClass:[YXWordDetailShareView class]] || [view isKindOfClass:[YXStudyProgressView class]] || [view isKindOfClass:[YXComAlertView class]] || [view isKindOfClass:[YXPosterShareView class]] || [view isKindOfClass:[YXTipsBaseView class]] ) {
            [view removeFromSuperview];
        }
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [LEEAlert closeWithCompletionBlock:nil];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.becomeActiveDate];
    [MobClick event:kTraceAppTime attributes:@{
                                               kTraceTime : [NSString stringWithFormat:@"%.f",interval],
                                               }];
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    //选择词书、
    UIViewController *currentViewController = [self currentViewController];
    
    
    
    if ([currentViewController isKindOfClass:[YXBaseWebViewController class]]){
        
        YXBaseWebViewController *baseWebViewController = (YXBaseWebViewController *)currentViewController;
        if (baseWebViewController.isLogin){
            NSLog(@"流程中...");
        }
        else{
            [self checkPasteboard];
        }
    }
    
    else if ([currentViewController isKindOfClass:[YXWordDetailViewController class]]){
        
        YXWordDetailViewController *wordDetailViewController = (YXWordDetailViewController *)currentViewController;
        if (wordDetailViewController.isExercise){
            NSLog(@"在学习流程中...");
        }
        else{
            [self checkPasteboard];
        }
    }
    
    else if ([currentViewController isKindOfClass:[YXSelectBookVC class]]){
        
        YXSelectBookVC *selectBookVC = (YXSelectBookVC *)currentViewController;
        if (selectBookVC.isFirstLogin){
            NSLog(@"流程中...");
        }
        else{
            [self checkPasteboard];
        }
    }
    
    else if ([currentViewController isKindOfClass:[YXBookSettingViewController class]]){
        
        YXBookSettingViewController *selectBookVC = (YXBookSettingViewController *)currentViewController;
        if (selectBookVC.isFirstLogin){
            NSLog(@"流程中...");
        }
        else{
            [selectBookVC dismissViewControllerAnimated:YES completion:nil];
            [self checkPasteboard];
        }
    }
    
    else if ([currentViewController isKindOfClass:[YXMainVC class]]){
        
        YXMainVC *mainVC = (YXMainVC *)currentViewController;
        [mainVC loadConfig];
    }
    
    else if ([currentViewController isKindOfClass:[YXExerciseVC class]] || [currentViewController isKindOfClass:[YXGameViewController class]]|| [currentViewController isKindOfClass:[YXLoginVC class]]||[currentViewController isKindOfClass:[YXSelectBookVC class]]||[currentViewController isKindOfClass:[YXBookSettingViewController class]] || [currentViewController isKindOfClass:[YXBaseWebViewController class]] || [currentViewController isKindOfClass:[YXStudyResultVC class]] || [currentViewController isKindOfClass:[YXMainVC class]])  {
        //清除复制板内容 YXBookSettingViewControllerYXBaseWebViewController  YXMyWordBookListVC
        //[[UIPasteboard generalPasteboard] setString:@""];  YXStudyResultVC  YXPersonalBookVC   loadConfig
    }
    
    else {
        [self checkPasteboard];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    self.becomeActiveDate = [NSDate date];
    
}

-(void)checkPasteboard {
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    
    //获取正则规则
    NSString *popUpRule = [YXConfigure shared].confModel.baseConfig.popUpRule;
    if (![BSUtils isBlankString:popUpRule]) {
        [YXUserSaveTool setObject:popUpRule forKey:@"popUpRule"];
    }
    else {
        popUpRule = [YXUserSaveTool valueForKey:@"popUpRule"];
    }
    
    if ((![BSUtils isBlankString:string]) && (![BSUtils isBlankString:popUpRule])){
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",string];
        NSString *result = [self subStringComponentsSeparatedByStrContent:tempStr strPoint:@"￥" firstFlag:1 secondFlag:2];
        NSLog(@"result %@",result);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", popUpRule];
        
        if ([predicate evaluateWithObject:result]) {
            [self showWordListView:result];
        }
    }
}

//查询复制码 对应的词单

-(void)showWordListView:(NSString *)code{
    
    if (code.length) {
        NSDictionary *param = @{@"shareCode" : code};
        [YXDataProcessCenter GET:DOMAIN_SHARECODEWORDLIST
                      parameters:param
                    finshedBlock:^(YRHttpResponse *response, BOOL result)
         {
             if (result) {
                 
                 NSDictionary *details = [response.responseObject objectForKey:@"wordListSimplifiedDetails"];
                 NSLog(@"details %@",details);
                 
                 YXMyWordListDetailModel *detailModel = [YXMyWordListDetailModel mj_objectWithKeyValues:details];
                 
                 //移除 YXWordDetailShareView
                 for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
                     if ([view isKindOfClass:[YXWordDetailShareView class]]) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
                 
             }else {
                 
                 YXMyWordListDetailModel *detailModel =  [YXMyWordListDetailModel alloc];
                 detailModel.code = response.error.code;
                 //移除 YXWordDetailShareView
                 for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
                     if ([view isKindOfClass:[YXWordDetailShareView class]]) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
//                 [YXUtils showHUD:nil title:response.error.desc];
             }
         }];
    }
}



- (void)applicationWillTerminate:(UIApplication *)application {
    
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [Growing handleUrl:url];
    return [[YXMediator shared]handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[YXMediator shared]registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([Growing handleUrl:url]) {
        return YES;
    }
    return NO;
}

#pragma mark - 跟控制器切换
- (void)showMainVC {
    YXTabBarViewController *tabBarVC = [[YXTabBarViewController alloc] init];
    self.window.rootViewController = tabBarVC;
}

- (void)showSelectVC {
    YXSelectBookVC *versionVC = [[YXSelectBookVC alloc]init];
    __weak typeof(self) weakSelf = self;
    versionVC.selectedBookSuccessBlock = ^{
        [weakSelf showMainVC];
    };
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

//拿到当前的控制器
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}


#pragma mark - verndor config
- (void)setUpUmengSDK {
    [UMConfigure initWithAppkey:kUmengAppKey channel:@"App Store"];
}


/** 配置GrowingIO
 * @describution 念念有词iOSTest       growing.3978e7f7342055dd
 * 您好，两个环境是两个包名，您可以用域名这个预定义维度拆分指标，对于移动端来说，域名维度拆分的是移动端的包名。
 */
- (void)configGrowingIO {
    [Growing startWithAccountId:kGrowingIOID];
}

#pragma mark - YXWordDetailShareViewDelegate
- (void)YXWordDetailShareViewSureDetailModel:(YXMyWordListDetailModel *)detailModel{
    YXMyWordBookDetailVC *detailVC = [[YXMyWordBookDetailVC alloc] initWithMyWordBookModel:detailModel];
    detailVC.isOwnWordList = detailModel.isSelf;
    
    UIViewController * currVC =  [self currentViewController];
    
    for (UIView *view in [currVC.view subviews]) {
        
        if ([view isKindOfClass:[YXStudyProgressView class]] || [view isKindOfClass:[YXComAlertView class]] || [view isKindOfClass:[YXPosterShareView class]] || [view isKindOfClass:[YXTipsBaseView class]] )
            
            [view removeFromSuperview];
    }
    
    
    if ([currVC isKindOfClass:[YXMainVC class]]) {
        for (UIView *view in [currVC.tabBarController.view subviews]) {
            if ([view isKindOfClass:[YXStudyProgressView class]])
                [view removeFromSuperview];
        }
    }
    
    [[self currentViewController].navigationController pushViewController:detailVC animated:YES];
}

- (void)YXWordDetailShareViewSureDetailReload{
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    if (![BSUtils isBlankString:string]){
        [self showWordListView:string];
    }
}



#pragma mark - 封装一个截取字符串中同一个字符之间的字符串
/**
 参数说明：
 1.strContent:传入的目标字符串
 2.strPoint:标记位的字符
 3.firstFlag:从第几个目标字符开始截取
 4.secondFlag:从第几个目标字符结束截取
 */
- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag
{
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    //异常处理、未找到开始结束的位置、或者只找到开头
    if ((startRange.location == endRange.location)||(startRange.location > endRange.location)) {
        return @"";
    }
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    NSLog(@"截取到的 strResult = %@", result);
    // 最后将结果返回出去
    return result;
}

@end
