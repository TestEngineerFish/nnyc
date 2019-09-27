//
//  UIFont+IconFont.m
//  YXEDU
//
//  Created by yao on 2018/11/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "UIFont+IconFont.h"

@implementation UIFont (IconFont)
+ (UIFont *)iconFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"iconfont" size:size];
}

+ (UIFont *)pfSCMediumFontWithSize:(CGFloat)size {
    if (@available(iOS 9.0,*)) {
       return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else {
        return [UIFont boldSystemFontOfSize:size];
    }
}

+ (UIFont *)pfSCRegularFontWithSize:(CGFloat)size {
    if (@available(iOS 9.0,*)) {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)pfSCThinFontWithSize:(CGFloat)size {
    if (@available(iOS 9.0,*)) {
        return [UIFont fontWithName:@"PingFangSC-Thin" size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)pfSCLightFontWithSize:(CGFloat)size {
    if (@available(iOS 9.0,*)) {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)pfSCSemiboldFontWithSize:(CGFloat)size {
    if (@available(iOS 9.0,*)) {
        return [UIFont fontWithName:@"PingFangSC-Semibold" size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}
@end
