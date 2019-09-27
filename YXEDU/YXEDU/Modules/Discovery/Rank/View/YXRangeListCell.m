//
//  YXRangeListCell.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRangeListCell.h"
#import "YXChallengeUserBaseView.h"


@interface YXRangeUserView : YXChallengeUserBaseView
@property (nonatomic, weak)UIImageView *crownIcon;
@property (nonatomic, assign)CGSize iconSize;
@property (nonatomic, strong) YXUserRankModel *userRankModel;
@property (nonatomic, weak) UILabel *meLabel;
- (instancetype)initWithRankType:(YXRankType)rankType;
@end

@implementation YXRangeUserView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor redColor];
        [self.numberLabel removeFromSuperview];
        self.answeredlabel.textColor = UIColorOfHex(0xFD9725);
        self.userNameLabel.textAlignment = NSTextAlignmentCenter;
        self.answeredlabel.textAlignment = NSTextAlignmentCenter;
        self.spendTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self meLabel];
    }
    return self;
}

- (void)setUserRankModel:(YXUserRankModel *)userRankModel {
    _userRankModel = userRankModel;
    if (userRankModel) {
        self.userNameLabel.text = userRankModel.nick;
        self.answeredlabel.text = [NSString stringWithFormat:@"答题%@个",userRankModel.correctNum];
        self.spendTimeLabel.text = [NSString stringWithFormat:@"耗时%@",userRankModel.spendTime];
        
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:userRankModel.avatar]
                         placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]];
    }else {
        self.userNameLabel.text = @"虚席以待";
        self.answeredlabel.text = @"答题__个";
        self.spendTimeLabel.text = @"耗时__";
        self.userIcon.image = [UIImage imageNamed:@"userPlaceHolder"];
    }
    self.meLabel.hidden = !userRankModel.isMyself;
}

