//
//  YXNoNetworkView.m
//  YXEDU
//
//  Created by Jake To on 10/10/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXNoNetworkView.h"

@interface YXNoNetworkView ()
@property(nonatomic, copy)void(^touchBlock)(void);
@end

@implementation YXNoNetworkView

+ (YXNoNetworkView *)createWith:(void (^)(void))touchBlock {
    YXNoNetworkView *view = [[self alloc] init];
    view.touchBlock = [touchBlock copy];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews {
    self.backgroundColor = UIColor.whiteColor;
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToReload:)];
    [self addGestureRecognizer:tap];
    
    UIImageView *noNetworkImageView = [[UIImageView alloc] init];
    noNetworkImageView.image = [UIImage imageNamed:@"noNetwork"];
    noNetworkImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *aboveNoNetworkLabel = [[UILabel alloc] init];
    UILabel *belowNoNetworkLabel = [[UILabel alloc] init];
    
    [self addSubview:noNetworkImageView];
    [self addSubview:aboveNoNetworkLabel];
    [self addSubview:belowNoNetworkLabel];
    
    [noNetworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(64);
        make.right.equalTo(self).offset(-64);
        make.centerY.equalTo(self).offset(-88);
        make.centerX.equalTo(self);
    }];
    
    aboveNoNetworkLabel.text = @"网络有些问题";
    aboveNoNetworkLabel.textColor = UIColorOfHex(0x849EC5);
    aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
    [aboveNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(noNetworkImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];
    
    belowNoNetworkLabel.text = @"点击屏幕重试";
    belowNoNetworkLabel.textColor = UIColorOfHex(0x849EC5);
    aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
    [belowNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aboveNoNetworkLabel.mas_bottom).offset(8);
        make.centerX.equalTo(self);
    }];
}


- (void)tapToReload:(UITapGestureRecognizer *)tap {
    if (self.touchBlock) {
        self.touchBlock();
    }
}
@end
