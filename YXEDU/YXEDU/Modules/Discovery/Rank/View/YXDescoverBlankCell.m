//
//  YXDescoverBlankCell.m
//  YXEDU
//
//  Created by yao on 2018/12/25.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoverBlankCell.h"
@interface YXDescoverBlankCell ()
@property (nonatomic, weak)UILabel *tipsLabel;
@end

@implementation YXDescoverBlankCell
- (void)setupSubviews {
    [super setupSubviews];
    self.titleView.titleLabel.text = @"单词挑战";
    self.rightLabel.textColor = UIColorOfHex(0x60B6F8);
    self.rightLabel.text = @"查看上期排名>>";
}

- (void)setGameState:(NSInteger)gameState {
    _gameState = gameState;
    if (gameState == 2) { //2 版本过低
        self.bgImageView.image = [UIImage imageNamed: @"appVersionLower"];
        self.tipsLabel.text = [NSString stringWithFormat:@"本期挑战为“%@”\n您的App版本过低，请更新后再参与挑战",self.gameName];
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"noChallengeImage"];
        self.tipsLabel.text = @"当前暂无挑战，尽请期待~";
    }
}

- (void)configGameName:(NSString *)gameName gameState:(NSInteger)gameState {
    _gameState = gameState;
    _gameName = gameName;
    if (gameState == 2) { //2 版本过低
        self.bgImageView.image = [UIImage imageNamed: @"appVersionLower"];
        self.tipsLabel.text = [NSString stringWithFormat:@"本期挑战为“%@”\n您的App版本过低，请更新后再参与挑战",self.gameName];
    }else {
        self.bgImageView.image = [UIImage imageNamed:@"noChallengeImage"];
        self.tipsLabel.text = @"当前暂无挑战，尽请期待~";
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.contentView.bounds.size;
    CGFloat bgWidth = 230;
    CGFloat bgHeight = 180;
    CGFloat x = (size.width - bgWidth) * 0.5;
    CGFloat y = AdaptSize(97);
    self.bgImageView.frame = CGRectMake(x, y, bgWidth, bgHeight);
    
    CGFloat tipsW = 275;
    CGFloat tipsX = (size.width - tipsW) * 0.5;
    self.tipsLabel.frame = CGRectMake(tipsX, self.bgImageView.bottom - 5, tipsW, 50);
    
    CGFloat rightLabelWidth = 120;
    self.rightLabel.frame = CGRectMake(size.width - rightLabelWidth - AdaptSize(15), AdaptSize(7), rightLabelWidth, 36);
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.numberOfLines = 0;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont pfSCRegularFontWithSize:15];
        tipsLabel.textColor = [UIColor secondTitleColor];
        [self.contentView addSubview:tipsLabel];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

@end
