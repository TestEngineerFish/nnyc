//
//  YXCommonMaskView.m
//  YXEDU
//
//  Created by yao on 2018/11/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCommonMaskView.h"

@implementation YXCommonMaskView
{
    UIView *_maskView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIView *maskView = [[UIView alloc] init];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self addSubview:maskView];
        _maskView = maskView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
}
@end
