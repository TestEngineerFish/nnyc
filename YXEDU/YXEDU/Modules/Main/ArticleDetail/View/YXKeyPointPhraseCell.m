//
//  YXKeyPointPhraseCell.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/6/4.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXKeyPointPhraseCell.h"

@interface YXKeyPointPhraseCell ()
@property (nonatomic, strong) UILabel *engLabel;
@property (nonatomic, strong) UILabel *cheLabel;
@property (nonatomic, weak)   UIView *lineView;
@end

@implementation YXKeyPointPhraseCell

- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 1000.f, 0, 0.f);
    [self.engLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(20.f);
    }];
    [self.cheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.engLabel.mas_right).with.offset(10.f);
        make.right.lessThanOrEqualTo(self).with.offset(-10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(17.f);
        make.right.equalTo(self).with.offset(-17.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self);
    }];
}

- (void)setCell:(YXKeyPointPhraseModel *)phraseModel {
    [self initUI];
    self.engLabel.text = phraseModel.eng;
    self.cheLabel.text = phraseModel.che;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - subviews

- (UILabel *)engLabel {
    if (!_engLabel) {
        UILabel *engLabel = [[UILabel alloc] init];
        engLabel.font = [UIFont systemFontOfSize:15.f];
        engLabel.textColor = UIColorOfHex(0x485461);
        [self addSubview:engLabel];
        _engLabel = engLabel;
    }
    return _engLabel;
}

- (UILabel *)cheLabel {
    if (!_cheLabel) {
        UILabel *cheLabel = [[UILabel alloc] init];
        cheLabel.font = [UIFont systemFontOfSize:15.f];
        cheLabel.textColor = UIColorOfHex(0x485461);
        [self addSubview:cheLabel];
        _cheLabel = cheLabel;
    }
    return _cheLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorOfHex(0xE9EFF4);
        [self addSubview:lineView];
        _lineView = lineView;
    }
    return _lineView;
}

@end
