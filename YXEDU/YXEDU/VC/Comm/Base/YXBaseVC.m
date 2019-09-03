//
//  YXBaseVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseVC.h"
#import "BSCommon.h"

@interface YXBaseVC ()

@end

@implementation YXBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0xf0f0f0);
    self.navigationType = NavigationTransparent;
    
    if (self.backType == BackGray) {
        if (self.transType == TransationPop || self.navigationController.viewControllers.count>1) {
            [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back_gray"]];
        }
    } else if (self.backType == BackWhite) {
        if (self.transType == TransationPop || self.navigationController.viewControllers.count>1) {
            [self addLeftBarButtonWithImage:[UIImage imageNamed:@"back_white"]];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置导航栏背景图片为一个空的image，这样就透明了
    if (self.navigationType == NavigationTransparent) {
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        
        //去掉透明后导航栏下边的黑边
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    } else if (self.navigationType == NavigationBlue) {
        self.navigationController.navigationBar.barTintColor = UIColorOfHex(0x4DB3FE);
    }
    
    if (self.textColorType == TextColorBlack) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    } else if (self.textColorType == TextColorWhite) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    如果不想让其他页面的导航栏变为透明 需要重置
    if (self.navigationType == NavigationDefault) {
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
}


- (void)addLeftBarButtonWithImage:(UIImage *)image {
    [self addLeftBarButtonWithImage:image action:@selector(back)];
}

- (void)back {
    if (self.transType == TransationPresent && self.navigationController.viewControllers.count==1) {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }else if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}


- (void)dealloc {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
