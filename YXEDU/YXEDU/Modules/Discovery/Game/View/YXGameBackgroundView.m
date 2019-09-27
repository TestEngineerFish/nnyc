//
//  YXGameBackgroundView.m
//  YXEDU
//
//  Created by yao on 2018/12/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXGameBackgroundView.h"

@interface YXGameBackgroundView ()<YXSquareViewDelegate>
@property (nonatomic, weak) UIImageView *sunIcon;
@property (nonatomic, weak) UIImageView *timebordIcon;
@property (nonatomic, weak) UIImageView *explainIcon;
@property (nonatomic, weak) UIButton *skipButton;
@property (nonatomic, assign) NSInteger currentQuestionIndex;
@property (nonatomic, assign) NSInteger answerRightNum;
@property (nonatomic, assign) BOOL isFinished;
@end

@implementation YXGameBackgroundView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.isFinished = NO;
        self.userInteractionEnabled = YES;
        self.currentQuestionIndex = -1;
        self.sunIcon.image = [UIImage imageNamed:@"sunImage"];
        if (kIsIPhoneXSerious) {
            self.image = [UIImage imageNamed:@"gameBGImage_X"];
        }else {
            self.image = [UIImage imageNamed:@"gameBGImage_3"];
        }
    
        [self answerNumLabel];
        [self timebordIcon];
        [self countdownLabel];
        [self explainIcon];
        [self explainLabel];
        [self squareView];
        [self skipButton];
    }
    return self;
}

#pragma mark - data
- (void)setGameDetail:(YXGameDetailModel *)gameDetail {
    _gameDetail = gameDetail;
    self.currentQuestionIndex = -1;
    [self nextQuestion];
}

- (void)nextQuestion {
    _currentQuestionIndex ++;
    if (_currentQuestionIndex < self.gameDetail.gameContent.count) { //下一题
        YXGameContent *gameQuesModel = [self.gameDetail.gameContent objectAtIndex:_currentQuestionIndex];
        self.explainLabel.text = [NSString stringWithFormat:@"%@%@",gameQuesModel.nature,gameQuesModel.meaning];
        self.squareView.gameQuesModel = gameQuesModel;
        
        // 处理跳过按钮
        [self hideSkipButton];
        // TODO: ------跳过按钮隐藏时长控制
        NSInteger timeout = self.gameDetail.gameConf.timeOut;// 4.0;
        [self performSelector:@selector(showSkipButton) withObject:nil afterDelay:timeout];
    }else { //答题结束
        [self gameFinished];
    }
}
#pragma mark - game finish
- (void)gameFinished {
    dispatch_async_to_mainThread(^{
        if (!_isFinished) {
            _isFinished = YES;
            [self hideSkipButton];
            [self.squareView resetLotusViews];
            [self.squareView cancleFlashCorrectLotusViews];
            NSLog(@"答题结束---------------");
            // 生成答案
            NSMutableArray *answerRecords = [NSMutableArray array];
            for (YXGameContent *gameContent in self.gameDetail.gameContent) {
                [answerRecords addObject:gameContent.answerRecord];
            }
            self.gameAnswerModel.gameContent = answerRecords;
            self.gameAnswerModel.endTime = [[NSDate date] timeIntervalSince1970];
            if ([self.delegate respondsToSelector:@selector(gameBackgroundViewGameFinished:)]) {
                [self.delegate gameBackgroundViewGameFinished:self];
            }
        }
    });
}

#pragma mark skipAction
- (void)hideSkipButton {
    // 处理跳过按钮
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(showSkipButton) object:nil];
    self.skipButton.alpha = 0;
}

- (void)showSkipButton {
    [UIView animateWithDuration:0.25 animations:^{
        self.skipButton.alpha = 1;
    }];
}


#pragma mark - <YXSquareViewDelegate>
- (void)squareViewEnterNextQuestion:(YXSquareView *)squareView {
    self.answerRightNum ++;
    self.answerNumLabel.text = [NSString stringWithFormat:@"%zd",self.answerRightNum];
    [self nextQuestion];
}

