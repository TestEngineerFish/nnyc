//
//  YXTabBarViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/21.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXTabBarViewController.h"
#import "YXNavigationController.h"
#import "YXMainVC.h"
#import "YXDescoveryViewController.h"
#import "YXPersonalCenterVC.h"
#import "YXConfigModel.h"
#import "YXBaseWebViewController.h"

@interface YXTabBarViewController ()
@property (nonatomic, strong) NSArray<YXTabBarModel*> *tabBarList;
@end

@implementation YXTabBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTabBarAppearance];
    [self configureChildControllers];
}

- (NSArray *)tabBarList {
    if (!_tabBarList) {
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"tabBarArray.plist"];
        NSMutableArray *tabBarList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (!tabBarList) {
            tabBarList = [NSMutableArray array];
            YXTabBarModel *learnModel = [[YXTabBarModel alloc] init];
            learnModel.titleCh = @"学习";
            learnModel.titleEn = @"main";
            learnModel.selectedImageStr = @"learn_selected";
            learnModel.normalImageStr = @"learn_normal";
            [tabBarList addObject:learnModel];
            YXTabBarModel *challengeModel = [[YXTabBarModel alloc] init];
            challengeModel.titleCh = @"挑战";
            challengeModel.titleEn = @"find";
            challengeModel.selectedImageStr = @"challengeImage_selected";
            challengeModel.normalImageStr = @"challengeImage_normal";
            [tabBarList addObject:challengeModel];
            YXTabBarModel *profileModel = [[YXTabBarModel alloc] init];
            profileModel.titleCh = @"我的";
            profileModel.titleEn = @"user";
            profileModel.selectedImageStr = @"mineImage_selected";
            profileModel.normalImageStr = @"mineImage_normal";
            [tabBarList addObject:profileModel];
            [NSKeyedArchiver archiveRootObject:tabBarList toFile:path];
        }
         _tabBarList = [tabBarList copy];
    }
    return _tabBarList;
}

- (void)customTabBarAppearance {
    CGSize size = self.tabBar.frame.size;
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]
                                                  andSize:size];//[UIColor mRGBColor:248 :248 :248]
    self.tabBar.shadowImage = [UIImage imageNamed:@"tabbarShadow"];
    self.tabBar.translucent = NO;
}
- (void)configureChildControllers {

    for (YXTabBarModel *model in self.tabBarList) {
        if ([model.titleCh isEqualToString:@"学习"]) {
            // 首页
            YXMainVC *mainVC = [[YXMainVC alloc] init];
            [self setViewController:mainVC title:model.titleCh image:model.normalImageStr selectImage:model.selectedImageStr];
        } else if ([model.titleCh isEqualToString:@"挑战"]) {
            // 发现
            YXDescoveryViewController *descoverVC = [[YXDescoveryViewController alloc] init];
            [self setViewController:descoverVC title:model.titleCh image:model.normalImageStr selectImage:model.selectedImageStr];
        } else if ([model.titleCh isEqualToString:@"我的"]) {
            // 我的
            YXPersonalCenterVC *personalVC = [[YXPersonalCenterVC alloc] init];
            [self setViewController:personalVC title:model.titleCh image:model.normalImageStr selectImage:model.selectedImageStr];
        } else if ([model.titleCh isEqualToString:@"发现"]) {
            // 我的
            YXBaseWebViewController *personalVC = [[YXBaseWebViewController alloc] init];
            personalVC.link = model.url;
            [self setViewController:personalVC title:model.titleCh image:model.normalImageStr selectImage:model.selectedImageStr];
        }
    }
}

#pragma mark - 添加子控制器
-(void)setViewController:(UIViewController *)viewController title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage {
    CGFloat insertMargin = 0.0;
    viewController.tabBarItem.imageInsets = UIEdgeInsetsMake(insertMargin, 0, -insertMargin, 0);
    viewController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewController.tabBarItem.title = title;
    // 设置 tabbarItem 选中/未选中状态下的文字颜色(不被系统默认渲染,显示文字自定义颜色)
    NSDictionary *selectColor = [NSDictionary dictionaryWithObject:UIColorOfHex(0x58b2f8) forKey:NSForegroundColorAttributeName];
    [viewController.tabBarItem setTitleTextAttributes:selectColor forState:UIControlStateSelected];
    NSDictionary *unselectColor = [NSDictionary dictionaryWithObject:UIColorOfHex(0x8490b7) forKey:NSForegroundColorAttributeName];
    [viewController.tabBarItem setTitleTextAttributes:unselectColor forState:UIControlStateNormal];
    UINavigationController *nav = [[YXNavigationController alloc]initWithRootViewController:viewController];
    [self addChildViewController:nav];
}
@end
