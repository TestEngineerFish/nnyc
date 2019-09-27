//
//  YRHUDUtils.m
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import "YRHUDUtils.h"
#import "YRProgressView.h"
#import "YRLoadingView.h"

#define ProgressHide if (progressView){ [progressView hide:YES afterDelay:0.3]; progressView = nil;} if (loadingView){ [loadingView stopAnimating]; loadingView = nil;}


@interface YRHUDUtils ()
@end
@implementation YRHUDUtils

+ (void)showHUD:(UIView *)view title:(NSString *)text HUDType:(YRHUDType)type {
    YRHUDUtils *utils = [[[self class]alloc]init];
    [utils showHUDInView:view title:text HUDType:type];
}

- (void)showHUDInView:(UIView *)view title:(NSString *)text HUDType:(YRHUDType)type {
    switch (type) {
        case YRHUDSuccess: {
            YRProgressView *saveProgressView = [YRProgressView progressViewForView:view];
            [saveProgressView successWithString:text];
        }
            break;
        case YRHUDSuccessDetail: {
            YRProgressView *saveProgressView = [YRProgressView progressViewForView:view];
            [saveProgressView successWithDetailString:text];
        }
            break;
        case YRHUDFailed: {
            YRProgressView *saveProgressView = [YRProgressView progressViewForView:view];
            [saveProgressView failedWithString:text];
        }
            break;
        default:
            break;
    }
}

+ (void)showLoadHUD:(UIView *)view {
    [YRLoadingView loadingForView:view];
}


+ (void)hideLoadHUD:(UIView *)view {
    [YRLoadingView hideLoadingViewOnView:view];
}



@end