#pragma mark - subviews
- (void)layoutSubviews {
    [super layoutSubviews];
    if (kIsIPhoneXSerious) {
        [self iphoneXSeriousLayoutSubviews];
        return;
    }
    CGSize size = self.bounds.size;
    CGFloat sunWH = AdaptSize(70);
    CGFloat sunX = size.width - AdaptSize(22) - sunWH;
    CGFloat sunY = AdaptSize(30);// + (iphoneXSerious ? 22 : 0);
    self.sunIcon.frame = CGRectMake(sunX,  sunY, sunWH, sunWH);
    CGFloat numlabelWH = AdaptSize(24);
    self.answerNumLabel.frame = CGRectMake(0, 0, numlabelWH, numlabelWH);
    self.answerNumLabel.center = self.sunIcon.center;
    
    CGFloat timebordIconY = AdaptSize(120);
    self.timebordIcon.frame = CGRectMake(AdaptSize(11), timebordIconY, AdaptSize(92), AdaptSize(117));
    self.countdownLabel.frame = CGRectMake(AdaptSize(20), AdaptSize(30), AdaptSize(65), AdaptSize(16));
    CATransform3D zRotate = CATransform3DMakeRotation(-M_PI / 20, 0, 0, 1);
    CATransform3D xRotate = CATransform3DRotate(zRotate, -M_PI / 16, 1, 0, 0);
    CATransform3D yRotate = CATransform3DRotate(xRotate, -M_PI / 20, 0, 1, 0);
    self.countdownLabel.layer.transform = yRotate;//CATransform3DMakeRotation(-M_PI / 20, 0, 0, 1);
    
    CGFloat explainIconY = AdaptSize(250);
    self.explainIcon.frame = CGRectMake(AdaptSize(32), explainIconY, AdaptSize(338), AdaptSize(62.5));
    
    CGFloat explainLabelW = AdaptSize(270);
    CGFloat explainIconX = (size.width - explainLabelW) * 0.5; //self.explainIcon.left + AdaptSize(20)
    self.explainLabel.frame = CGRectMake(explainIconX, self.explainIcon.top + AdaptSize(10), explainLabelW, AdaptSize(40));
    CGRect squqreFrame = self.squareView.frame;
    squqreFrame.origin.y = size.height - squqreFrame.size.height - kSafeBottomMargin;
    self.squareView.frame = squqreFrame;
    
    CGFloat btnWidth = AdaptSize(70);
    self.skipButton.frame = CGRectMake(self.explainIcon.right - AdaptSize(90), self.explainIcon.top - AdaptSize(35) , btnWidth, AdaptSize(35));
}

- (void)iphoneXSeriousLayoutSubviews {
    CGSize size = self.bounds.size;
    CGFloat sunWH = AdaptSize(70);
    CGFloat sunX = size.width - AdaptSize(12) - sunWH;
    CGFloat sunY = AdaptSize(45);// + (iphoneXSerious ? 22 : 0);
    self.sunIcon.frame = CGRectMake(sunX,  sunY, sunWH, sunWH);
    CGFloat numlabelWH = AdaptSize(24);
    self.answerNumLabel.frame = CGRectMake(0, 0, numlabelWH, numlabelWH);
    self.answerNumLabel.center = self.sunIcon.center;
    
    CGFloat timebordIconY = AdaptSize(195);
    self.timebordIcon.frame = CGRectMake(AdaptSize(11), timebordIconY, AdaptSize(92), AdaptSize(117));
    self.countdownLabel.frame = CGRectMake(AdaptSize(20), AdaptSize(30), AdaptSize(65), AdaptSize(16));
    CATransform3D zRotate = CATransform3DMakeRotation(-M_PI / 20, 0, 0, 1);
    CATransform3D xRotate = CATransform3DRotate(zRotate, -M_PI / 16, 1, 0, 0);
    CATransform3D yRotate = CATransform3DRotate(xRotate, -M_PI / 20, 0, 1, 0);
    self.countdownLabel.layer.transform = yRotate;//CATransform3DMakeRotation(-M_PI / 20, 0, 0, 1);
    
    CGFloat explainIconY = AdaptSize(332);
    self.explainIcon.frame = CGRectMake(AdaptSize(32), explainIconY, AdaptSize(338), AdaptSize(62.5));
    
    CGFloat explainLabelW = AdaptSize(270);
    CGFloat explainIconX = (size.width - explainLabelW) * 0.5; //self.explainIcon.left + AdaptSize(20)
    self.explainLabel.frame = CGRectMake(explainIconX, self.explainIcon.top + AdaptSize(10), explainLabelW, AdaptSize(40));
    
    CGRect squqreFrame = self.squareView.frame;
    squqreFrame.origin.y = size.height - squqreFrame.size.height - kSafeBottomMargin;
    self.squareView.frame = squqreFrame;
    
    CGFloat btnWidth = AdaptSize(70);
    self.skipButton.frame = CGRectMake(self.explainIcon.right - AdaptSize(90), self.explainIcon.top - AdaptSize(35) , btnWidth, AdaptSize(35));
}
#pragma mark - subViews
- (UIImageView *)sunIcon {
    if (!_sunIcon) {
        UIImageView *sunIcon = [[UIImageView alloc] init];//WithImage:[UIImage imageNamed:@"sunImage"]
        CAKeyframeAnimation *transformAnima =  [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        transformAnima.values = @[@0,@(M_PI),@(2 * M_PI)];
        
        transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transformAnima.repeatCount = HUGE_VALF;
        transformAnima.duration = 4;
        transformAnima.removedOnCompletion = NO;
        transformAnima.fillMode = kCAFillModeForwards;
        [sunIcon.layer addAnimation:transformAnima forKey:nil];
        [self addSubview:sunIcon];
        _sunIcon = sunIcon;
    }
    return _sunIcon;
}

- (UIImageView *)timebordIcon {
    if (!_timebordIcon) {
        UIImageView *timebordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeboardImage"]];
        [self addSubview:timebordIcon];
        _timebordIcon = timebordIcon;
    }
    return _timebordIcon;
}

- (UIImageView *)explainIcon {
    if (!_explainIcon) {
        UIImageView *explainIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"explainBGImage"]];
        [self addSubview:explainIcon];
        _explainIcon = explainIcon;
    }
    return _explainIcon;
}

