//
//  YXWordDetailTextCell.m
//  YXEDU
//
//  Created by yao on 2018/10/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordDetailTextCell.h"
@interface YXWordDetailTextCell()

@end
@implementation YXWordDetailTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.textLabel.font = [UIFont systemFontOfSize:15];
//        self.textLabel.textColor = UIColorOfHex(0x485461);
//        self.textLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleL {
    if (!_titleL) {
        UILabel *titleL = [[UILabel alloc] init];
        titleL.textColor = UIColorOfHex(0x485461);
        titleL.numberOfLines = 0;
        titleL.font = [UIFont systemFontOfSize:15];
//        titleL.text = @"我为他们取得的成就向他们所有人表示祝贺。";
        [self.contentView addSubview:titleL];
        _titleL = titleL;
    }
    return _titleL;
}

@end
