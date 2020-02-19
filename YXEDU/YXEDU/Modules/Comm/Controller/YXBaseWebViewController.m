//
//  YXBaseWebViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "NSString+YX.h"
#import "UIFont+IconFont.h"
#import "YXRouteManager.h"

@interface YXBaseWebViewController ()<WKNavigationDelegate>
@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSURL *LinkUrl;
@property (nonatomic, assign) BOOL isLocalLink;
//
@property (nonatomic, strong) UIColor *orignColor;//保存title原始颜色
@property (nonatomic, strong) UIImage *originImage;// 保存nav原始图片
@property (nonatomic, strong) UIColor *currentColor;//后台通过URL传过来title的颜色
@property (nonatomic, strong) NSMutableArray *colorList;//后台传过来的背景色数组
//@property (nonatomic, strong) UIView *navBackgroundView;//显示后台传过来的渐变色view
@end

@implementation YXBaseWebViewController
+ (YXBaseWebViewController *)webViewControllerWithLink:(NSString *)link title:(NSString *)title {
    return [[self alloc] initWithLink:link title:title];
}

- (instancetype)initWithLink:(NSString *)link title:(NSString *)title {
    if (self = [super init]) {
        self.link = [link copy];
        self.title = [title copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.frame = self.view.bounds;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self loadLink];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.hideNavi) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, kStatusBarHeight, 50, 44);// CGSizeMake(80, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
    }else {
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
        [self.navigationController setNavigationBarHidden:NO animated:animated];

        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItems = @[button];
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor hex:0xffa83e alpha:1]];
        [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
//    if (self.currentColor) {
//        [self setTitleAndBackViewColor:self.currentColor];
//    }
//    if (self.colorList) {
//        if (self.navBackgroundView.isHidden) {
//            [self.navBackgroundView setHidden:NO];
//        }
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.colors = self.colorList;
//        gradientLayer.locations = @[@0.3, @0.5, @1.0];
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1.0, 0);
//        gradientLayer.frame = self.navBackgroundView.bounds;
//        [self.navBackgroundView.layer addSublayer:gradientLayer];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 如果标题颜色被更改,则在退出时恢复之前颜色
//    if (self.orignColor) {
//        [self setTitleAndBackViewColor:self.orignColor];
//    }
//    if (self.navBackgroundView) {
//        [self.navBackgroundView removeFromSuperview];
//        [self.navBackgroundView setHidden:YES];
//        self.navBackgroundView = nil;
//    }
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)back {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadLink {
    if (self.LinkUrl) {
        NSURLRequest *request = [NSURLRequest requestWithURL:self.LinkUrl];
        NSDictionary *parameters = [self.link getURLParameters];
        if (parameters[@"title_color"]) {
            //设置colors
            [self.colorList removeAllObjects];;
            NSString *colorListStr = parameters[@"title_color"];
            NSArray *colorsHexArray = [colorListStr componentsSeparatedByString:@","];
            for (NSString *hexStr in colorsHexArray) {
                 [self.colorList addObject: (__bridge id)UIColorOfHex([hexStr conversionToHex]).CGColor];
            }
            //添加渐变
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.colors = self.colorList;
            gradientLayer.locations = @[@0.3, @0.5, @1.0];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1.0, 0);
//            gradientLayer.frame = self.navBackgroundView.bounds;
//            [self.navBackgroundView.layer addSublayer:gradientLayer];
        }
        if (parameters[@"txt_color"]) {
            //保存原本颜色
            self.orignColor = [self.navigationController.navigationBar.titleTextAttributes valueForKey:NSForegroundColorAttributeName];
            //设置新颜色
            NSString *hexStr = parameters[@"txt_color"];

            self.currentColor = UIColorOfHex([hexStr conversionToHex]);
            [self setTitleAndBackViewColor:self.currentColor];
        }
        if (request) {
            [self.webView loadRequest:request];
        }
    }
}

- (void)setTitleAndBackViewColor:(UIColor *)color {
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:color};
    if ([self.navigationController isKindOfClass:[YXNavigationController class]]) {
        UIButton *btn = ((YXNavigationController *)self.navigationController).backBtn;
        btn.titleLabel.font = [UIFont iconFontWithSize:21.f];
        [btn setTitleColor:color forState:UIControlStateNormal];
        [btn setTitle:kIconFont_back forState:UIControlStateNormal];
        [btn setImage:[UIImage new] forState:UIControlStateNormal];
    }
}

//- (UIView *)navBackgroundView{
//    if (!_navBackgroundView) {
//        UIView *subView = [[UIView alloc] init];
//        subView.frame = CGRectMake(0, -kStatusBarHeight, SCREEN_WIDTH, kNavHeight);
//        //添加view遮盖着nav
//        UINavigationBar *bar = self.navigationController.navigationBar;
//        [bar addSubview:subView];
//        [bar insertSubview:subView atIndex:2];
//        _navBackgroundView = subView;
//    }
//    return _navBackgroundView;
//}

- (NSMutableArray *)colorList {
    if (!_colorList) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        _colorList = array;
    }
    return _colorList;
}

- (NSURL *)LinkUrl {
    if (!_LinkUrl) {
        if ([self.link hasPrefix:@"http"] || [self.link hasPrefix:@"https"]) {
            _LinkUrl = [NSURL URLWithString:self.link];
        } else if (!self.link) {
            _LinkUrl = [NSURL URLWithString:@""];
        } else {
            _LinkUrl = [NSURL fileURLWithPath:self.link];
        }
    }
    return _LinkUrl;
}

- (BOOL)isRemoteLink {
    return ([self.link hasPrefix:@"http"] || [self.link hasPrefix:@"https"]);
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = [[navigationAction.request URL] absoluteString];
    [[YXRouteManager shared] openInsideUrl:urlStr];
    if (decisionHandler) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self hideNoNetWorkView];
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (error.code == kBADREQUEST_TYPE && [self isRemoteLink]) {
        __weak typeof(self) weakSelf = self;
        [self showNoNetWorkView:^{
            [weakSelf loadLink];
        }];
    }
}
@end


/**
 Error Domain=NSURLErrorDomain Code=-1009 "The Internet connection appears to be offline." UserInfo={_kCFStreamErrorCodeKey=50, NSUnderlyingError=0x12dbc91c0 {Error Domain=kCFErrorDomainCFNetwork Code=-1009 "(null)" UserInfo={_kCFStreamErrorCodeKey=50, _kCFStreamErrorDomainKey=1}}, NSLocalizedDescription=The Internet connection appears to be offline., _WKRecoveryAttempterErrorKey=<WKReloadFrameErrorRecoveryAttempter: 0x12ec26a50>, NSErrorFailingURLStringKey=http://app.xstudyedu.com/share/dare/gameintro.html, NSErrorFailingURLKey=http://app.xstudyedu.com/share/dare/gameintro.html, _kCFStreamErrorDomainKey=1}
 */
