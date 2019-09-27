//
//  YXSelectMyWordHeaderView.m
//  YXEDU
//
//  Created by yao on 2019/2/21.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSelectMyWordHeaderView.h"

@interface YXMyWordBaseHeaderView ()
@property (nonatomic, weak) UIView *seprateLine;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *progressLabel;
@end


@implementation YXMyWordBaseHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(AdaptSize(10));
        }];
        
        CGFloat margin = AdaptSize(10);
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).offset(margin);
//            make.right.equalTo(self.contentView).offset(-margin).priority(MASLayoutPriorityDefaultLow);
        }];
        
        [self.seprateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(1.0);
        }];
    }
    return self;
}

- (void)dealloc {
    
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.preferredMaxLayoutWidth = AdaptSize(150);
//        titleLabel.text = @"Starter Unit 1";
        titleLabel.textColor = UIColorOfHex(0x485461);
        titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(14)];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        UILabel *progressLabel = [[UILabel alloc] init];
//        progressLabel.text = @" (2/245)";
        progressLabel.textColor = UIColorOfHex(0x849EC5);
        progressLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(13)];
        [self.contentView addSubview:progressLabel];
        _progressLabel = progressLabel;
    }
    return _progressLabel;
}


@end


@interface YXSelectMyWordHeaderView ()
@property (nonatomic, weak) UIImageView *openIndicator;
@end
@implementation YXSelectMyWordHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.progressLabel.preferredMaxLayoutWidth = AdaptSize(100);
        self.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(16)];
        self.progressLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(15)];
        [self.openIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-AdaptSize(10));
            make.size.mas_equalTo(MakeAdaptCGSize(16, 9));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapAction {
    self.unitModel.selected = !self.unitModel.selected;
    if (self.headerViewTapedBlock) {
        self.headerViewTapedBlock();
    }
}

- (void)setUnitModel:(YXBookUnitContentModel *)unitModel {
    _unitModel = unitModel;
    [self updateInfo];
}

- (void)updateInfo {
    YXBookUnitContentModel *unitModel = self.unitModel;
    self.titleLabel.text = unitModel.name;
    self.progressLabel.text = [NSString stringWithFormat:@"(%zd/%zd)",unitModel.unitSelectedWordsCount,unitModel.words.count];
    NSString *imageName = unitModel.isSelected ? @"indicatorIcon_close" : @"indicatorIcon_open";
    self.openIndicator.image = [UIImage imageNamed:imageName];
}
#pragma mark - subviews
- (UIImageView *)openIndicator {
    if (!_openIndicator) {
        UIImageView *openIndicator = [[UIImageView alloc] init];
//        openIndicator.image = [UIImage imageNamed:@"indicatorIcon_open"];//[UIImage imageNamed:@"indicatorIcon_close"];
        [self.contentView addSubview:openIndicator];
        _openIndicator = openIndicator;
    }
    return _openIndicator;
}


@end
