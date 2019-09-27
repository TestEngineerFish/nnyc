
//
//  YXChallengeUserBaseView.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXChallengeUserBaseView.h"

@implementation YXChallengeUserBaseView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self numberLabel];
        [self userIcon];
        [self userNameLabel];
        [self answeredlabel];
        [self spendTimeLabel];
    }
    return self;
}
- (UILabel *)numberLabel {
    if (!_numberLabel) {
        UILabel *numberLabel = [[UILabel alloc] init];
        numberLabel.text = @"9999";
        numberLabel.font = [UIFont pfSCRegularFontWithSize:16];
        numberLabel.textColor = [UIColor mainTitleColor];
        [self addSubview:numberLabel];
        _numberLabel = numberLabel;
    }
    return _numberLabel;
}

- (UIImageView *)userIcon {
    if (!_userIcon) {
        UIImageView *userIcon = [[UIImageView alloc] init];
        userIcon.image = [UIImage imageNamed:@"userPlaceHolder"];
        [self addSubview:userIcon];
        _userIcon = userIcon;
    }
    return _userIcon;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        UILabel *userNameLabel = [[UILabel alloc] init];
//        userNameLabel.text = @"用户123****3904";
        userNameLabel.font = [UIFont pfSCRegularFontWithSize:12];
        userNameLabel.textColor = [UIColor mainTitleColor];
        [self addSubview:userNameLabel];
        _userNameLabel = userNameLabel;
    }
    return _userNameLabel;
}

- (UILabel *)answeredlabel {
    if (!_answeredlabel) {
        UILabel *answeredlabel = [[UILabel alloc] init];
//        answeredlabel.text = @"答题130个";
        answeredlabel.font = [UIFont pfSCRegularFontWithSize:12];
        answeredlabel.textColor = [UIColor secondTitleColor];
        [self addSubview:answeredlabel];
        _answeredlabel = answeredlabel;
    }
    return _answeredlabel;
}

- (UILabel *)spendTimeLabel {
    if (!_spendTimeLabel) {
        UILabel *spendTimeLabel = [[UILabel alloc] init];
//        spendTimeLabel.text = @"耗时30:00";
        spendTimeLabel.font = [UIFont pfSCRegularFontWithSize:12];
        spendTimeLabel.textColor = [UIColor secondTitleColor];
        [self addSubview:spendTimeLabel];
        _spendTimeLabel = spendTimeLabel;
    }
    return _spendTimeLabel;
}

@end
