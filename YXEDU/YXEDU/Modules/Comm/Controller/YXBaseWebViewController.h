//
//  YXBaseWebViewController.h
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"

@interface YXBaseWebViewController : BSRootVC
@property (nonatomic, copy) NSString *link;
@property (nonatomic, assign) BOOL hideNavi;
@property (nonatomic, assign) BOOL isLogin;
- (instancetype)initWithLink:(NSString *)link title:(NSString *)title;
+ (YXBaseWebViewController *)webViewControllerWithLink:(NSString *)link title:(NSString *)title;
@end

