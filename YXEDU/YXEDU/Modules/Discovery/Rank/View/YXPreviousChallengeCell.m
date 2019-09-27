//
//  YXPreviousChallengeCell.m
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPreviousChallengeCell.h"
@interface YXPreviousChallengeCell ()
@property (nonatomic, weak)UIImageView *crownIcon;
@property (nonatomic, weak)UIImageView *cornIcon;
@property (nonatomic, weak)UILabel *cornLabel;
@end

@implementation YXPreviousChallengeCell
- (void)setupSubViews {
    self.crownIcon.image = [UIImage imageNamed:@"goldIcon"];
    
    UIImageView *cornIcon = [[UIImageView alloc] init];
    cornIcon.contentMode = UIViewContentModeTop;
    cornIcon.image = [UIImage imageNamed:@"cornBox"];
    [self.contentView addSubview:cornIcon];
    _cornIcon = cornIcon;
    
    UILabel *cornLabel = [[UILabel alloc] init];
    cornLabel.textAlignment = NSTextAlignmentCenter;
    cornLabel.font = [UIFont pfSCRegularFontWithSize:12];
    cornLabel.textColor = UIColorOfHex(0xFD9725);
    [self.contentView addSubview:cornLabel];
    _cornLabel = cornLabel;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.userView layoutIfNeeded];
    CGPoint userIconOrigin = [self convertRect:self.userView.userIcon.frame fromView:self.userView].origin;
    self.crownIcon.frame = CGRectMake(userIconOrigin.x + 10, userIconOrigin.y - 10, 22, 13);
    
    CGFloat labelW = 60;
    self.cornLabel.frame = CGRectMake(self.line.right - labelW, self.height - 18 - 13, labelW, 13);
    self.cornIcon.frame = CGRectMake(self.cornLabel.left + 22, 11, 18, 20);
}

- (UIImageView *)crownIcon {
    if (!_crownIcon) {
        UIImageView *crownIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:crownIcon];
        _crownIcon = crownIcon;
    }
    return _crownIcon;
}

- (void)setUserRankModel:(YXUserRankModel *)userRankModel {
    [super setUserRankModel:userRankModel];
    self.cornLabel.text = [NSString stringWithFormat:@"%@ 积分",userRankModel.credits];
    NSString *cornIconName = nil;
    if (userRankModel.ranking <= 3) {
        cornIconName = @"cornBox";
        self.crownIcon.hidden = NO;
        if (userRankModel.ranking == YXRankGold) {
            self.crownIcon.image = [UIImage imageNamed:@"goldIcon"];
        }else if(userRankModel.ranking == YXRankSilver){
            self.crownIcon.image = [UIImage imageNamed:@"silverIcon"];
        }else {
            self.crownIcon.image = [UIImage imageNamed:@"copperIcon"];
        }
    }else if(userRankModel.ranking <= 10) {
        cornIconName = @"cornBag";
        self.crownIcon.hidden = YES;
    }else {
        cornIconName = @"cornBean";
        self.crownIcon.hidden = YES;
    }
    self.cornIcon.image = [UIImage imageNamed:cornIconName];
}

@end
