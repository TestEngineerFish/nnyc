//
//  UITabBarItem+BadgeValue.m
//  pyyx
//
//  Created by xulinfeng on 2016/11/5.
//  Copyright © 2016年 朋友印象. All rights reserved.
//

#import "UITabBarItem+BadgeValue.h"
#import <objc/runtime.h>

static void swizzleInstanceMethods(Class klass, SEL original, SEL new)
{
    Method origMethod = class_getInstanceMethod(klass, original);
    Method newMethod = class_getInstanceMethod(klass, new);
    
    if (class_addMethod(klass, original, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(klass, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

static BOOL private_UITabBarButton_swizzled = NO;

@interface UIView (_UITabBarButton)

@property (nonatomic, strong) UIView *emptyBadgeView;
@property (nonatomic, strong) NSString *cachedBadgeValue;

@end

@implementation UIView (_UITabBarButton)

+ (void)load{
    
    Class private_UITabBarButton = NSClassFromString(@"UITabBarButton");
    if (![self UITabBarButton_swizzled]) {
        swizzleInstanceMethods(private_UITabBarButton, @selector(layoutSubviews), @selector(swizzle_UITabBarButton_layoutSubviews));
        swizzleInstanceMethods(private_UITabBarButton, NSSelectorFromString(@"_setBadgeValue:"), @selector(swizzle_UITabBarButton_setBadgeValue:));
        self.UITabBarButton_swizzled = YES;
    }
}

+ (BOOL)UITabBarButton_swizzled{
    return private_UITabBarButton_swizzled;
}

+ (void)setUITabBarButton_swizzled:(BOOL)UITabBarButton_swizzled{
    private_UITabBarButton_swizzled = UITabBarButton_swizzled;
}

- (void)swizzle_UITabBarButton_layoutSubviews{
    [self swizzle_UITabBarButton_layoutSubviews];
    
    Ivar ivar = class_getInstanceVariable([self class], [@"_badge" UTF8String]);
    UIView *badgeView = object_getIvar(self, ivar);
    
    badgeView.subviews.firstObject.hidden = [self cachedBadgeValue] && ![[self cachedBadgeValue] length];
    
    if (badgeView && [self cachedBadgeValue] && ![[self cachedBadgeValue] length]) {
        [badgeView addSubview:[self emptyBadgeView]];
    } else {
        [[self emptyBadgeView] removeFromSuperview];
    }
}

- (void)swizzle_UITabBarButton_setBadgeValue:(NSString *)value{
    [self swizzle_UITabBarButton_setBadgeValue:value];
    
    self.cachedBadgeValue = value;
    
    [self setNeedsLayout];
}

- (UIView *)emptyBadgeView{
    UIView *_emptyBadgeView = objc_getAssociatedObject(self, @selector(emptyBadgeView));
    if (!_emptyBadgeView) {
        _emptyBadgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 8, 8)];
        _emptyBadgeView.backgroundColor = [UIColor redColor];
        _emptyBadgeView.layer.cornerRadius = 4;
    }
    return _emptyBadgeView;
}

- (void)setEmptyBadgeView:(UIView *)emptyBadgeView{
    objc_setAssociatedObject(self, @selector(emptyBadgeView), emptyBadgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)cachedBadgeValue{
    return objc_getAssociatedObject(self, @selector(cachedBadgeValue));
}

- (void)setCachedBadgeValue:(NSString *)cachedBadgeValue{
    objc_setAssociatedObject(self, @selector(cachedBadgeValue), cachedBadgeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UITabBarItem (BadgeValue)

@end
