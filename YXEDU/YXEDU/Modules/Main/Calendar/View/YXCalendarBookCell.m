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
        signView.backgroundColor = UIColorOfHex(0x9BB0C6);
        [self addSubview:signView];
        [signView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(1.5f);
            make.height.mas_equalTo(AdaptSize(14.f));
        }];
        _signView = signView;
    }
    return _signView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.font = [UIFont systemFontOfSize:AdaptSize(14)];
        titleLable.textColor = UIColorOfHex(0x9BB0C6);
        titleLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.signView.mas_right);
            make.width.mas_equalTo((SCREEN_WIDTH - 30.f)/3*2);
        }];
        _titleLabel = titleLable;
    }
    return _titleLabel;
}

- (UILabel *)valueLabel {
    if (!_valueLabel) {
        UILabel *valueLable = [[UILabel alloc] init];
        valueLable.font = [UIFont systemFontOfSize:AdaptSize(14)];
        valueLable.textColor = UIColorOfHex(0x9BB0C6);
        valueLable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:valueLable];
        [valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self);
            make.width.mas_equalTo((SCREEN_WIDTH - 30.f)/3);
        }];
        _valueLabel = valueLable;
    }
    return _valueLabel;
}

- (void)setCell:(YXCalendarBookModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@" %@", model.title];;
    self.valueLabel.text = model.descValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
