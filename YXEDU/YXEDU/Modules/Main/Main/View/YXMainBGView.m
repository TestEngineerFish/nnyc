
//
//  YXMainBGView.m
//  YXEDU
//
//  Created by yao on 2018/11/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXMainBGView.h"

#define kStudyDefaultWords 100
static CGFloat const KDashbordDefaultWH = 200;
#pragma mark - 首页进度条
@interface YXDashbordView : UIView
@property (nonatomic, weak)CAShapeLayer *botCircleLayer;
@property (nonatomic, weak)CAShapeLayer *progressLayer;
@property (nonatomic, weak)CAShapeLayer *dialsLayer;

@property (nonatomic, weak)CAGradientLayer *gradientLayer;
@property (nonatomic, strong)CAShapeLayer *dotLayer;
@property (nonatomic, assign)NSInteger leftWords;
@property (nonatomic, assign)NSInteger totalWords;
@property (nonatomic, assign)CGFloat percent;

@property (nonatomic, weak) CAShapeLayer *curDialsLayer;
@property (nonatomic, assign) CGRect oriBounds;

@property (nonatomic, weak)CALayer *gradientContiner;
@property (nonatomic, weak)CALayer *gradientDinalsLayer;
@end

@implementation YXDashbordView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat adaptWH = AdaptSize(KDashbordDefaultWH);
        self.oriBounds = CGRectMake(0, 0, adaptWH, adaptWH);
        
        [self setupBottomLayer];
        [self setupDialsLayer];
//        [self gradientContiner];
        [self setupProgressLayer];
        [self setupGradientLayers];
        
    }
    return self;
}
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    [self updateProgress];
}

- (void)updateProgress {
    CGFloat radius = self.progressLayer.bounds.size.width * 0.5;
    CGFloat startAngle = M_PI_2 + M_PI_4;
    CGFloat endAngle = (1.5 * M_PI * _percent) + startAngle;
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                                radius:radius
                                                            startAngle:startAngle
                                                              endAngle:endAngle
                                                             clockwise:YES];
    self.progressLayer.path = progressPath.CGPath;
    
    CGFloat angel = 2 * M_PI -endAngle;
    CGFloat dotCenterX = radius*(1 + cos(angel));
    CGFloat dotCenterY = radius*(1 - sin(angel));
    
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.bounds];
    CGFloat margin = self.bounds.size.height * 0.5 - radius;
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(dotCenterX +margin , dotCenterY + margin)
                                                           radius:3
                                                       startAngle:0
                                                         endAngle:2 * M_PI
                                                        clockwise:NO];
    [rectPath appendPath:dotPath];
    self.dotLayer.path = rectPath.CGPath;
    if (_percent) { // 没有进度
        self.layer.mask = self.dotLayer;
    }else {
        self.layer.mask = nil;
    }
//    self.dotLayer.hidden = !_percent;// 隐藏
    self.curDialsLayer.hidden = NO;
    self.curDialsLayer.transform = CATransform3DMakeRotation(M_PI_2 - angel , 0, 0, 1);
}