- (instancetype)initWithRankType:(YXRankType)rankType {
    if (self = [super init]) {
        CGSize size = CGSizeZero;
        UIImage *crownImage = nil;
        CGColorRef color;
        if (rankType == YXRankGold) {
            size = MakeAdaptCGSize(76, 76);
            crownImage = [UIImage imageNamed:@"goldIcon"];
            color = UIColorOfHex(0xF8C036).CGColor;
        }else if(rankType == YXRankSilver) {
            size = MakeAdaptCGSize(60, 60);
            crownImage = [UIImage imageNamed:@"silverIcon"];
            color = UIColorOfHex(0xC7D3E1).CGColor;
        }else {
            size = MakeAdaptCGSize(60, 60);
            crownImage = [UIImage imageNamed:@"copperIcon"];
            color = UIColorOfHex(0xF1B784).CGColor;
        }
        self.iconSize = size;
        self.userIcon.layer.cornerRadius = size.width * 0.5;
        self.userIcon.layer.masksToBounds = YES;
        self.userIcon.layer.borderWidth = AdaptSize(3);
        self.userIcon.layer.borderColor = color;
        self.crownIcon.image = crownImage;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat verMargin = AdaptSize(10);
    CGFloat labelHeight = 13;
    self.spendTimeLabel.frame = CGRectMake(0, size.height - labelHeight, size.width, labelHeight);
    CGFloat answerLabelY = self.spendTimeLabel.top - verMargin - labelHeight;
    self.answeredlabel.frame = CGRectMake(0, answerLabelY, size.width, labelHeight);
    CGFloat userNameLabelY = self.answeredlabel.top - verMargin - labelHeight;
    self.userNameLabel.frame = CGRectMake(0, userNameLabelY, size.width, labelHeight);
    
    CGFloat iconX = (size.width - self.iconSize.width) * 0.5;
    CGFloat iconY = self.userNameLabel.top - 15 - self.iconSize.height;
    self.userIcon.frame = CGRectMake(iconX, iconY, self.iconSize.width, self.iconSize.height);
    
    CGSize crownSize = MakeAdaptCGSize(32, 20);
    CGFloat crownX = (size.width - crownSize.width) * 0.5;
    CGFloat crownY = self.userIcon.top - AdaptSize(12);
    self.crownIcon.frame = CGRectMake(crownX, crownY, crownSize.width, crownSize.height);
    
    
    CGFloat meLabelWH = AdaptSize(20);
    CGFloat XoffsetCenter = (self.size.width * 0.5 - meLabelWH) *0.5;
    CGFloat meLabelX = CGRectGetMidX(self.userIcon.frame) + XoffsetCenter;
    CGFloat meLabelY = CGRectGetMaxY(self.userIcon.frame) - meLabelWH;
    self.meLabel.frame  = CGRectMake(meLabelX, meLabelY, meLabelWH, meLabelWH);
}

- (UIImageView *)crownIcon {
    if (!_crownIcon) {
        UIImageView *crownIcon = [[UIImageView alloc] init];
        [self addSubview:crownIcon];
        _crownIcon = crownIcon;
    }
    return _crownIcon;
}

- (UILabel *)meLabel {
    if (!_meLabel) {
        UILabel *meLabel = [[UILabel alloc] init];
        meLabel.text = @"我";
        meLabel.font = [UIFont systemFontOfSize:AdaptSize(12)];
        meLabel.textColor = [UIColor whiteColor];
        meLabel.backgroundColor = UIColorOfHex(0xFD9725);
        meLabel.textAlignment = NSTextAlignmentCenter;
        meLabel.layer.cornerRadius = AdaptSize(10);
        meLabel.layer.masksToBounds = YES;
        [self addSubview:meLabel];
        _meLabel = meLabel;
    }
    return _meLabel;
}
@end







@interface YXRangeListCell ()
@property (nonatomic, weak)YXRangeUserView *goldUserView;
@property (nonatomic, weak)YXRangeUserView *silverUserView;
@property (nonatomic, weak)YXRangeUserView *copperUserView;
@property (nonatomic, copy) NSArray *rankViews;
@end

@implementation YXRangeListCell
- (void)setTopThreeUsers:(NSArray *)topThreeUsers {
    _topThreeUsers = topThreeUsers;
    for (NSInteger i = 0; i < self.rankViews.count; i++) {
        YXRangeUserView *rankView = [self.rankViews objectAtIndex:i];
        YXUserRankModel *userRankModel = nil;
        if (i < topThreeUsers.count) {
            userRankModel = [topThreeUsers objectAtIndex:i];
        }
        
        rankView.userRankModel = userRankModel;
    }
}


- (void)setupSubviews {
    [super setupSubviews];
    self.bgImageView.image = [UIImage imageNamed:@"rangeBgImage"];
    self.titleView.titleLabel.text = @"排行榜";
    self.rightLabel.text = @"查看上期排名>>";
    [self goldUserView];
    [self silverUserView];
    [self copperUserView];
    self.rankViews = @[self.goldUserView,self.silverUserView,self.copperUserView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    self.bgImageView.frame = self.contentView.bounds;
    CGFloat rightLabelWidth = 120;
    self.rightLabel.frame = CGRectMake(size.width - rightLabelWidth - AdaptSize(15), AdaptSize(7), rightLabelWidth, 36);
    
    CGFloat userViewHeight = AdaptSize(170);
    CGFloat userViewWidth = AdaptSize(100);
    CGFloat userViewX =  (self.size.width - userViewWidth) * 0.5;
    CGFloat userViewY =  self.size.height - AdaptSize(40) - userViewHeight;
    CGRect goldFrame = CGRectMake(userViewX , userViewY, userViewWidth, userViewHeight);
    self.goldUserView.frame = goldFrame;
    CGFloat offsetX = AdaptSize(18) + userViewWidth;
    self.silverUserView.frame = CGRectOffset(goldFrame, -offsetX, 0);
    self.copperUserView.frame = CGRectOffset(goldFrame, offsetX, 0);
}

- (YXRangeUserView *)goldUserView {
    if (!_goldUserView) {
        YXRangeUserView *goldUserView = [[YXRangeUserView alloc] initWithRankType:YXRankGold];
        [self addSubview:goldUserView];
        _goldUserView = goldUserView;
    }
    return _goldUserView;
}

- (YXRangeUserView *)silverUserView {
    if (!_silverUserView) {
        YXRangeUserView *silverUserView = [[YXRangeUserView alloc] initWithRankType:YXRankSilver];
        [self addSubview:silverUserView];
        _silverUserView = silverUserView;
    }
    return _silverUserView;
}

- (YXRangeUserView *)copperUserView {
    if (!_copperUserView) {
        YXRangeUserView *copperUserView = [[YXRangeUserView alloc] initWithRankType:YXRankCopper];
        [self addSubview:copperUserView];
        _copperUserView = copperUserView;
    }
    return _copperUserView;
}

@end
