//
//  YXPersonalBadgeCell.m
//  YXEDU
//
//  Created by Jake To on 10/19/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXPersonalBadgeCell.h"

@implementation YXPersonalBadgeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.badgeImageView = [[UIImageView alloc] init];
        self.badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.badgeNameLabel = [[UILabel alloc] init];
        self.badgeNameLabel.textColor = UIColorOfHex(0x434A5D);
        self.badgeNameLabel.textAlignment = NSTextAlignmentCenter;
        [self.badgeNameLabel setFont:[UIFont systemFontOfSize:14]];

        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = UIColorOfHex(0x8095AB);
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.dateLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self.contentView addSubview:self.badgeImageView];
        [self.contentView addSubview:self.badgeNameLabel];
        [self.contentView addSubview:self.dateLabel];
        
        [self.badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(72);
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.badgeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.badgeImageView.mas_bottom).offset(6);
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.badgeNameLabel.mas_bottom);
            make.centerX.equalTo(self.contentView);
        }];
    }
    
    return self;
    
}

@end
