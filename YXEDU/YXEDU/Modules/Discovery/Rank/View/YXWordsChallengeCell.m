//
//  YXWordsChallengeCell.m
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXWordsChallengeCell.h"
#import "YXTextBorderLabel.h"


@interface YXWordsChallengeCell ()
@property (nonatomic, copy)NSDictionary *challengeDesArrtiDic;
@property (nonatomic, weak)YXTextBorderLabel *challengeTipsLabel;
@property (nonatomic, weak)YXNoHightButton *challengeBtn;
@property (nonatomic, weak) UILabel *tipsL;
@property (nonatomic, strong) UIImageView *beanIcon;
@property (nonatomic, strong) UILabel *needsScoreL;

@property (nonatomic, strong) YXGameModel *gameModel;
@property (nonatomic, strong) YXMyGradeModel *myGradeModel;
@end

@implementation YXWordsChallengeCell
{
   
    YXGameState _gameState;
}
@dynamic delegate;

- (void)setupSubviews {
    [super setupSubviews];
    self.bgImageView.image = [UIImage imageNamed:@"challengeBgImage"];
    self.titleView.titleLabel.text = @"单词挑战";

    self.challengeDesArrtiDic = @{
                                  NSForegroundColorAttributeName : [UIColor secondTitleColor],
                                  NSFontAttributeName : [UIFont systemFontOfSize:12]
                                  };
    
    [self challengeTipsLabel];
    [self challengeBtn];
}

- (BOOL)rightLabelCanReceiveClick {
    return NO;
}

#pragma mark - event
- (void)gameChallenge {
    if ([self.delegate respondsToSelector:@selector(wordsChallengeCellTapChallenge:)]) {
        [self.delegate wordsChallengeCellTapChallenge:self];
    }
}

#pragma mark - showData
- (void)configWithGameModel:(YXGameModel *)gameModel gradeMode:(YXMyGradeModel *)myGradeModel {
    self.myGradeModel = myGradeModel;
    self.gameModel = gameModel;
    
//    gameModel.needCredits = 100;
//    myGradeModel.userCredits = 150;
    
    if (gameModel.needCredits == 0) { //挑战不需要积分
        self.challengeBtn.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(18)];
        self.challengeBtn.titleEdgeInsets = UIEdgeInsetsMake(AdaptSize(2), 0, 0, 0);
        [self.challengeBtn setBackgroundImage:[UIImage imageNamed:@"challengeButtonImage"] forState:UIControlStateNormal];
        if (gameModel.times == 1) { // 第一次挑战
            _gameState = YXGameStateFirstTime;
            [self.challengeBtn setTitle:@"开始挑战" forState:UIControlStateNormal];
        }else {
            _gameState = YXGameStateDoItAgain;
            [self.challengeBtn setTitle:@"再来一次" forState:UIControlStateNormal];
        }
        self.beanIcon.hidden = YES;
        self.needsScoreL.hidden = YES;
    }else {
        self.beanIcon.hidden = NO;
        self.needsScoreL.hidden = NO;
        self.challengeBtn.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(15)];
        [self.challengeBtn setTitle:@"再来一次" forState:UIControlStateNormal];
        self.needsScoreL.text = [NSString stringWithFormat:@"-%zd",gameModel.needCredits];
        if (myGradeModel.userCredits >= self.gameModel.needCredits) { // 积分够用
            _gameState = YXGameStateCanChallenge;
            self.needsScoreL.textColor = [UIColor whiteColor];
            self.challengeBtn.titleEdgeInsets = UIEdgeInsetsMake(AdaptSize(2), -AdaptSize(40), 0, 0);
            [self.challengeBtn setBackgroundImage:[UIImage imageNamed:@"challengeButtonImage1"] forState:UIControlStateNormal];
        }else {
            _gameState = YXGameStateCannotChallenge;
            self.needsScoreL.textColor = [UIColor secondTitleColor];
            self.challengeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -AdaptSize(50), 0, 0);
        }
    }
    
    if (self.gameState == YXGameStateCannotChallenge) {
        self.tipsL.hidden = NO;
        [self.challengeBtn setTitleColor:[UIColor secondTitleColor] forState:UIControlStateNormal];
        self.challengeBtn.backgroundColor = UIColorOfHex(0xEFF4F7);
        [self.challengeBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.challengeBtn.layer.cornerRadius = AdaptSize(20);
    }else {
        self.tipsL.hidden = YES;
        [self.challengeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.challengeBtn.backgroundColor = [UIColor clearColor];
        self.challengeBtn.layer.cornerRadius = 0;
    }
}

- (void)setGameModel:(YXGameModel *)gameModel {
    _gameModel = gameModel;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont pfSCMediumFontWithSize:AdaptSize(18)],
                                 NSForegroundColorAttributeName : [UIColor mainTitleColor],
                                 };
    
    NSString *oriTips = nil;
    NSString *replaceStr = nil;
    if (self.myGradeModel.state == YXChallengeSuccess) { // 挑战成功显示排名
        oriTips = [NSString stringWithFormat:@"已挑战《%@》排名%zd",gameModel.name,self.myGradeModel.desc.ranking];
        replaceStr = [NSString stringWithFormat:@"%zd",self.myGradeModel.desc.ranking];
    }else {
        oriTips = [NSString stringWithFormat:@"挑战《%@》最高获取%@积分",gameModel.name,gameModel.maxCredits];
        replaceStr = gameModel.maxCredits;
    }

    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:oriTips
                                                                                    attributes:attributes];
    NSRange range = [oriTips rangeOfString:replaceStr];
    [attriString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFD9725) range:range];
    self.challengeTipsLabel.attributedText = attriString;
    
    self.rightLabel.attributedText = gameModel.timeStampAttriString;//desAttriString;
}