#pragma setup sublayer
- (void)setupGradientLayers {
    CGSize selfSize = self.oriBounds.size;
    CGFloat radius = self.progressLayer.bounds.size.width * 0.5;
    CGFloat progresslayerMaxRadius = radius + self.progressLayer.lineWidth * 0.5;
    CGFloat maxHeight = selfSize.height * 0.5 + progresslayerMaxRadius * cos(M_PI_4) + 3;
    
    self.gradientContiner.frame = CGRectMake(0, 0, selfSize.width, maxHeight);
    CAGradientLayer *leftGradiand = [CAGradientLayer layer];
    leftGradiand.colors = @[(__bridge id)UIColorOfHex(0x99f4ff).CGColor, (__bridge id)UIColorOfHex(0x3beaff).CGColor];
    leftGradiand.locations = @[@0.1,@0.85];
    leftGradiand.startPoint = CGPointMake(0, 0);
    leftGradiand.endPoint = CGPointMake(0, 1);
    leftGradiand.frame = CGRectMake(0, 0, selfSize.width * 0.5 , maxHeight);
    [self.gradientContiner addSublayer:leftGradiand];
    
    CAGradientLayer *rightGradiand = [CAGradientLayer layer];
    rightGradiand.colors = @[(__bridge id)UIColorOfHex(0x99f4ff).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    rightGradiand.locations = @[@0.05,@0.4];
    rightGradiand.startPoint = CGPointMake(0, 0);
    rightGradiand.endPoint = CGPointMake(0, 1);
    rightGradiand.frame = CGRectMake(selfSize.width * 0.5, 0, selfSize.width * 0.5 , maxHeight);
    [self.gradientContiner addSublayer:rightGradiand];
}

- (void)setupProgressLayer {
    CGFloat dialAdaptMargin = AdaptSize(6);
    CGRect progressRect = CGRectInset(self.oriBounds, dialAdaptMargin, dialAdaptMargin);
    self.progressLayer.frame = progressRect;
//    self.gradientLayer.frame = self.oriBounds;
}

- (void)setupDialsLayer {
    CALayer *gradientDinalsLayer = [CALayer layer];
    gradientDinalsLayer.mask = self.dialsLayer;
    [self.layer addSublayer:gradientDinalsLayer];
//    CGFloat dialAdaptMargin = AdaptSize(25);
//    CGFloat dinalsWidth = self.dialsLayer.lineWidth * 0.5;
//    CGFloat insertMargin = dialAdaptMargin - dinalsWidth;
    CGFloat insertMargin = AdaptSize(21);
    CGRect gradiantFrame = CGRectInset(self.oriBounds, insertMargin, insertMargin);
    gradientDinalsLayer.frame = gradiantFrame;
    CGFloat gradiantW = gradiantFrame.size.width;
    CGFloat gradiantH = gradiantFrame.size.height;
    
    CGFloat gradiantFinalH = gradiantH * 0.5 * (1 + cos(M_PI_4));
    CAGradientLayer *leftGradiand = [CAGradientLayer layer];
    leftGradiand.colors = @[(__bridge id)UIColorOfHex(0x99f4ff).CGColor, (__bridge id)UIColorOfHex(0x3beaff).CGColor];
    leftGradiand.locations = @[@0.1,@0.85];
    leftGradiand.startPoint = CGPointMake(0, 0);
    leftGradiand.endPoint = CGPointMake(0, 1);
    leftGradiand.frame = CGRectMake(0, 0, gradiantW * 0.5 , gradiantFinalH);
    [gradientDinalsLayer addSublayer:leftGradiand];
    
    CAGradientLayer *rightGradiand = [CAGradientLayer layer];
    rightGradiand.colors = @[(__bridge id)UIColorOfHex(0x99f4ff).CGColor, (__bridge id)[UIColor whiteColor].CGColor];
    rightGradiand.locations = @[@0.05,@0.4];
    rightGradiand.startPoint = CGPointMake(0, 0);
    rightGradiand.endPoint = CGPointMake(0, 1);
    rightGradiand.frame = CGRectMake(gradiantW * 0.5 , 0, gradiantW * 0.5 , gradiantFinalH);
    [gradientDinalsLayer addSublayer:rightGradiand];
    
    
//    CGFloat dialAdaptMargin = AdaptSize(25);
    CGFloat dinalCircleInsert = self.dialsLayer.lineWidth * 0.5;
    CGRect dialRect = CGRectInset(gradientDinalsLayer.bounds,dinalCircleInsert,dinalCircleInsert );//dialAdaptMargin, dialAdaptMargin
    self.dialsLayer.frame = dialRect;
    
    CGFloat radius = self.dialsLayer.bounds.size.width * 0.5;
    CGFloat perimeter = 2 * M_PI *radius * 0.75 - 1;
    UIBezierPath *dialPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                            radius:radius
                                                        startAngle:M_PI_4
                                                          endAngle:(M_PI_2 + M_PI_4)
                                                         clockwise:NO];
    NSInteger dialsCount = 50;
    CGFloat lineDash = (perimeter - (dialsCount + 1) * 1.0) / dialsCount;
    self.dialsLayer.lineDashPattern = @[@1.0,@(lineDash)];
    [dialPath stroke];
    self.dialsLayer.path = dialPath.CGPath;
    
    
    self.curDialsLayer.bounds = self.dialsLayer.bounds;
    CGSize curDialsLayerSize = self.curDialsLayer.bounds.size;
    UIBezierPath *curDinal = [UIBezierPath bezierPath];
    CGFloat pathX = curDialsLayerSize.width * 0.5;
    CGFloat pathY = self.dialsLayer.lineWidth * 0.5;
    CGFloat pathEndY = self.dialsLayer.lineWidth;
    [curDinal moveToPoint:CGPointMake(pathX, -pathY)];
    [curDinal addLineToPoint:CGPointMake(pathX, pathEndY)];
    self.curDialsLayer.path = curDinal.CGPath;
    
    //注意这里要修改transform,就不能通过frame来定位layer的位置，要通过以下方式
    CGSize size = self.oriBounds.size;
    self.curDialsLayer.anchorPoint = CGPointMake(0.5, 0.5);
//    self.curDialsLayer.backgroundColor = [UIColor greenColor].CGColor;
    self.curDialsLayer.position = CGPointMake(size.width * 0.5, size.height*0.5);
    self.curDialsLayer.transform = CATransform3DMakeRotation(-0.75 *M_PI, 0, 0, 1);
}

