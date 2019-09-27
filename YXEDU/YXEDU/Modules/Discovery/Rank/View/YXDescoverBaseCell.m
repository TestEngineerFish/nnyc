//
//  YXDescoverBaseCell.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverBaseCell.h"
@implementation YXDescoverBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}
#pragma mark - event
- (BOOL)rightLabelCanReceiveClick {
    return YES;
}

- (void)checkPreviousRangeList {
    if ([self.delegate respondsToSelector:@selector(descoverBaseCellShouldCheckPreviousRangeList:)]) {
        [self.delegate descoverBaseCellShouldCheckPreviousRangeList:self];
    }
}

#pragma mark - subviews
- (void)setupSubviews {
    [self bgImageView];
    [self titleView];
    [self rightLabel];
    
    if ([self rightLabelCanReceiveClick]) {
        self.rightLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkPreviousRangeList)];
        [self.rightLabel addGestureRecognizer:tap];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    CGFloat margin = AdaptSize(15);
    self.titleView.frame = CGRectMake(margin, margin, 100, 17);
    CGFloat labelWidth = 220;
    self.rightLabel.frame = CGRectMake(size.width - margin - labelWidth, AdaptSize(17), labelWidth, 13);
}

- (YXDescoverTitleView *)titleView {
    if (!_titleView) {
        YXDescoverTitleView *titleView = [[YXDescoverTitleView alloc] init];
        [self.contentView addSubview:titleView];
        _titleView = titleView;
    }
    return _titleView;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        UIImageView *bgImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:bgImageView];
        _bgImageView = bgImageView;
    }
    return _bgImageView;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        UILabel *rightLabel = [[UILabel alloc] init];
        rightLabel.textAlignment = NSTextAlignmentRight;
        rightLabel.font = [UIFont pfSCRegularFontWithSize:12];
        rightLabel.textColor = [UIColor secondTitleColor];
        [self.contentView addSubview:rightLabel];
        _rightLabel = rightLabel;
    }
    return _rightLabel;
}
@end