#pragma mark - subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    self.bgImageView.frame = CGRectMake(0, AdaptSize(48), size.width, AdaptSize(100));
    self.challengeTipsLabel.frame = CGRectMake(0, self.bgImageView.bottom - AdaptSize(24), size.width, AdaptSize(24));
    
    if (self.gameState == YXGameStateCannotChallenge) {
        CGSize btnSize = MakeAdaptCGSize(182, 40);
        CGFloat x = (size.width - btnSize.width) * 0.5;
        CGFloat y = self.challengeTipsLabel.bottom + AdaptSize(15);
        self.challengeBtn.frame = CGRectMake(x, y, btnSize.width, btnSize.height);
        
        self.tipsL.frame = CGRectMake(0, self.challengeBtn.bottom + AdaptSize(10), size.width, 12);
    }else if(self.gameState == YXGameStateCanChallenge){
        CGSize btnSize = MakeAdaptCGSize(193, 63);
        CGFloat x = (size.width - btnSize.width) * 0.5;
        CGFloat y = self.challengeTipsLabel.bottom + AdaptSize(10);
        self.challengeBtn.frame = CGRectMake(x, y, btnSize.width, btnSize.height);
    }else {
        CGSize btnSize = MakeAdaptCGSize(176, 63);
        CGFloat x = (size.width - btnSize.width) * 0.5;
        CGFloat y = self.challengeTipsLabel.bottom + AdaptSize(10);
        self.challengeBtn.frame = CGRectMake(x, y, btnSize.width, btnSize.height);
    }
    
    if (self.gameState == YXGameStateCannotChallenge || self.gameState == YXGameStateCanChallenge) {
        [self.challengeBtn layoutIfNeeded];
        CGFloat beanIconWH = AdaptSize(20);
        CGFloat beanX = self.challengeBtn.titleLabel.right;
        CGFloat beanY = CGRectGetMidY(self.challengeBtn.titleLabel.frame) - beanIconWH * 0.5 + AdaptSize(2);
        self.beanIcon.frame = CGRectMake(beanX, beanY, beanIconWH, beanIconWH);
        
        self.needsScoreL.frame = CGRectMake(self.beanIcon.right , self.challengeBtn.titleLabel.top, AdaptSize(50), beanIconWH);
    }
}

- (YXTextBorderLabel *)challengeTipsLabel {
    if (!_challengeTipsLabel) {
        YXTextBorderLabel *challengeTipsLabel = [[YXTextBorderLabel alloc] init];
        challengeTipsLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:challengeTipsLabel];
        _challengeTipsLabel = challengeTipsLabel;
    }
    return _challengeTipsLabel;
}


- (YXNoHightButton *)challengeBtn {
    if (!_challengeBtn) {
        YXNoHightButton *challengeBtn = [[YXNoHightButton alloc] init];
        challengeBtn.titleLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(18)];
        [challengeBtn addTarget:self action:@selector(gameChallenge) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:challengeBtn];
        _challengeBtn = challengeBtn;
    }
    return _challengeBtn;
}

- (UILabel *)tipsL {
    if (!_tipsL) {
        UILabel *tipsL = [[UILabel alloc] init];
        tipsL.textAlignment = NSTextAlignmentCenter;
        tipsL.text = @"当前积分不足，签到或完成任务可以获取积分";
        tipsL.textColor = [UIColor secondTitleColor];
        tipsL.font = [UIFont pfSCRegularFontWithSize:11];
        [self.contentView addSubview:tipsL];
        _tipsL = tipsL;
    }
    return _tipsL;
}

- (UIImageView *)beanIcon {
    if (!_beanIcon) {
        _beanIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goldBeanImage"]];
        _beanIcon.userInteractionEnabled = NO;
        [self.challengeBtn addSubview:_beanIcon];
    }
    return _beanIcon;
}

- (UILabel *)needsScoreL {
    if (!_needsScoreL) {
        UILabel *needsScoreL = [[UILabel alloc] init];
        needsScoreL.userInteractionEnabled = NO;
        needsScoreL.text = @"-50";
        needsScoreL.textColor = [UIColor secondTitleColor];
        needsScoreL.font = [UIFont pfSCMediumFontWithSize:AdaptSize(14)];
        [self.challengeBtn addSubview:needsScoreL];
        _needsScoreL = needsScoreL;
    }
    return _needsScoreL;
}
@end
