//
//  YXWordDetailSectionHeader.m
//  YXEDU
//
//  Created by yao on 2018/10/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailSectionHeader.h"
@interface YXWordDetailSectionHeader()

@end

@implementation YXWordDetailSectionHeader
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25);
            make.top.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(200, 30));
        }];
        
        [self.verticalL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(17);
            make.top.equalTo(self).offset(27.5);
            make.size.mas_equalTo(CGSizeMake(2,15));
        }];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.titleL.text = title;
}
- (UILabel *)titleL {
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = UIColorOfHex(0x485461);
        titleL.font = [UIFont pfSCMediumFontWithSize:15];
        titleL.text = @"例句";
        titleL.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}

- (UILabel *)verticalL {
    if (!_verticalL) {
        UILabel *verticalL = [[UILabel alloc] init];
        verticalL.backgroundColor = UIColorOfHex(0x3A9BFC);
        [self addSubview:verticalL];
        _verticalL = verticalL;
    }
    return _verticalL;
}


@end
