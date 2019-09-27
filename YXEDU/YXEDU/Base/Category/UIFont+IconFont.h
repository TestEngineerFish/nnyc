//
//  UIFont+IconFont.h
//  YXEDU
//
//  Created by yao on 2018/11/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (IconFont)
+ (UIFont *)iconFontWithSize:(CGFloat)size;
/** PingFangSC-Medium */
+ (UIFont *)pfSCMediumFontWithSize:(CGFloat)size;
/** PingFangSC-Regular */
+ (UIFont *)pfSCRegularFontWithSize:(CGFloat)size;
/** PingFangSC-Thin */
+ (UIFont *)pfSCThinFontWithSize:(CGFloat)size;
/** PingFangSC-Light */
+ (UIFont *)pfSCLightFontWithSize:(CGFloat)size;
/** PingFangSC-Semibold */
+ (UIFont *)pfSCSemiboldFontWithSize:(CGFloat)size;

@end
