//
//  YXCalendarBookCell.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/6.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarBookCell.h"

@interface YXCalendarBookCell()
@property (nonatomic, weak) UIView *signView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *valueLabel;
@end

@implementation YXCalendarBookCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self signView];
        [self titleLabel];
        [self valueLabel];
    }
    return self;
}

- (UIView *)signView {
    if (!_signView) {
        UIView *signView = [[UIView alloc] init];
        signView.backgroundColor    = UIColorOfHex(0x888888);
        signView.layer.cornerRadius = AdaptSize(2);
        [self addSubview:signView];
        [signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(AdaptSize(29));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(AdaptSize(4));
            make.height.mas_equalTo(AdaptSize(4));
        }];
        _signView = signView;
    }
    return _signView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont systemFontOfSize:AdaptSize(12)];
        titleLable.textColor = UIColorOfHex(0x888888);
        titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(AdaptSize(40));
            make.right.equalTo(self.valueLabel.mas_left).offset(AdaptSize(-5));
        }];
        _titleLabel = titleLable;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        UILabel *valueLable = [[UILabel alloc] init];
        valueLable.font          = [UIFont systemFontOfSize:AdaptSize(12)];
        valueLable.textColor     = UIColorOfHex(0x888888);
        valueLable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:valueLable];
        [valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).with.offset(AdaptSize(-18));
            make.width.mas_equalTo(AdaptSize(45));
        }];
        _valueLabel = valueLable;
    }
    return _valueLabel;
}

- (void)setCell:(YXCalendarCellModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];;
    self.valueLabel.text = model.descValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
