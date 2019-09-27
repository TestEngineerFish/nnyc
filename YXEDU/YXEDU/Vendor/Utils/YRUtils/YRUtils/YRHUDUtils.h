//
//  YRHUDUtils.h
//  YRUtils
//
//  Created by shiji on 2018/3/28.
//  Copyright © 2018年 PYYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRProgressView.h"

typedef NS_ENUM(NSInteger, YRHUDType) {
    YRHUDSuccess,
    YRHUDSuccessDetail,
    YRHUDFailed,
};

@interface YRHUDUtils : NSObject

+ (void)showHUD:(UIView *)view
          title:(NSString *)text
        HUDType:(YRHUDType)type;

//
+ (void)showLoadHUD:(UIView *)view;

+ (void)hideLoadHUD:(UIView *)view;

@end
