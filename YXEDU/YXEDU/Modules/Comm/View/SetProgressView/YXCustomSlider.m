//
//  YXCustomSlider.m
//  YXEDU
//
//  Created by yao on 2018/10/15.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXCustomSlider.h"

static CGFloat const kYXCustomSliderHeight = 25;
@implementation YXCustomSlider
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setThumbImage:[UIImage imageNamed:@"progress_dot_view"] forState:UIControlStateNormal];
        [self setMinimumTrackImage:[UIImage imageNamed:@"gradiant_slider_pink"] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[UIImage imageNamed:@"gradient_gray_view"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    bounds = [super trackRectForBounds:bounds];
    bounds.size.height = 10;
    return bounds;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect bounds = self.bounds;
    CGFloat heightDelta = (kYXCustomSliderHeight - bounds.size.height);
    bounds = CGRectInset(bounds, 0, -heightDelta * 0.5);
    return CGRectContainsPoint(bounds, point);
}


@end
