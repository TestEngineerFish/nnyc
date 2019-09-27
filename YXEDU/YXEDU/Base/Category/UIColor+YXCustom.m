//
//  UIColor+YXCustom.m
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIColor+YXCustom.h"

@implementation UIColor (YXCustom)
+ (UIColor *)mainTitleColor { //#434a5d 67,74,93
    return [self mRGBColor:67 :74 :93];
}

+ (UIColor *)secondTitleColor {// #8095ad 128,149,173
    return [self mRGBColor:128 :149 :173];
}

+ (UIColor *)blueTextColor {
    return UIColorOfHex(0x55A7FD);
}

+ (UIColor *)separateColor {
    return [self mRGBColor:225 :235 :240];
}

+ (UIColor *)mRGBColor:(CGFloat)r :(CGFloat)g :(CGFloat)b {
    return [self mRGBAColor:r :g :b :1.0];
}

+ (UIColor *)mRGBAColor:(CGFloat)r :(CGFloat)g :(CGFloat)b :(CGFloat)a {
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}

+ (UIColor*)hexStringToColor:(NSString*)stringToConvert
{
    NSString* cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString* rString = [cString substringWithRange:range];
    range.location = 2;
    NSString* gString = [cString substringWithRange:range];
    range.location = 4;
    NSString* bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f)
                           green:((float)g / 255.0f)
                            blue:((float)b / 255.0f)
                           alpha:1.0f];
}
@end