- (void)setupBottomLayer {
    CGFloat botAdaptMargin = AdaptSize(6);
    CGRect bottomRect = CGRectInset(self.oriBounds, botAdaptMargin, botAdaptMargin);
    self.botCircleLayer.frame = bottomRect;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.botCircleLayer.bounds];
    self.botCircleLayer.path = circlePath.CGPath;
}
#pragma layer - sublayer
- (CAShapeLayer *)dotLayer {
    if (!_dotLayer) {
        CAShapeLayer *dotLayer = [CAShapeLayer layer];
        self.layer.mask = dotLayer;
        _dotLayer = dotLayer;
    }
    return _dotLayer;
}

- (CAShapeLayer *)botCircleLayer {
    if (!_botCircleLayer) {
        CAShapeLayer *botCircleLayer = [CAShapeLayer layer];
        botCircleLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.23].CGColor;
        botCircleLayer.fillColor = [UIColor clearColor].CGColor;
        botCircleLayer.lineWidth = AdaptSize(5.0);
        [self.layer addSublayer:botCircleLayer];
        _botCircleLayer = botCircleLayer;
    }
    return _botCircleLayer;
}

- (CAShapeLayer *)dialsLayer {
    if (!_dialsLayer) {
        CAShapeLayer *dialsLayer = [CAShapeLayer layer];
        dialsLayer.strokeColor = [UIColor whiteColor].CGColor;
        dialsLayer.fillColor = [UIColor clearColor].CGColor;
        dialsLayer.lineWidth = AdaptSize(8.0);
        [self.layer addSublayer:dialsLayer];
        _dialsLayer = dialsLayer;
    }
    return _dialsLayer;
}

- (CAShapeLayer *)curDialsLayer {
    if (!_curDialsLayer) {
        CAShapeLayer *curDialsLayer = [CAShapeLayer layer];
        curDialsLayer.backgroundColor = [UIColor clearColor].CGColor;
        curDialsLayer.strokeColor = [UIColor whiteColor].CGColor;
        curDialsLayer.hidden = YES;
        curDialsLayer.lineWidth = 1.5;
        [self.layer addSublayer:curDialsLayer];
        _curDialsLayer = curDialsLayer;
    }
    return _curDialsLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
//        progressLayer.backgroundColor = [UIColor orangeColor].CGColor;
        progressLayer.strokeColor = [UIColor whiteColor].CGColor;
        progressLayer.fillColor = [UIColor clearColor].CGColor;
        progressLayer.lineWidth = AdaptSize(10.0);
        progressLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:progressLayer];
        _progressLayer = progressLayer;
    }
    return _progressLayer;
}

- (CALayer *)gradientContiner {
    if (!_gradientContiner) {
        CALayer *gradientContiner = [CALayer layer];
        gradientContiner.mask = self.progressLayer;
        [self.layer addSublayer:gradientContiner];
        _gradientContiner = gradientContiner;
    }
    return _gradientContiner;
}


- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor whiteColor].CGColor];
        gradientLayer.locations = @[@0.0,@0.8];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        //        gradientLayer.mask = self.progressLayer;
        [self.layer addSublayer:gradientLayer];
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}
/* 修改layer的属性会引起调用layoutsubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self setupBottomLayer];
    [self setupDialsLayer];
    [self setupProgressLayer];
}
*/
@end











static NSString *const kBottomRoteAnimator = @"BottomRoteAnimate";
static NSString *const kTopRoteAnimator = @"TopRoteAnimator";
@interface YXMainBGView ()
@property (nonatomic, weak)UIImageView *leftPerson;
@property (nonatomic, weak)UIImageView *rightPerson;
@property (nonatomic, weak)UIView *btnsView;
@property (nonatomic, weak)UIView *flowView;

@property (nonatomic, strong)UIImageView *botImageView;
@property (nonatomic, strong)UIImageView *topImageView;
@property (nonatomic, weak) UILabel *studyTipsLabel;
@property (nonatomic, weak) UILabel *wordNumLabel;
@property (nonatomic, weak) UILabel *studyProgressLabel;
@property (nonatomic, weak) UIView *progressView;
@property (nonatomic, weak) YXDashbordView *dashbordView;
@end

@implementation YXMainBGView
{
    UIButton *_beginReciteBtn;
}

- (void)noNetworkState {
    self.wordNumLabel.text = @"--";
    if ([self.mainModel.noteIndex.reviewPlan integerValue]) {
        self.studyProgressLabel.text = @"待复习--";
    }else {
        self.studyProgressLabel.text = @"--/--";
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"main_bg"];
        self.userInteractionEnabled = YES;
        
        UIImage *arcCoverImage = [UIImage imageNamed:@"arcCoverImage"];
        UIImageView *arcCover = [[UIImageView alloc] initWithImage:arcCoverImage];
        [self addSubview:arcCover];

        [arcCover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self);//.offset(1);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, AdaptSize(arcCoverImage.size.height)));
        }];
        
        UIImageView *leftPerson = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPerson"]];
        [self addSubview:leftPerson];
        _leftPerson = leftPerson;

        UIImageView *rightPerson = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightPerson"]];
        [self addSubview:rightPerson];
        _rightPerson = rightPerson;
        
        CGFloat btnsViewW = SCREEN_WIDTH - AdaptSize(26) * 2;
        [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(btnsViewW , AdaptSize(66)));
            make.bottom.equalTo(self).offset(AdaptSize(-57));
        }];
        
        CGFloat receiteBtnW = AdaptSize(239);
        [self.beginReciteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(AdaptSize(-45));
            make.size.mas_equalTo(CGSizeMake(receiteBtnW, AdaptSize(80)));
        }];
        
        CGFloat margin = (SCREEN_WIDTH - receiteBtnW) * 0.5; // 默认没有复习单词
        [self.leftPerson mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(arcCover.mas_top).offset(-7);
            make.centerX.equalTo(self.mas_left).offset(margin);
        }];
        
        [self.rightPerson mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_right).offset(-margin);
            make.bottom.mas_equalTo(arcCover.mas_top).offset(-16);
        }];
        
        self.botImageView = [[UIImageView alloc] init];
        self.botImageView.image = [UIImage imageNamed:@"flowBotImage"];
        [self addSubview:self.botImageView];
        CGFloat flowWH = AdaptSize(230);
        [self.botImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(flowWH, flowWH));
            make.top.equalTo(self).offset(AdaptSize(77));
        }];
        
        self.topImageView = [[UIImageView alloc] init];
        self.topImageView.image = [UIImage imageNamed:@"flowTopImage"];
        [self addSubview:self.topImageView];
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.botImageView);
            make.size.equalTo(self.botImageView);
        }];
        
        CGFloat progressWH = AdaptSize(KDashbordDefaultWH);
        [self.dashbordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.botImageView);
            make.size.mas_equalTo(CGSizeMake(progressWH, progressWH));
            
        }];
        
        [self.wordNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.botImageView).offset(AdaptSize(70));
        }];
        
        [self.studyTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.wordNumLabel);
            make.top.equalTo(self.wordNumLabel.mas_bottom);//.offset(AdaptSize(11));
        }];
        
        [self.studyProgressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.wordNumLabel);
            make.top.equalTo(self.studyTipsLabel.mas_bottom).offset(AdaptSize(20));
        }];
        [self animateSwitch:YES];
    }
    return self;
}

