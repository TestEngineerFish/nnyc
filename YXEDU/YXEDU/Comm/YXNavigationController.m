//
//  YXNavigationController.m
//  YXEDU
//
//  Created by shiji on 2018/5/16.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXNavigationController.h"

@interface YXNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property(nonatomic,weak) UIViewController* currentShowVC;
@end

@implementation YXNavigationController

//- (id)initWithRootViewController:(UIViewController *)rootViewController {
//    YXNavigationController* nvc = [super initWithRootViewController:rootViewController];
//    self.interactivePopGestureRecognizer.delegate = self;
//    nvc.delegate = self;
//    return nvc;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak YXNavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
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
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
    [super pushViewController:viewController animated:animated];
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
     if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ){
         self.interactivePopGestureRecognizer.enabled = NO;
     }
     
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ( gestureRecognizer ==self.interactivePopGestureRecognizer ) {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ){
            return NO;
        }
    } return YES;
}

@end
