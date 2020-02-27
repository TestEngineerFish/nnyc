//
//  YRRouter.m
//  pyyx
//
//  Created by sunwu on 2017/10/13.
//  Copyright © 2017年 朋友印象. All rights reserved.
//

#import "YRRouter.h"

@interface YRRouter() {
}

@end

@implementation YRRouter

+ (instancetype)sharedInstance {
    static YRRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

/**
 * 返回当前控制器
 */
- (UIViewController *)currentViewController {
    UIViewController* rootViewController = [self rootViewController];
    UIViewController *viewController = [self currentViewControllerFrom:rootViewController];
    
    return viewController;
}

/**
 * 返回当前的导航控制器
 */
- (UINavigationController*)currentNavigationController {
    return [[self currentViewController ] navigationController];
}


/**
 * 根据URL返回对应的ViewController
 * @param   url     url地址，可以是自定义scheme地址，也可以是http或者https地址
 * @param   query   页面所需要的参数，当前为字典类型
 */
+ (UIViewController *)viewControllerForURL:(id)url withQuery:(NSDictionary *)query {
    YRLocatorProvider *provider = [YRLocatorProvider sharedInstance];
    NSURL *aUrl = [provider processURL:url];
    UIViewController *viewController = [provider viewControllerForURL:aUrl withQuery:query];
    
    return viewController;
}


#pragma -mark *************************** push or present ****************************
// 建议使用 open URL方法，push和present方法虽然语义更直观，但从打开页面统一性上，open URL更有意义，因此屏蔽相关方法
/*
- (void)push:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated {
    [self push:url query:query animated:animated completion:nil];
}

- (void)push:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated completion:(void(^)()) completion {
    [YRRouter openURL:url query:query isPresent:NO animated:animated completion:completion];
}

- (void)present:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated {
    [self present:url query:query animated:animated completion:nil];
}

- (void)present:(NSString *) url query:(NSDictionary *)query animated:(BOOL) animated completion:(void(^)()) completion {
    [YRRouter openURL:url query:query isPresent:YES animated:animated completion:completion];
}
 */

#pragma -mark *************************** open URL ****************************

+ (void)openURL:(NSString *) url query:(NSDictionary * _Nullable) query animated:(BOOL) animated {
    [self openURL:url query:query isPresent:NO animated:animated completion:nil];
}

+ (void)openURL:(NSString *) url query:(NSDictionary *) query isPresent:(BOOL)present animated:(BOOL) animated {
    [self openURL:url query:query isPresent:present animated:animated completion:nil];
}

+ (void)openURL:(NSString *) url query:(NSDictionary *) query isPresent:(BOOL)present animated:(BOOL) animated completion:(void(^)(void)) completion{
    
    YRLocatorProvider *provider = [YRLocatorProvider sharedInstance];
    NSURL *aUrl = [provider processURL:url];
    //YRViewController *viewController = [provider viewControllerForURL:aUrl withQuery:query];
    UIViewController *viewController = [provider viewControllerForURL:aUrl withQuery:query];
    if (!viewController) {
        return;
    }
    
    UIViewController *topViewController = [[YRRouter sharedInstance] currentViewController];
    
    NSLog(@"Router openURL : %@", url);
    
    NSDictionary *params = viewController.params;
    //NSDictionary *params = [viewController performSelector:@selector(params)];
    if (present || [params.allKeys containsObject:@"present"]) {
        [topViewController presentViewController:viewController animated:animated completion:completion];
        
    } else {
        UINavigationController *navigationController = [[YRRouter sharedInstance] currentNavigationController];
        
        if (!navigationController) { // 导航控制器不存在
            // 控制器不存在
            [topViewController dismissViewControllerAnimated:NO completion:nil];
            topViewController = nil;
            
            UIViewController *tabvc = [[YRRouter sharedInstance] rootViewController];
            navigationController = ((UITabBarController *) tabvc).selectedViewController;
        }
        
        if ([self isTabViewController:viewController url:aUrl]) {
            // 几个tab页面，不用进行push
            return;
        }
        
        if (navigationController) { // 导航控制器存在
            if ([navigationController.viewControllers.lastObject isKindOfClass:[viewController class]]) {
                // 使用之前的页面属性，是否隐藏底部的tab bar
                viewController.hidesBottomBarWhenPushed = navigationController.viewControllers.lastObject.hidesBottomBarWhenPushed;
                
                // 切换当前导航控制器 需要把原来的子控制器都取出来重新添加
                NSArray *viewControllers = [navigationController.viewControllers subarrayWithRange:NSMakeRange(0, navigationController.viewControllers.count-1)];
                [navigationController setViewControllers:[viewControllers arrayByAddingObject:viewController] animated:animated];
            }
            else {
                // 进行push
                viewController.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:viewController animated:animated];
            }
            
        }
    }
    
}

#pragma -mark *************************** pop ViewController ****************************
/**
 * 基于当前页面，返回上一级页面
 */
+ (void)popViewController:(BOOL) animated{
    [YRRouter popViewController:@(1) animated:YES];
}

+ (void)popViewControllerWithURL:(NSString *) url animated:(BOOL) animated {
    YRLocatorProvider *provider = [YRLocatorProvider sharedInstance];
    
    NSURL *aUrl = [provider processURL:url];
    NSString *vcStr = [provider viewControllerStringWithURL:aUrl];
    
    [self popViewControllerWithString:vcStr animated:animated];
}

