//
//  YXRouteManager.m
//  YXEDU
//
//  Created by yao on 2019/1/7.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXRouteManager.h"
#import "YXBaseWebViewController.h"
#import "YXCalendarViewController.h"

@interface YXRouteManager ()
@property (nonatomic, copy) NSDictionary *pathRouteSelecter;
@property (nonatomic, copy) NSArray *nnCareerMarks;
@end

@implementation YXRouteManager
+ (instancetype)shared {
    static YXRouteManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[YXRouteManager alloc] init];
    });
    return shared;
}

- (void)openUrl:(NSString *)url {
    [self openUrl:url title:nil];
}

- (void)openUrl:(NSString *)url title:(NSString *)title {
    UIViewController *roovc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if ([url hasPrefix:@"https://"] || [url hasPrefix:@"http://"]) {
//        if ([roovc isKindOfClass:[YXTabBarViewController class]]) {
//            YXTabBarViewController *tabVC = (YXTabBarViewController *)roovc;
//            UIViewController *selectedVC = [tabVC selectedViewController];
//            if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                [self pushWebView:url title:title pushedNaviController:(UINavigationController *)selectedVC];
//            }
//        }else if([roovc isKindOfClass:[UINavigationController class]]) {
//            [self pushWebView:url title:title pushedNaviController:(UINavigationController *)roovc];
//        }
    }else if([url hasPrefix:@"nnyc://"]){ // 页面内跳转协议
//        if ([roovc isKindOfClass:[YXTabBarViewController class]]) {
//            YXTabBarViewController *tabVC = (YXTabBarViewController *)roovc;
//            UIViewController *selectedVC = [tabVC selectedViewController];
//            if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//                UINavigationController *selectedNaviVC = (UINavigationController *)selectedVC;
//                [selectedNaviVC popViewControllerAnimated:NO];
//
//                NSArray *pathParams = [url componentsSeparatedByString:@"?"];
//                NSString *path = pathParams.firstObject;
//                NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
//                NSArray *param = [components queryItems];
//                SEL selector = NSSelectorFromString([self.pathRouteSelecter objectForKey:path]);//NSStringFromSelector();
//                if ([self respondsToSelector:selector]) {
//                    IMP imp = [self methodForSelector:selector];
//                    void(*func)(id,SEL,id) = (void *)imp;
//                    func(self,selector,param);
//                }
//            }
//        }
    }
}

- (void)openInsideUrl:(NSString *)url {
    UIViewController *roovc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([url hasPrefix:@"nnyc://"]){ // 页面内跳转协议
//        if ([roovc isKindOfClass:[YXTabBarViewController class]]) {
//            YXTabBarViewController *tabVC = (YXTabBarViewController *)roovc;
//            UIViewController *selectedVC = [tabVC selectedViewController];
//            if ([selectedVC isKindOfClass:[UINavigationController class]]) {
//
//                NSArray *pathParams = [url componentsSeparatedByString:@"?"];
//                NSString *path = pathParams.firstObject;
//                NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
//                NSArray *param = [components queryItems];
//                SEL selector = NSSelectorFromString([self.pathRouteSelecter objectForKey:path]);
//                if ([self respondsToSelector:selector]) {
//                    IMP imp = [self methodForSelector:selector];
//                    void(*func)(id,SEL,id) = (void *)imp;
//                    func(self,selector,param);
//                }
//            }
//        }
    }
}

- (void)switchTabSelected:(NSArray *)params {
    NSURLQueryItem *item = params.firstObject;
    [self switchTabWithTabName:item.value];
}

- (void)enterNNCareerWith:(NSArray *)params {
    [self switchTabWithTabName:@"main"];
    NSURLQueryItem *item = params.firstObject;
    NSInteger index = [self.nnCareerMarks indexOfObject:item.value];
    
    UITabBarController *tabbarVC = [self rootTabbar];
    if (tabbarVC && index != NSNotFound) {
        UINavigationController *naviVC = tabbarVC.selectedViewController;
        if ([naviVC.visibleViewController isKindOfClass:[YXHomeViewController class]]) {
//            [(YXHomeViewController *)naviVC.visibleViewController enterMyCareer:index];
        }
    }
}


