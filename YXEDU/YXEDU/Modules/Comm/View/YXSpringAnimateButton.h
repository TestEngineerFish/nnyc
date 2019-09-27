//
//  YXSpringAnimateButton.h
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXSpringAnimateButton : UIView
@property(nonnull, nonatomic,readonly,strong) UIButton *button;
@property (nonatomic, assign) BOOL forbidHighLightState;
@property(nonatomic,getter=isEnabled) BOOL enabled; 
@property(nullable, nonatomic,readonly,strong) UILabel *titleLabel;
- (instancetype)initWithNoHighLightState;
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitle:(NSString *)title forState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
