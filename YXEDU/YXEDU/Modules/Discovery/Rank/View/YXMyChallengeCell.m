//
//  YXMyChallengeCell.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMyChallengeCell.h"

@interface YXMyChallengeCell ()
@property (nonatomic, strong)UIImageView *shareImageView;
@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)UIImageView *myRangeIcon;
@property (nonatomic, weak) UILabel *tipsL;
@end

@implementation YXMyChallengeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myRangeBGImage"]];
        [self.contentView insertSubview:self.bgImageView atIndex:0];
        
        self.myRangeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"myRangeIcon"]];
        [self.bgImageView addSubview:self.myRangeIcon];
        self.userView.challengeUserViewType = YXChallengeUserViewMe;
        self.userView.numberLabel.textColor = [UIColor whiteColor];
        self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:16];
        self.userView.userNameLabel.textColor = [UIColor whiteColor];
        self.userView.userNameLabel.font = [UIFont pfSCMediumFontWithSize:14];
        self.userView.answeredlabel.textColor = [UIColor whiteColor];
        self.userView.answeredlabel.font = [UIFont pfSCMediumFontWithSize:14];
        self.userView.spendTimeLabel.textColor = [UIColor whiteColor];
        self.userView.spendTimeLabel.font = [UIFont pfSCMediumFontWithSize:14];
        self.userView.userIcon.layer.borderWidth = 1.5;
        self.userView.userIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        self.line.hidden = YES;
        self.userView.userIcon.layer.cornerRadius = 21;
        self.userView.userIcon.layer.masksToBounds = YES;
        [self tipsL];
        [self shareImageView];
        [self.shareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgImageView).with.offset(3.f);
            make.right.equalTo(self.bgImageView).with.offset(-8.f);
            make.size.mas_equalTo(CGSizeMake(45.f, 47.f));
        }];
    }
    return self;
}

- (void)setMyRankModel:(YXMyGradeModel *)myRankModel {
    _myRankModel = myRankModel;
    NSString *numText = nil;
    
    if (myRankModel.state == YXChallengeSuccess) {
//        self.userView.userNameLabel.text = myRankModel.desc.nick;
        self.userView.userNameLabel.attributedText = [self convertAttributeString:myRankModel.desc.nick];
        if (myRankModel.desc.ranking > 0) {
            numText = [NSString stringWithFormat:@"%02zd",myRankModel.desc.ranking];
            self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:16];
        }else {
            numText = @"未上榜";
            self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:12];
        }
        self.tipsL.hidden = YES;
        self.userView.answeredlabel.attributedText = [self convertAttributeString:[NSString stringWithFormat:@"答题%@个",myRankModel.desc.correctNum]];
        self.userView.spendTimeLabel.attributedText = [self convertAttributeString:[NSString stringWithFormat:@"耗时%@",myRankModel.desc.spendTime]];
    }else {
        NSString *tipsString = nil;
        if (myRankModel.state == YXChallengeIneligible || myRankModel.state == YXChallengeUnDo) {
            tipsString = @"本期尚未完成单词挑战";
        }else {
            tipsString = @"挑战失败\n别放弃，再接再厉哟";
        }
        self.tipsL.attributedText = [self convertAttributeString:tipsString];
        self.userView.userNameLabel.text = @"";
        numText = @"未上榜";
        self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:12];
        self.userView.answeredlabel.text = @"";
        self.userView.answeredlabel.text = @"";
        self.tipsL.hidden = NO;
    }
    if (myRankModel.desc.ranking > 0) {
        [self.shareImageView setHidden:NO];
    }
    self.userView.numberLabel.attributedText = [self convertAttributeString:numText];
    
    
    if (myRankModel.acrIcon) {
        self.userView.userIcon.image = myRankModel.acrIcon;
    }else {
        __weak typeof(self) weakSelf = self;
        [self.userView.userIcon sd_setImageWithURL:[NSURL URLWithString:myRankModel.avatar]
                                  placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]
                                         completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                             if (image) {
                                                 myRankModel.acrIcon = [image imageWithSize:CGSizeMake(39, 39) andCornerRadius:19.5];
                                                 weakSelf.userView.userIcon.image = myRankModel.acrIcon;
                                             }
                                         }];
    }
}


