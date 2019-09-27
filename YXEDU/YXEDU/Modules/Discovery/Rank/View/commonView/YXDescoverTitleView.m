//
//  YXDescoverTitleView.m
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverTitleView.h"

@implementation YXDescoverTitleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.indicater.frame = CGRectMake(0, 0, 2, 17);
        [self titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.titleLabel.frame = CGRectMake(10, 0, size.width - 10, size.height);
}

- (CALayer *)indicater {
    if (!_indicater) {
        CALayer *indicater = [[CALayer alloc] init];
        indicater.backgroundColor = UIColorOfHex(0x60B6F8).CGColor;
        [self.layer addSublayer:indicater];
        _indicater = indicater;
    }
    return _indicater;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont pfSCMediumFontWithSize:15];
        titleLabel.textColor = [UIColor mainTitleColor];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end
