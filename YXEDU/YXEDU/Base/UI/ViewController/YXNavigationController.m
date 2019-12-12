//
//  YXNavigationController.m
//  YXEDU
//
//  Created by shiji on 2018/5/16.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXNavigationController.h"
#import "YXExerciseVC.h"
//#import "YXPersonalBookVC.h"
@interface YXNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIViewController* currentShowVC;
@end

@implementation YXNavigationController

+ (void)initialize {
    UINavigationBar *globalNaviBar = [UINavigationBar appearance];
    [globalNaviBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:19]}];
    //NSString *naviBGImageName = iPhoneX ? @"com_top_nav" : @"com_top_nav";
    [globalNaviBar setBackgroundImage:[UIImage imageNamed:@"com_top_nav"] forBarMetrics:UIBarMetricsDefault];
    [globalNaviBar setShadowImage:[UIImage imageNamed:@"com_nav_shadow"]];
    
    //[globalNaviBar setShadowImage:[UIImage imageWithColor:shadowColor andSize:CGSizeMake(SCREEN_WIDTH, 6)]];
    globalNaviBar.barTintColor = [UIColor whiteColor];
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak YXNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (void)dealloc {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (navigationController.viewControllers.count == 1)
//        self.currentShowVC = Nil;
//    else
//        self.currentShowVC = viewController;
//}
//
//-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
//        return (self.currentShowVC == self.topViewController);
//    }
//    return YES;
//}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        [self setUpleftBarButtonItemOfViewController:viewController];
    }
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
}

- (void)setUpleftBarButtonItemOfViewController:(UIViewController *)viewController {
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [viewController setHidesBottomBarWhenPushed:YES];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"  " forState:UIControlStateNormal];
        //    UIImage *image = [UIImage imageNamed:@"back_white"];
        //    [button setImage:image forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"comNaviBack_white_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"comNaviBack_white_press"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 50, 44);// CGSizeMake(80, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backBtn = button;
    }
    return _backBtn;
}

- (void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
//        for (UIViewController *viewController in viewControllers) {
//            [self setUpleftBarButtonItemOfViewController:viewController];
//        }
        [self setUpleftBarButtonItemOfViewController:viewControllers.lastObject];
    }
    [super setViewControllers:viewControllers animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return  [super popToRootViewControllerAnimated:animated];
    
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ){
        return nil;
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                     animated:(BOOL)animate
 {
     if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
         self.interactivePopGestureRecognizer.enabled = YES;
       // Enable the gesture again once the new controller is shown
     if ( self.viewControllers.count < 2 ){
         //|| [viewController isKindOfClass:[YXExerciseVC class]] || [viewController isKindOfClass:[YXPersonalBookVC class]]
         self.interactivePopGestureRecognizer.enabled = NO;
     }else {
         if ([viewController isKindOfClass:[BSRootVC class]]) {
             BSRootVC *baseVC = (BSRootVC *)viewController;
             self.interactivePopGestureRecognizer.enabled = baseVC.popGestureRecognizerEnabled;
         }
     }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer ==self.interactivePopGestureRecognizer ) {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ){
            return NO;
        }
        [self.visibleViewController.view endEditing:YES];
    }
    
    return YES;
}

@end
