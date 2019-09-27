//
//  YXTextBorderLabel.m
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXTextBorderLabel.h"
@interface YXTextBorderLabel ()

@end

@implementation YXTextBorderLabel
- (void)drawTextInRect:(CGRect)rect {
    NSAttributedString *attributedText = nil;
    if (self.attributedText) {
        attributedText = [self.attributedText mutableCopy];
    }
    
    // 描边
    CGContextRef contex = UIGraphicsGetCurrentContext ();
    CGContextSetLineWidth (contex, AdaptSize(10));
    CGContextSetLineJoin (contex, kCGLineJoinRound);
    CGContextSetTextDrawingMode (contex, kCGTextStroke);
    
    //描边颜色
    self.textColor = self.borderColor;
    [super drawTextInRect:rect];
    
    if (attributedText) {
        self.attributedText = attributedText;
    }
    
    CGContextSetTextDrawingMode (contex, kCGTextFill);
    [super drawTextInRect:rect];
}

- (UIColor *)borderColor {
    if (!_borderColor) {
        _borderColor = [UIColor whiteColor];
    }
    return _borderColor;
}
@end
