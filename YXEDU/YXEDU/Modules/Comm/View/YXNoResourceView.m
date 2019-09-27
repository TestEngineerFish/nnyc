//
//  YXEmptyView.m
//  YXEDU
//
//  Created by Jake To on 10/11/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXNoResourceView.h"

@implementation YXNoResourceView

+ (YXNoResourceView *)create {
    YXNoResourceView *view = [[self alloc] init];
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
    
    UIImageView *noResourceImageView = [[UIImageView alloc] init];
    noResourceImageView.image = [UIImage imageNamed:@"blankPage"];
    noResourceImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *noResourceLabel = [[UILabel alloc] init];
    
    [self addSubview:noResourceImageView];
    [self addSubview:noResourceLabel];
    
    [noResourceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(64);
        make.right.equalTo(self).offset(-64);
        make.centerY.equalTo(self).offset(-88);
        make.centerX.equalTo(self);
    }];
    
    noResourceLabel.text = @"暂未下载离线包";
    noResourceLabel.textColor = UIColorOfHex(0x849EC5);
    noResourceLabel.textAlignment = NSTextAlignmentCenter;
    [noResourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noResourceImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
}

@end
