//
//  YXBookCollectionHeader.m
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBookCollectionHeader.h"

@implementation YXBookCollectionHeader
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)sectionLabel {
    if (!_sectionLabel) {
        UILabel *sectionLabel = [[UILabel alloc] init];
        sectionLabel.text = @"七年级";
        sectionLabel.textColor = [UIColor mainTitleColor];
        sectionLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:sectionLabel];
        _sectionLabel = sectionLabel;
    }
    return _sectionLabel;
}
@end
