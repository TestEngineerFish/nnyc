//
//  YXPolicyVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPolicyVC.h"
#import "BSCommon.h"
#import "YX_URL.h"

@interface YXPolicyVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *yxwebView;
@end

@implementation YXPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.yxwebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.yxwebView.delegate = self;
    [self.view addSubview:self.yxwebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://111.231.115.83:8081/agreement.html"]];
    [self.yxwebView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadNoSignalView];
}

- (void)reloadNoSignalView {
    [super reloadNoSignalView];
    
}

- (void)refreshBtnClicked {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://111.231.115.83:8081/agreement.html"]];
    [self.yxwebView loadRequest:request];
    [self reloadNoSignalView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
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