#pragma -mark ************ 以下几个方法不推荐直接使用
+ (void)popViewControllerWithIndex:(NSNumber *) index animated:(BOOL) animated {
    UIViewController *vc = [[YRRouter sharedInstance] currentViewController];
    UINavigationController *navi = vc.navigationController;
    
    NSUInteger selfIndex = [[navi viewControllers] indexOfObject:vc];
    UIViewController *targetVC = [[navi viewControllers] objectAtIndex:selfIndex - [index integerValue]];
    [navi popToViewController:targetVC animated:animated];
}

+ (void)popViewControllerWithClass:(Class) aClass animated:(BOOL) animated {
    UIViewController *vc = [[YRRouter sharedInstance] currentViewController];
    UINavigationController *navi = vc.navigationController;
    
    for (UIViewController *vc in navi.childViewControllers) {
        if ([vc isKindOfClass:aClass] ) {
            [navi popToViewController:vc animated:animated];
            break;
        }
    }
}

+ (void)popViewControllerWithString:(NSString *) string animated:(BOOL) animated {
    [self popViewControllerWithClass:NSClassFromString(string) animated:animated];
}


/**
 * 基于当前页面，返回到指定页面
 * @param      target   返回到指定页面
 *
 * target类型：【1/@"UIViewController"/Class/vcObj】
 * 可以是数字下标 / 可以是ViewController的字符串类名 / 可以是ViewController的Class / 还可以是ViewController的实例对象
 *
 * 当target是数字下标时，1 为返回一级，2为返回二级，以此类推。
 * 当target是ViewController的类名、Class或者实例对象，直接返回到此ViewController。
 */
+ (void)popViewController:(id) target animated:(BOOL) animated{
    UIViewController *vc = [[YRRouter sharedInstance] currentViewController];
    UINavigationController *navi = vc.navigationController;
    
    if ([target isKindOfClass:[NSNumber class]]) {// 1. 如果是数字下标
        [self popViewControllerWithIndex:target animated:animated];
    } else if ([target isKindOfClass:[NSString class]]) {// 2. 如果是VC类的字符串名称
        [self popViewControllerWithString:target animated:animated];
    } else if (NSStringFromClass(target)){// 3. 如果是VC类的class
        [self popViewControllerWithClass:target animated:animated];
    } else if ([target isKindOfClass:[UIViewController class]]) {// 4. 如果是VC类的实例变量
        [navi popToViewController:target animated:animated];
    }
}


#pragma -mark *********************** private ***********************

- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

- (UIViewController *)rootViewController {
    return [self applicationDelegate].window.rootViewController;
}
- (UIViewController *)selectedViewController {
    return [self currentViewControllerFrom:[self rootViewController]];
}


/*
 * 通过递归拿到当前控制器
 */
- (UIViewController*)currentViewControllerFrom:(UIViewController*)viewController {
    NSLog(@"%@", viewController.class);
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        // 如果传入的控制器是导航控制器,则返回最后一个
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self currentViewControllerFrom:navigationController.viewControllers.lastObject];
    } else if([viewController isKindOfClass:[UITabBarController class]]) {
        // 如果传入的控制器是tabBar控制器,则返回选中的那个
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self currentViewControllerFrom:tabBarController.selectedViewController];
    } else if(viewController.presentedViewController != nil) {
        // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
        return [self currentViewControllerFrom:viewController.presentedViewController];
    } else {
        return viewController;
    }
}


/**
 * 这是一段需要思考进行重新设计的代码，只是为了未来可能通过推送消息，选中某个tab页面,并且执行这个页面上的某个逻辑
 */
+ (BOOL)isTabViewController:(UIViewController *) viewController url:(NSURL *) url  {
    UITabBarController *tabVC = (UITabBarController *)[[YRRouter sharedInstance] rootViewController];
    
    NSArray *childVC = [tabVC childViewControllers];
    
    for (UINavigationController *navi in childVC) {
        // 有可能业务方直接在tabvc 上添加了 vc，这种情况下是没有viewControllers的，加个判断保护下
        if (![navi isKindOfClass:[UINavigationController class]]) {
            return NO;
        }
        NSArray *vcs = navi.viewControllers;
        UIViewController *tabItemVC = vcs[0];
        
        NSString *vcStr = NSStringFromClass([viewController class]);
        NSString *tabItemVCStr = NSStringFromClass([tabItemVC class]);
        
        if ([viewController isKindOfClass:[tabItemVC class]]
            && [vcStr isEqualToString:tabItemVCStr]) {
            
            // 当前选中的Tab页面返回到根页面
            UINavigationController *selectedNavi = tabVC.selectedViewController;
            [selectedNavi popToRootViewControllerAnimated:YES];
            
            // 延迟0.35秒，是因为上面返回根页面，和选中目标页面有冲突，造成底部 tab 消失不见了
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 选中目标 tab页面
                [tabVC setSelectedViewController:navi];
                [vcs[0] setURL:url query:nil];
            });
            
            

            //            if ([viewController isKindOfClass:[YRXXXXController class]]) {
            //                [vcs[0] setURL:url query:nil];
            //                [(YRXXXXController *)vcs[0] loadContent];
            //            }
            
            return YES;
        }
    }
    return NO;
}

@end

