//
//  YXReoprtEleView.m
//  YXEDU
//
//  Created by yao on 2018/12/7.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReoprtEleView.h"
@interface YXReoprtEleView()
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation YXReoprtEleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"reportShapeBG"];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = @"综合评分";
        titleL.font = [UIFont systemFontOfSize:AdaptSize(15)];
        titleL.textColor = UIColorOfHex(0x485562);
        [self addSubview:titleL];
        _titleL = titleL;
    }
    return self;
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.imageView.image = bgImage;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-1.5, -3.5, -6.5, -4.5));
    self.imageView.frame = rect;
    CGFloat margin = AdaptSize(10);
    self.titleL.frame = CGRectMake(margin, AdaptSize(12),size.width , 14);
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    [super setUserInteractionEnabled:userInteractionEnabled];
    self.imageView.userInteractionEnabled = YES;
}

@end
