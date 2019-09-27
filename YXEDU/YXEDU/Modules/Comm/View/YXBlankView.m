//
//  YXBlankView.m
//  YXEDU
//
//  Created by Jake To on 10/21/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXBlankView.h"

@implementation YXBlankView

+ (YXBlankView *)create {
    YXBlankView *view = [[self alloc] init];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = UIColor.whiteColor;
    
    UIImageView *blankImageView = [[UIImageView alloc] init];
    blankImageView.image = [UIImage imageNamed:@"blankPage"];
    blankImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *blankLabel = [[UILabel alloc] init];
    
    [self addSubview:blankImageView];
    [self addSubview:blankLabel];
    
    [blankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(64);
        make.right.equalTo(self).offset(-64);
        make.centerY.equalTo(self).offset(-88);
        make.centerX.equalTo(self);
    }];
    
    blankLabel.text = @"通用样式空白页";
    blankLabel.textColor = UIColorOfHex(0x849EC5);
    blankLabel.textAlignment = NSTextAlignmentCenter;
    [blankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(blankImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
}


@end