- (UILabel *)wordNumLabel {
    if (!_wordNumLabel) {
        UILabel *wordNumLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0,45 , SCREEN_WIDTH, 17)
        wordNumLabel.textAlignment = NSTextAlignmentCenter;
        wordNumLabel.textColor = UIColorOfHex(0xffffff);
        wordNumLabel.text = @"--";
        wordNumLabel.font = [UIFont boldSystemFontOfSize:AdaptSize(55)];
        [self addSubview:wordNumLabel];
        _wordNumLabel = wordNumLabel;
    }
    return _wordNumLabel;
}

- (UILabel *)studyTipsLabel {
    if (!_studyTipsLabel) {
        UILabel *studyTipsLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0,45 , SCREEN_WIDTH, 17)
        studyTipsLabel.textAlignment = NSTextAlignmentCenter;
        studyTipsLabel.textColor = UIColorOfHex(0xffffff);
        studyTipsLabel.text = @"今日待学习";
        studyTipsLabel.font = [UIFont systemFontOfSize:AdaptSize(16)];
        [self addSubview:studyTipsLabel];
        _studyTipsLabel = studyTipsLabel;
    }
    return _studyTipsLabel;
}

- (UILabel *)studyProgressLabel {
    if (!_studyProgressLabel) {
        UILabel *studyProgressLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(0,45 , SCREEN_WIDTH, 17)
        studyProgressLabel.textAlignment = NSTextAlignmentCenter;
        studyProgressLabel.textColor = UIColorOfHex(0xBBE6FC);
        studyProgressLabel.text = @"--/--";
        studyProgressLabel.font = [UIFont boldSystemFontOfSize:11];
        [self addSubview:studyProgressLabel];
        _studyProgressLabel = studyProgressLabel;
    }
    return _studyProgressLabel;
}

- (UIView *)btnsView {
    if (!_btnsView) {
        UIView *btnsView = [[UIView alloc] init];
        btnsView.hidden = YES;
        [self addSubview:btnsView];
        _btnsView = btnsView;
        
        CGFloat fontSize = AdaptSize(19);
        UIButton *leftBtn = [[YXNoHightButton alloc] init];
        leftBtn.titleEdgeInsets = UIEdgeInsetsMake(AdaptSize(-6), 0, 0, 0);
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
        [leftBtn setTitle:@"打卡" forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"thinBtnImage"] forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorOfHex(0x60B8F8) forState:UIControlStateNormal];
        [btnsView addSubview:leftBtn];
        _shareBtn = leftBtn;
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnsView);
            make.centerY.equalTo(btnsView);
            make.width.mas_equalTo(AdaptSize(161));
            make.height.mas_equalTo(AdaptSize(61));
        }];
        
        UIButton *rightBtn = [[YXNoHightButton alloc] init];
        rightBtn.titleLabel.font = leftBtn.titleLabel.font;
        rightBtn.titleEdgeInsets = leftBtn.titleEdgeInsets;
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"clearBorderImage"] forState:UIControlStateNormal];
        [rightBtn setTitle:@"再来一组" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnsView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnsView);
            make.size.centerY.equalTo(leftBtn);
        }];
        _rightBtn = rightBtn;
        
    }
    return _btnsView;
}

- (UIButton *)beginReciteBtn {
    if (!_beginReciteBtn) {
        UIButton *beginReciteBtn = [YXNoHightButton buttonWithType:UIButtonTypeCustom];
        beginReciteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:AdaptSize(21)];
        [beginReciteBtn setBackgroundImage:[UIImage imageNamed:@"start_recite_word"] forState:UIControlStateNormal];
        [beginReciteBtn setTitleColor:UIColorOfHex(0x60B8F8) forState:UIControlStateNormal];
        [beginReciteBtn setTitle:@"开始背单词" forState:UIControlStateNormal];
        beginReciteBtn.titleEdgeInsets = UIEdgeInsetsMake(AdaptSize(-15), 0, 0, 0);
        [self addSubview:beginReciteBtn];
        _beginReciteBtn = beginReciteBtn;
    }
    return _beginReciteBtn;
}