- (UILabel *)explainLabel {
    if (!_explainLabel) {
        UILabel *explainLabel = [[UILabel alloc] init];
        explainLabel.textAlignment = NSTextAlignmentCenter;
//        explainLabel.text = @"n.咖啡";
        explainLabel.textColor = [UIColor whiteColor];
        explainLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(20)];
        [self addSubview:explainLabel];
        _explainLabel = explainLabel;
    }
    return _explainLabel;
}

- (UILabel *)countdownLabel {
    if (!_countdownLabel) {
        UILabel *countdownLabel = [[UILabel alloc] init];
        countdownLabel.textAlignment = NSTextAlignmentCenter;
        countdownLabel.text = @"00:00";
        countdownLabel.textColor = UIColorOfHex(0x14826E);
        countdownLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [self.timebordIcon addSubview:countdownLabel];
        _countdownLabel = countdownLabel;
    }
    return _countdownLabel;
}

- (UILabel *)answerNumLabel {
    if (!_answerNumLabel) {
        UILabel *answerNumLabel = [[UILabel alloc] init];
        answerNumLabel.textAlignment = NSTextAlignmentCenter;
        answerNumLabel.text = @"0";
        answerNumLabel.textColor = UIColorOfHex(0x852200);
        answerNumLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(17)];
        [self addSubview:answerNumLabel];
        _answerNumLabel = answerNumLabel;
    }
    return _answerNumLabel;
}

- (YXSquareView *)squareView {
    if (!_squareView) {
        CGFloat squareHeight = AdaptSize(342) + (kIsIPhoneXSerious ? AdaptSize(20) : 0);
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, squareHeight);
        YXSquareView *squareView = [[YXSquareView alloc] initWithFrame:frame];
        squareView.delegate = self;
        squareView.backgroundColor = [UIColor clearColor];
        [self addSubview:squareView];
        _squareView = squareView;
    }
    return _squareView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        UIButton *skipButton = [[UIButton alloc] init];
        skipButton.alpha = 0;
        [skipButton setImage:[UIImage imageNamed:@"skipTisQuesImage"] forState:UIControlStateNormal];
        [skipButton addTarget:self action:@selector(skipQuestion) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:skipButton];
        _skipButton =skipButton;
    }
    return _skipButton;
}

- (void)skipQuestion {
    __weak typeof(self) weakSelf = self;
    [self.squareView doCloseAnimationWith:^{
        [weakSelf nextQuestion];
    }];
}
@end

