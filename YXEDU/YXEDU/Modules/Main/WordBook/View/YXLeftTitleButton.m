//
//  YXLeftTitleButton.m
//  YXEDU
//
//  Created by yao on 2019/2/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXLeftTitleButton.h"

@implementation YXLeftTitleButton
- (void)setTitleImageMargin:(CGFloat)titleImageMargin {
    _titleImageMargin = titleImageMargin;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize iconSize = self.currentImage.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat leftmargin = (self.size.width - iconSize.width - titleSize.width - self.titleImageMargin) * 0.5;
    
    self.titleLabel.frame = CGRectMake(leftmargin, 0, titleSize.width, self.size.height);
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.x = CGRectGetMaxX(self.titleLabel.frame) + self.titleImageMargin;
    self.imageView.frame = imageFrame;
}
@end
