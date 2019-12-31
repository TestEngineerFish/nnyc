//
//  YXCalendarWordCell.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarWordCell.h"

@interface YXCalendarWordCell()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *valueLabel;

@end

@implementation YXCalendarWordCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self valueLabel];
        [self titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:AdaptSize(12)];
        titleLabel.textColor = UIColorOfHex(0x9BB0C6);
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(AdaptSize(40));
            make.width.mas_equalTo((SCREEN_WIDTH - 30.f)/3);
        }];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        UILabel *valueLabel = [[UILabel alloc] init];
        valueLabel.font = [UIFont systemFontOfSize:AdaptSize(12)];
        valueLabel.textColor = UIColorOfHex(0x9BB0C6);
        valueLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:valueLabel];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(AdaptSize(-16));
            make.left.equalTo(self.titleLabel.mas_right);
        }];
        _valueLabel = valueLabel;
    }
    return _valueLabel;
}

- (void)setCell:(YXCalendarCellModel *)model {
    self.titleLabel.text = model.title;
    self.valueLabel.text = model.descValue;
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
