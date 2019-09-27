//
//  YXKeyPointHeaderView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/4.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXKeyPointHeaderView.h"

@interface YXKeyPointHeaderView ()
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, weak) UIView *placeholder;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation YXKeyPointHeaderView

- (void)initUI {
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(6.f);
    }];
    [self.placeholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(17.f);
        make.bottom.equalTo(self).with.offset(-5.f);
        make.size.mas_equalTo(CGSizeMake(2.f, 15.f));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.placeholder);
        make.left.equalTo(self.placeholder.mas_right).with.offset(5.f);
        make.right.equalTo(self).with.offset(-20.f);
    }];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark - subviews
- (UIView *)separator {
    if (!_separator) {
        UIView *separator = [[UIView alloc] init];
        separator.backgroundColor = UIColorOfHex(0xE9EFF4);
        [self addSubview:separator];
        _separator = separator;
    }
    return _separator;
}

- (UIView *)placeholder {
    if (!_placeholder) {
        UIView *placeholder = [[UIView alloc] init];
        placeholder.backgroundColor = UIColorOfHex(0x3A9BFC);
        [self addSubview:placeholder];
        _placeholder = placeholder;
    }
    return _placeholder;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"课文重点单词和词组" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:15.f], NSForegroundColorAttributeName : UIColorOfHex(0x485461)}];
        titleLabel.attributedText = attrStr;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

@end
