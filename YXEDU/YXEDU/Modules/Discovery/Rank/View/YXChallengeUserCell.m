//
//  YXChallengeUserCell.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXChallengeUserCell.h"
@implementation YXChallengeCellUserView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    
    CGFloat contentMargin = AdaptSize(10);
    CGFloat answeredLabelW = 0;
    CGFloat numberlabelY = 0;
    if (self.challengeUserViewType == YXChallengeUserViewMe) {
        answeredLabelW = 70;
        numberlabelY = (size.height - 16) * 0.5 + 4;
    }else {
        answeredLabelW = 57;
        numberlabelY = (size.height - 16) * 0.5;
    }
    
    self.numberLabel.frame = CGRectMake(contentMargin, numberlabelY, 40, 16);
    
    CGFloat iconWH = 42;
    CGFloat iconX = self.numberLabel.right + AdaptSize(6);
    CGFloat iconY = (size.height - iconWH) * 0.5 + (self.challengeUserViewType == YXChallengeUserViewMe ? 2 : 0);
    self.userIcon.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    CGFloat nameX = self.userIcon.right + AdaptSize(20);
    CGFloat nameY = self.userIcon.top + 4;
    CGFloat width = size.width - nameX;
    self.userNameLabel.frame = CGRectMake(nameX, nameY, width, 14);
    
    CGFloat answerLabelY = self.userNameLabel.bottom + 6;
    self.answeredlabel.frame = CGRectMake(nameX, answerLabelY, answeredLabelW, 14);

    CGFloat spendLabelX = self.answeredlabel.right + AdaptSize(5);
    CGFloat spendLabelW = size.width - spendLabelX;
    self.spendTimeLabel.frame = CGRectMake(spendLabelX, answerLabelY, spendLabelW, 14);
}
@end








@interface YXChallengeUserCell ()

@end

@implementation YXChallengeUserCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        YXChallengeCellUserView *userView = [[YXChallengeCellUserView alloc] init];
        userView.challengeUserViewType = YXChallengeUserViewOther;
        [self.contentView addSubview:userView];
        _userView = userView;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor separateColor];
        [self.contentView addSubview:line];
        _line = line;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
}

- (void)setUserRankModel:(YXUserRankModel *)userRankModel {
    _userRankModel = userRankModel;
    self.userView.userNameLabel.text = userRankModel.nick;
    self.userView.answeredlabel.text = [NSString stringWithFormat:@"答题%@个",userRankModel.correctNum];
    self.userView.spendTimeLabel.text = [NSString stringWithFormat:@"耗时%@",userRankModel.spendTime];
    self.userView.numberLabel.text = [NSString stringWithFormat:@"%02ld",userRankModel.ranking];
    if (userRankModel.acrIcon) {
        self.userView.userIcon.image = userRankModel.acrIcon;
    }else {
        __weak typeof(self) weakSelf = self;
        [self.userView.userIcon sd_setImageWithURL:[NSURL URLWithString:userRankModel.avatar]
                                  placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]
                                         completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                             if (image) {
                                                 userRankModel.acrIcon = [image imageWithSize:CGSizeMake(41, 41) andCornerRadius:20.5];
                                                 weakSelf.userView.userIcon.image = userRankModel.acrIcon;
                                             }
                                         }];
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = AdaptSize(15);
    CGSize size = self.contentView.bounds.size;
    
    CGFloat topBomMargin = 12;
    CGFloat userViewH = size.height - 2 * topBomMargin;
    self.line.frame = CGRectMake(margin, size.height - 0.5, size.width - 2 * margin, 0.5);
    
    CGFloat userViewW = self.line.width - kScoreViewWidth;
    self.userView.frame = CGRectMake(margin, topBomMargin, userViewW, userViewH);
    
}
@end
