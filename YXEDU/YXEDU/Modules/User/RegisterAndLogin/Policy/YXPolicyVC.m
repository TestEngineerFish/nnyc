//
//  YXPolicyVC.m
//  YXEDU
//
//  Created by shiji on 2018/3/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPolicyVC.h"
#import "BSCommon.h"
#import "YXAPI.h"

@interface YXPolicyVC ()<WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *webView;
@end

@implementation YXPolicyVC
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] init];
        webView.navigationDelegate = self;
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;

    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:STRCAT(STRCAT(SCHEME,YX_IP),@"/privacy.html")]];//
    [self.webView loadRequest:request];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadNoSignalView];
}

- (void)reloadNoSignalView {
    [super reloadNoSignalView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

@end
