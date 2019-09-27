//
//  UIColor+YXCustom.h
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YXCustom)
+ (UIColor *)mainTitleColor;
+ (UIColor *)secondTitleColor;
+ (UIColor *)blueTextColor;
+ (UIColor *)separateColor;
+ (UIColor *)mRGBColor:(CGFloat)r :(CGFloat)g :(CGFloat)b;
+ (UIColor *)mRGBAColor:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a;
+ (UIColor *)hexStringToColor:(NSString*)colorString;
@end

NS_ASSUME_NONNULL_END
