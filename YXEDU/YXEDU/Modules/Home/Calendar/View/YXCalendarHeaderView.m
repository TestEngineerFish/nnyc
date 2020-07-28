//
//  YXCalendarHeaderView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarHeaderView.h"

@implementation YXCalendarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        //设置UITableViewHeaderFooterView 的 header view 透明
        self.backgroundView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = UIColor.clearColor;
            view;
        });
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.openIndicator];
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.separatorView];

        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(AdaptSize(16));
            make.width.and.height.mas_equalTo(AdaptSize(18.f));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.icon.mas_right).offset(AdaptSize(6));
            make.width.mas_equalTo(100.f);
        }];

        [self.openIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(AdaptSize(-16)).priorityLow();
            make.width.and.height.mas_equalTo(AdaptSize(18.f));
        }];

        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(AdaptSize(-36));
            make.width.mas_equalTo(50.f);
        }];

        [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.icon).offset(AdaptSize(9));
            make.right.equalTo(self.openIndicator).offset(-9);
            make.height.mas_equalTo(0.6f);
        }];
    }
    return self;
}

- (void)setHeaderViewWithSection:(NSInteger)section data:(YXCalendarStudyDayData *)day {
    if (section == 0) {
        [self.icon setImage:[UIImage imageNamed:@"calendar_icon_review"]];
        [self.titleLabel setText:@"完成复习"];
        NSUInteger amountBook = day.review_item.count;
        NSUInteger amountCell = day.reviewCellList.count;
        [self.amountLabel setText:[NSString stringWithFormat:@"%lu", amountCell - amountBook]];
        NSString *imageName = day.showReviewList ? @"list_open" : @"list_close";
        [self.openIndicator setImage:[UIImage imageNamed:imageName]];
    } else if (section == 1) {
        [self.icon setImage:[UIImage imageNamed:@"calendar_icon_ab"]];
        [self.titleLabel setText:@"新学单词"];
        NSUInteger amountBook = day.study_item.count;
        NSUInteger amountCell = day.studiedCellList.count;
        [self.amountLabel setText:[NSString stringWithFormat:@"%lu", amountCell - amountBook]];
        NSString *imageName = day.showStudiedList ? @"list_open" : @"list_close";
        [self.openIndicator setImage:[UIImage imageNamed:imageName]];
    } else {
        [self.icon setImage:[UIImage imageNamed:@"calendar_icon_time"]];
        [self.titleLabel setText:@"当天学习时长"];
        [self.amountLabel setText: [NSString stringWithFormat:@"%02lu:%02lu", day.study_duration/60, day.study_duration%60]];
        [self.amountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(AdaptSize(-18));
        }];
        [self.separatorView setHidden:YES];
        [self layoutIfNeeded];
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.contentMode = UIViewContentModeScaleToFill;
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.preferredMaxLayoutWidth = AdaptSize(150);
        _titleLabel.textColor = UIColorOfHex(0x323232);
        _titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
    }
    return _titleLabel;
}
- (UIImageView *)openIndicator {
    if (!_openIndicator) {
        _openIndicator = [[UIImageView alloc] init];
        _openIndicator.contentMode = UIViewContentModeScaleToFill;
    }
    return _openIndicator;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.preferredMaxLayoutWidth = AdaptSize(100);
        _amountLabel.textColor = UIColorOfHex(0xFBA217);
        _amountLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
    }
    return _amountLabel;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColorOfHex(0xDCDCDC) colorWithAlphaComponent:0.5f];
        _separatorView = sepView;
    }
    return _separatorView;
}

@end
