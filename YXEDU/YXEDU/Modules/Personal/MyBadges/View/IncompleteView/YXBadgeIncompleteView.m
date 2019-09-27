//
//  YXBadgeIncompleteView.m
//  YXEDU
//
//  Created by Jake To on 10/26/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXBadgeIncompleteView.h"

@implementation YXBadgeIncompleteView

+ (YXBadgeIncompleteView *)showIncompletedViewWithBadge:(YXPersonalBadgeModel *)badge {
    
    YXBadgeIncompleteView *view = [[self alloc] initWithBadge:badge];
    return view;
    
}

- (instancetype)initWithBadge:(YXPersonalBadgeModel *)badge {
    if (self = [super init]) {
        UIView *containerView = [[UIView alloc] init];
        containerView.backgroundColor = UIColor.whiteColor;
        containerView.layer.cornerRadius = 8;
        
        UIView *avatarBackgroundView = [[UIView alloc] init];
        avatarBackgroundView.backgroundColor = UIColor.whiteColor;
        avatarBackgroundView.layer.cornerRadius = 64;
        
        UIImageView *avatarImageView = [[UIImageView alloc] init];
        [avatarImageView sd_setImageWithURL:[NSURL URLWithString:badge.incompleteBadgeImageUrl]];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = badge.badgeName;
        nameLabel.font = [UIFont boldSystemFontOfSize:18];
        nameLabel.textColor = UIColorOfHex(0x485461);
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.text = @"未获得";
        dateLabel.textColor = UIColorOfHex(0x849EC5);
        
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.font = [UIFont systemFontOfSize:13];
        descLabel.numberOfLines = 0;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.text = badge.desc;
        descLabel.textColor = UIColorOfHex(0x485461);
        
        UIImageView *lockImageView = [[UIImageView alloc] init];
        lockImageView.contentMode = UIViewContentModeScaleAspectFit;
        lockImageView.image = [UIImage imageNamed:@"锁"];
        
        UIView *leftLineView = [[UIView alloc] init];
        leftLineView.backgroundColor = UIColorOfHex(0xE5E5E5);
        
        UIView *rightLineView = [[UIView alloc] init];
        rightLineView.backgroundColor = UIColorOfHex(0xE5E5E5);
        
        UIProgressView *progressView = [[UIProgressView alloc] init];
        progressView.progress = [badge.done floatValue] / [badge.total floatValue];
        progressView.progressImage = [UIImage imageNamed:@"gradient_layer_view"];
        progressView.trackTintColor = UIColorOfHex(0xEEF1F3);
        progressView.layer.cornerRadius = 5;
        progressView.layer.masksToBounds = YES;
//        progressView.layer.borderWidth = 1;
//        progressView.layer.borderColor = UIColorOfHex(0xE5E5E5).CGColor;

//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.frame = progressView.bounds;
//        gradientLayer.colors = @[(id)[UIColorOfHex(0xFF7AA3) CGColor], (id)[UIColorOfHex(0xFFB5E6) CGColor]];
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 0);
//        gradientLayer.locations = @[@0,@1];
        
//        CALayer *maskLayer = [CALayer layer];
//        maskLayer.frame = CGRectMake(0, 0, gradientLayer.bounds.size.width, gradientLayer.bounds.size.height);
//        maskLayer.backgroundColor = UIColor.whiteColor.CGColor;
//        gradientLayer.mask = maskLayer;
        
//        [progressView.layer insertSublayer:gradientLayer atIndex:0];
//        progressView.layer.mask = maskLayer;
        
        UILabel *progressLabel = [[UILabel alloc] init];
        progressLabel.font = [UIFont systemFontOfSize:13];
        NSString *countString = [NSString stringWithFormat:@"当前进度：%@/%@", badge.done, badge.total];
        NSRange startRange = [countString rangeOfString:@"："];
        NSRange endRange = [countString rangeOfString:@"/"];
        NSRange pinkRange =NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSMutableAttributedString *pinkString = [[NSMutableAttributedString alloc] initWithString:countString];
        [pinkString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFF7CA5) range:pinkRange];
        progressLabel.attributedText = pinkString;
        
        [self addSubview:containerView];
        [containerView addSubview:avatarBackgroundView];
        [avatarBackgroundView addSubview:avatarImageView];
        [containerView addSubview:nameLabel];
        [containerView addSubview:dateLabel];
        [containerView addSubview:descLabel];
        [containerView addSubview:lockImageView];
        [containerView addSubview:leftLineView];
        [containerView addSubview:rightLineView];
        [containerView addSubview:progressView];
        [containerView addSubview:progressLabel];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [avatarBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(128);
            make.centerX.equalTo(containerView);
            make.centerY.equalTo(containerView.mas_top).offset(24);
        }];
        
        [avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(96);
            make.center.equalTo(avatarBackgroundView);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(avatarBackgroundView.mas_bottom).offset(0);
            make.centerX.equalTo(containerView);
        }];
        
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(4);
            make.centerX.equalTo(containerView);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateLabel.mas_bottom).offset(20);
            make.left.equalTo(containerView).offset(20);
            make.right.equalTo(containerView).offset(-20);
            make.centerX.equalTo(containerView);
        }];
        
        [lockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(descLabel.mas_bottom).offset(24);
            make.centerX.equalTo(containerView);
        }];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lockImageView);
            make.right.equalTo(lockImageView.mas_left).offset(-10);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(90);
        }];
        
        [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lockImageView);
            make.left.equalTo(lockImageView.mas_right).offset(10);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(90);
        }];
        
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.equalTo(lockImageView.mas_bottom).offset(24);
            make.width.mas_equalTo(196);
            make.height.mas_equalTo(10);
        }];
        
        [progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(containerView);
            make.top.equalTo(progressView.mas_bottom).offset(24);
        }];

    }
    return self;
}

@end
