//
//  YXSelectBookVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookVC.h"
#import "BSCommon.h"
#import "YXSelectBookCell.h"
#import "YXBookListViewModel.h"
#import "YXUtils.h"
#import "YXSelectBookContentVC.h"
#import "YXConfigure.h"


@interface YXSelectBookVC () <VTMagicViewDataSource, VTMagicViewDelegate>
@property (nonatomic, strong) YXBookListViewModel *bookListViewModel;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation YXSelectBookVC
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bookListViewModel = [[YXBookListViewModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择词书";
    self.view.backgroundColor = UIColorOfHex(0xffffff);
    
    self.magicController.magicView.itemScale = 1;
    self.magicController.magicView.sliderExtension = 10.0f;
    self.magicController.magicView.navigationInset = UIEdgeInsetsMake(10, 15, 10, 10);
    self.magicController.magicView.itemWidth = 88.0f;
    self.magicController.magicView.itemSpacing = 10.0f;
    self.magicController.magicView.bubbleInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.magicController.magicView.sliderColor = [UIColor clearColor];
    self.magicController.magicView.separatorColor = UIColorOfHex(0xe6e6e6);
    [self.magicController.magicView setHeaderHidden:YES duration:0];
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    [self.view setNeedsUpdateConstraints];
    
    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 1)];
    self.lineView.backgroundColor = UIColorOfHex(0xe6e6e6);
    [self.view addSubview:self.lineView];
    
    [_magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestConfigure];
    [self reloadNoSignalView];
}

- (void)refreshBtnClicked {
    [super refreshBtnClicked];
    [self requestConfigure];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[magicView]-0-|", NavHeight]
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
}

- (void)leftBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestConfigure {
    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    __weak YXSelectBookVC *weakSelf = self;
    [self.bookListViewModel requestConfigure:^(id obj, BOOL result) {
        [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
        [_magicController.magicView reloadData];
    }];
}


- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return [self.bookListViewModel titleArr];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:@"title"];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
        menuItem.titleLabel.font = [UIFont systemFontOfSize:10];
        [menuItem setBackgroundImage:[UIImage imageNamed:@"select_title_selected"] forState:UIControlStateSelected];
        [menuItem setBackgroundImage:[UIImage imageNamed:@"select_title_unselected"] forState:UIControlStateNormal];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    NSString *identifier = [NSString stringWithFormat:@"%@", @(pageIndex)];
    YXSelectBookContentVC *nativeVC = [magicView dequeueReusablePageWithIdentifier:identifier];
    if (!nativeVC) {
        nativeVC = [[YXSelectBookContentVC alloc] init];
    }
    nativeVC.transType = self.transType;
    [nativeVC insertGradeModel:[YXConfigure shared].conf3Model.config[pageIndex]];
    return nativeVC;
}

- (void)vtm_prepareForReuse {
}

#pragma mark - VTMagicViewDelegate

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
#ifdef DEBUG
    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
#endif
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
#ifdef DEBUG
    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
#endif
    
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
#ifdef DEBUG
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
#endif
}


- (VTMagicController *)magicController {
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.sliderStyle = VTSliderStyleBubble;
        _magicController.magicView.sliderExtension = 10.f;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
