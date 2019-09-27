//
//  YXBaseMaskView.m
//  YXEDU
//
//  Created by yao on 2018/11/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBaseMaskView.h"

@implementation YXBaseMaskView
{
    UIView *_maskView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self.maskView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self maskViewWasTapped];
}

- (void)maskViewWasTapped {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
}

- (UIView *)maskView {
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.4;
        [self addSubview:maskView];
        _maskView = maskView;
    }
    return _maskView;
}
@end
