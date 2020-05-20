//
//  YXCustomButton.m
//  YXEDU
//
//  Created by yao on 2018/10/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCustomButton.h"
@interface YXCustomButton ()
@property (nonatomic, weak)CAGradientLayer *gradintLayer;
@property (nonatomic, copy)NSArray *disableColors;
@property (nonatomic, copy)NSArray *normalColors;
@end
@implementation YXCustomButton
+ (YXCustomButton *)commonBlueWithCornerRadius:(CGFloat)cornerRadius {
    return [self comBlueShadowBtnWithSize:CGSizeZero WithCornerRadius:cornerRadius];
}

+ (YXCustomButton *)comBlueShadowBtnWithSize:(CGSize)size {
    return [self comBlueShadowBtnWithSize:size WithCornerRadius:size.height * 0.5];
}

+ (YXCustomButton *)comBlueShadowBtnWithSize:(CGSize)size WithCornerRadius:(CGFloat)cornerRadius {
    YXCustomButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.cornerRadius = cornerRadius;
    button.exclusiveTouch = YES;
//    if (cornerRadius) {
//        button.layer.shadowRadius = 2.5;
//        button.layer.shadowOpacity = 0.53;
//        button.layer.shadowOffset = CGSizeMake(0, 2);
//        button.layer.shadowColor = UIColorOfHex(0xFB8417).CGColor;
//    }
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self gradintLayer];
        self.backgroundColor = UIColorOfHex(0xb7c2d4);
        [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setDisableColor:(UIColor *)disableColor {
    _disableColor = disableColor;
    self.backgroundColor = disableColor;//UIColorOfHex(0xb7c2d4);
}
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.gradintLayer.cornerRadius = cornerRadius;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradintLayer.frame = self.bounds;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    self.gradintLayer.hidden = !enabled;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.gradintLayer.hidden = !userInteractionEnabled;
}
- (CAGradientLayer *)gradintLayer {
    if (!_gradintLayer) {
        CAGradientLayer *gradintLayer = [CAGradientLayer layer];
        gradintLayer.colors = self.normalColors;
        // 起始点
        gradintLayer.startPoint = CGPointMake(0, 0);
        // 结束点
        gradintLayer.endPoint   = CGPointMake(1, 0);
        [self.layer addSublayer:gradintLayer];
        _gradintLayer = gradintLayer;
    }
    return _gradintLayer;
}

- (NSArray *)normalColors {
    if (!_normalColors) {
        UIColor *startColor = UIColorOfHex(0xFDBA33);
        UIColor *endColor = UIColorOfHex(0xFB8417);
        _normalColors = @[(__bridge id)startColor.CGColor,
                                (__bridge id)endColor.CGColor];
    }
    return _normalColors;
}

- (NSArray *)disableColors {
    if (!_disableColors) {
        UIColor *startColor =  UIColorOfHex(0x60B6F8);
        UIColor *endColor = UIColorOfHex(0x6098F7);
        _disableColors = @[(__bridge id)startColor.CGColor,
                          (__bridge id)endColor.CGColor];
    }
    return _disableColors;
}
@end