- (void)setPreRankModel:(YXMyPreGradeModel *)preRankModel {
    _preRankModel = preRankModel;
    NSString *numText = nil;

    
    if (preRankModel.state == 1) { // 挑战成功
        self.userView.userNameLabel.attributedText = [self convertAttributeString:preRankModel.nick];
        if (preRankModel.ranking > 0) {
            numText = [NSString stringWithFormat:@"%02zd",preRankModel.ranking];
            self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:16];
        }else {
            numText = @"未上榜";
            self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:12];
        }
        self.tipsL.hidden = YES;
        self.userView.answeredlabel.attributedText = [self convertAttributeString:[NSString stringWithFormat:@"答题%@个",preRankModel.correctNum]];
        self.userView.spendTimeLabel.attributedText = [self convertAttributeString:[NSString stringWithFormat:@"耗时%@",preRankModel.spendTime]];
    }else {
        NSString *tipsString = nil;
        if (preRankModel.state == 3) { // 上期游戏未参加挑战
            tipsString = @"本期尚未完成单词挑战";
        }else {
            tipsString = @"挑战失败\n别放弃，再接再厉哟";
        }

        self.tipsL.attributedText = [self convertAttributeString:tipsString];
        self.userView.userNameLabel.text = @"";
        numText = @"未上榜";
        self.userView.numberLabel.font = [UIFont pfSCMediumFontWithSize:12];
        self.userView.answeredlabel.text = @"";
        self.userView.answeredlabel.text = @"";
        self.tipsL.hidden = NO;
    }
    self.userView.numberLabel.attributedText = [self convertAttributeString:numText];
//    self.userView.numberLabel.text = numText;
    
    
    if (preRankModel.acrIcon) {
        self.userView.userIcon.image = preRankModel.acrIcon;
    }else {
        __weak typeof(self) weakSelf = self;
        [self.userView.userIcon sd_setImageWithURL:[NSURL URLWithString:preRankModel.avatar]
                                  placeholderImage:[UIImage imageNamed:@"userPlaceHolder"]
                                         completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                             if (image) {
                                                 preRankModel.acrIcon = [image imageWithSize:CGSizeMake(39, 39) andCornerRadius:19.5];
                                                 weakSelf.userView.userIcon.image = preRankModel.acrIcon;
                                             }
                                         }];
    }
}

- (NSAttributedString *)convertAttributeString:(NSString *)oriString {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = UIColorOfHex(0x3b91d6);
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 2.0;
    NSDictionary *attributeDic = @{
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSShadowAttributeName : shadow
                                   };
    return [[NSAttributedString alloc] initWithString:oriString attributes:attributeDic];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.myRangeIcon.frame = CGRectMake(0, 0, 58,28);
    
    CGRect userFrame = self.userView.frame;
    userFrame.size.width = self.line.width;
    self.userView.frame = userFrame;
    [self.userView layoutIfNeeded];
    
    CGRect bgFrame = CGRectOffset(userFrame, -5, -8);
    bgFrame.size.width += 11;
    bgFrame.size.height += 24;
    self.bgImageView.frame = bgFrame;
    
    CGRect nameConverFrame = [self convertRect:self.userView.userNameLabel.frame fromView:self.userView];
    self.tipsL.frame = CGRectMake(nameConverFrame.origin.x,self.userView.top + 2, nameConverFrame.size.width, self.userView.height);
}

- (UILabel *)tipsL {
    if (!_tipsL) {
        UILabel *tipsL = [[UILabel alloc] init];
        tipsL.text = @"挑战失败\n别放弃，再接再厉哟";
        tipsL.textColor = [UIColor whiteColor];
        tipsL.font = [UIFont pfSCMediumFontWithSize:14];
        tipsL.numberOfLines = 0;
        tipsL.hidden = YES;
        [self.contentView addSubview:tipsL];
        _tipsL = tipsL;
    }
    return _tipsL;
}

- (UIImageView *)shareImageView {
    if (!_shareImageView) {
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"share_icon"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchShareImageView:)];
        [imageview setUserInteractionEnabled:YES];
        [imageview addGestureRecognizer:tap];
        [self addSubview:imageview];
        [self bringSubviewToFront:imageview];
        [imageview setHidden:YES];
        _shareImageView = imageview;
    }
    return _shareImageView;
}

- (void)touchShareImageView:(UITapGestureRecognizer *)tap {
    if (self.shareBlock) {
        self.shareBlock();
    }
}
@end