- (void)checkReport:(NSArray *)params {
    [self switchTabWithTabName:@"main"];
    UITabBarController *tabbarVC = [self rootTabbar];
    if (tabbarVC) {
        UINavigationController *naviVC = tabbarVC.selectedViewController;
        if ([naviVC.visibleViewController isKindOfClass:[YXHomeViewController class]]) {
//            [(YXHomeViewController *)naviVC.visibleViewController enterReportVC];
        }
    }
}

- (void)checkTask:(NSArray *)params {
    [self switchTabWithTabName:@"main"];
    UITabBarController *tabbarVC = [self rootTabbar];
    if (tabbarVC) {
        UINavigationController *naviVC = tabbarVC.selectedViewController;
        if ([naviVC.visibleViewController isKindOfClass:[YXHomeViewController class]]) {
            [(YXHomeViewController *)naviVC.visibleViewController enterTaskVC];
        }
    }
}

- (void)punchCalendar:(NSArray *)params {
    UIViewController *vc = [[UIViewController alloc] init].currentVC;
    if (vc.navigationController) {
        YXCalendarViewController *calendarVC = [[YXCalendarViewController alloc] init];
        calendarVC.transType = TransationPop;
        [vc presentViewController:calendarVC animated:YES completion:nil];
    }
}


- (void)switchTabWithTabName:(NSString *)tabName {
    NSInteger index = [self.tabNamesArray indexOfObject:tabName];
    UITabBarController *tabbarVC = [self rootTabbar];
    if (tabbarVC && index < tabbarVC.viewControllers.count) {
        tabbarVC.selectedIndex = index;
    }
}

- (UITabBarController *)rootTabbar {
//    UIViewController *roovc = [UIApplication sharedApplication].delegate.window.rootViewController;
//    if ([roovc isKindOfClass:[YXTabBarViewController class]]) {
//        return (YXTabBarViewController *)roovc;
//    }else {
        return nil;
//    }
}

- (void)pushWebView:(NSString *)link title:(NSString *)title pushedNaviController:(UINavigationController *)naviVC{
    YXBaseWebViewController *webVC = [[YXBaseWebViewController alloc] initWithLink:link title:title];
    if ([link isEqualToString:DOMAIN_AGREEMENT]) {
        webVC.isLogin = YES;
    }
    [naviVC pushViewController:webVC animated:YES];
}

#pragma mark - baseData
- (NSMutableArray *)tabNamesArray {
    if (!_tabNamesArray) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"tabBarArray.plist"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSMutableArray *tabBarList = [NSMutableArray array];
        NSMutableArray *namesArray = [NSMutableArray array];
        if ([fileManager fileExistsAtPath:path]) {
            tabBarList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            for (YXTabBarModel *model in tabBarList) {
                [namesArray addObject:model.titleEn];
            }
        } else {
            namesArray = [NSMutableArray arrayWithArray:@[@"main", @"find", @"user"]];
        }
        _tabNamesArray = [namesArray copy];
    }
    return _tabNamesArray;
}

- (NSArray *)nnCareerMarks {
    if (!_nnCareerMarks) {
        _nnCareerMarks = @[@"learned",@"collect",@"wrong"];
    }
    return _nnCareerMarks;
}

- (NSDictionary *)pathRouteSelecter {
    if (!_pathRouteSelecter) {
        _pathRouteSelecter = @{
                               @"nnyc://main/home"       : @"switchTabSelected:",
                               @"nnyc://word/note"       : @"enterNNCareerWith:",
                               @"nnyc://study/report"    : @"checkReport:",
                               @"nnyc://task/manager"    : @"checkTask:",
                               @"nnyc://punch/calendar"  : @"punchCalendar:"
                               };
    }
    return _pathRouteSelecter;
}
@end