- (void)resetPersons:(BOOL)hasPlanRemains {
    CGFloat width = hasPlanRemains ? self.beginReciteBtn.width : self.btnsView.width;
    CGFloat margin = (SCREEN_WIDTH - width) * 0.5;
    [self.leftPerson mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(margin);
    }];
    
    [self.rightPerson mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(-margin);
    }];
}

- (void)setMainModel:(YXMainModel *)mainModel {
    _mainModel = mainModel;
    self.wordNumLabel.text = mainModel.noteIndex.planRemain;
    NSInteger totalWords = [mainModel.noteIndex.wordCount integerValue];
    NSInteger leftWords = [mainModel.noteIndex.learned integerValue];
    self.dashbordView.percent = 1.0 * leftWords / totalWords;
    
    if ([mainModel.noteIndex.reviewPlan integerValue]) {
        self.studyProgressLabel.text = [NSString stringWithFormat:@"待复习%@", mainModel.noteIndex.reviewPlan];
    }else {
        self.studyProgressLabel.text = [NSString stringWithFormat:@"%@/%@", mainModel.noteIndex.learned, mainModel.noteIndex.wordCount];
    }
    
    BOOL hasPlanRemains = [mainModel.noteIndex.planRemain integerValue];
    BOOL hasReviewPlans = [mainModel.noteIndex.reviewPlan integerValue];
    
    [self resetPersons:(hasPlanRemains||hasReviewPlans)];
    if (hasPlanRemains||hasReviewPlans) { // 今日还有要学习单词
        self.beginReciteBtn.hidden = NO;
        self.btnsView.hidden = YES;
        if(hasReviewPlans){
            [self.beginReciteBtn setTitle:@"开始复习" forState:UIControlStateNormal];
        }
        else{
            [self.beginReciteBtn setTitle:@"开始背单词" forState:UIControlStateNormal];
        }
    }else {
        self.btnsView.hidden = NO;
        self.beginReciteBtn.hidden = YES;
        [self.rightBtn setTitle:(mainModel.bookFinished ? @"换本书背" : @"再来一组") forState:UIControlStateNormal];
    }
}

- (void)animateSwitch:(BOOL)isOn {
    if (isOn) {
        CAKeyframeAnimation *transformAnima =  [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
        transformAnima.values = @[@0,@(M_PI),@(2 * M_PI)];
        transformAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        transformAnima.repeatCount = HUGE_VALF;
        transformAnima.duration = 25;
//        transformAnima.autoreverses = YES;
//        transformAnima.beginTime = CACurrentMediaTime();
        transformAnima.removedOnCompletion = NO;
        transformAnima.fillMode = kCAFillModeForwards;
        [self.botImageView.layer addAnimation:transformAnima forKey:kBottomRoteAnimator];

        transformAnima.values = @[@(2 * M_PI),@(M_PI),@0];
//        transformAnima.duration = 30;
        transformAnima.beginTime = CACurrentMediaTime() + 0.5;
        [self.topImageView.layer addAnimation:transformAnima forKey:kTopRoteAnimator];
    }else {
        [self.botImageView.layer removeAnimationForKey:kBottomRoteAnimator];
        [self.topImageView.layer removeAnimationForKey:kTopRoteAnimator];
    }
}

- (YXDashbordView *)dashbordView {
    if (!_dashbordView) {
        YXDashbordView *dashbordView = [[YXDashbordView alloc] init];
        [self addSubview:dashbordView];
        _dashbordView = dashbordView;
    }
    return _dashbordView;
}

- (UIView *)progressView {
    if (!_progressView) {
        UIView *progressView = [[UIView alloc] init];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.layer.borderWidth = 5;
        progressView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.23].CGColor;
        [self addSubview:progressView];
        _progressView = progressView;
    }
    return _progressView;
}
@end



