//
//  YXSquareView.m
//  YXEDU
//
//  Created by yao on 2019/1/2.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXSquareView.h"
#import "YXLotusView.h"
#import "AVAudioPlayerManger.h"
static NSString *const kWaveAnimateKey = @"WaveAnimateKey";
static NSString *const kCorrectScaleAnimateKey = @"CorrectScaleAnimateKey";
@interface YXSquareView ()
@property (nonatomic, weak) UIImageView *waveIcon;
@property (nonatomic, strong) NSArray *lotusViews;
@property (nonatomic, assign) CGPoint centerLoc;
@property (nonatomic, weak) UIImageView *frogIcon;
@property (nonatomic, weak) UIImageView *spellWordBgIcon;
@property (nonatomic, weak) UILabel *spellWordLabel;
// 当前点
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) NSMutableArray *selLotusViews;
/** 正确答案对应的荷叶数组 */
@property (nonatomic, strong) NSMutableArray *correctLotusViews;
// 数组清空标志
@property (nonatomic, assign) BOOL hasClean;

@end

@implementation YXSquareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.centerLoc = CGPointMake(frame.size.width * 0.5, kLotusTopMargin + 1.5 * kNormalLotusSize.height + kLotusVerMargin);
        for (NSInteger i = 0; i < 9; i++) {
            YXLotusView *lotusV = [[YXLotusView alloc] init];
            lotusV.frame = CGRectMake(0, 0, kNormalLotusSize.width, kNormalLotusSize.height);
            lotusV.center = self.centerLoc;
            [self addSubview:lotusV];
        }
        _lotusViews = [self.subviews copy];

        [self waveIcon];
        [self frogIcon];
        CGFloat spellWordBgIconY = kIsIPhoneXSerious ? AdaptSize(15) : AdaptSize(12);
        self.spellWordBgIcon.frame = CGRectMake(self.frogIcon.right, -spellWordBgIconY, AdaptSize(208), AdaptSize(39));
    }
    return self;
}

- (NSMutableArray *)selLotusViews {
    if (!_selLotusViews) {
        _selLotusViews = [NSMutableArray array];
    }
    return _selLotusViews;
}


- (NSMutableArray *)correctLotusViews {
    if (!_correctLotusViews) {
        _correctLotusViews = [NSMutableArray array];
    }
    return _correctLotusViews;
}
#pragma mark -
- (void)setGameQuesModel:(YXGameContent *)gameQuesModel {
    _gameQuesModel = gameQuesModel;
    
    [self handleData];
}

- (void)handleData {
    [self cancleFlashCorrectLotusViews];
    [self.correctLotusViews removeAllObjects]; // 清空
    NSInteger count = self.gameQuesModel.error.length > self.lotusViews.count ? self.lotusViews.count : self.gameQuesModel.error.length;
    for (NSInteger i = 0; i < count; i ++) {
        YXLotusView *lotusView = [self.lotusViews objectAtIndex:i];
        NSString *character = [self.gameQuesModel.errorCharacters objectAtIndex:i];
        lotusView.character = character;
    }
    
    [self doOpenAnimation];
    
    // 遍历正确的荷叶
    count = self.gameQuesModel.word.length > self.lotusViews.count ? self.lotusViews.count : self.gameQuesModel.word.length;
    NSMutableArray *tempLotusViews = [self.lotusViews mutableCopy];
    
    for (NSInteger i = 0; i < count; i ++) {
        NSString *correctCharacter = [self.gameQuesModel.word substringWithRange:NSMakeRange(i, 1)];
        YXLotusView *tempLotus = nil;
        for (YXLotusView *lotusView in tempLotusViews) {
            if ([lotusView.character isEqualToString:correctCharacter]) {
                tempLotus = lotusView;
                break;
            }
        }
        
        if (tempLotus) {
            [self.correctLotusViews addObject:tempLotus];
            [tempLotusViews removeObject:tempLotus];
        }
    }
    [self flashCorrectLotusViews];
}

- (void)flashCorrectLotusViews {
    [self cancleFlashCorrectLotusViews];
    [self performSelector:@selector(correctLotusViewsAnimation) withObject:nil afterDelay:4.f];
}

- (void)cancleFlashCorrectLotusViews {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(correctLotusViewsAnimation) object:nil];
    [self.correctLotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger idx, BOOL * _Nonnull stop) {
        [lotusView.layer removeAnimationForKey:kCorrectScaleAnimateKey]; // 移除已注册动画
    }];
}
#pragma mark - 绘图
- (void)drawRect:(CGRect)rect {
    if (self.selLotusViews.count == 0) {
        return;
    }
    
    YXLotusState state = [self getLotusViewState];
    UIColor *bgColor = nil;
    UIColor *hiLightColor = nil;
    if (state == YXLotusStateSelect) {
        bgColor = [UIColorOfHex(0xFADA68) colorWithAlphaComponent:0.5];
        hiLightColor = [UIColorOfHex(0xF2BF5D) colorWithAlphaComponent:0.88];
    }else {
        bgColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
        if (state == YXLotusStateCorrect) {
            hiLightColor = [UIColorOfHex(0x5FE6A2) colorWithAlphaComponent:0.88];
        }else {
            hiLightColor = [UIColorOfHex(0xFF98A2) colorWithAlphaComponent:0.88];
        }
    
    }
    [self connectLotusBGLineInRect:rect lineColor:bgColor];
    [self connectLotusInRect:rect lineColor:hiLightColor];
}

- (void)connectLotusBGLineInRect:(CGRect)rect lineColor:(UIColor *)color {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 遍历数组中的circle
    for (int index = 0; index < self.selLotusViews.count; index++) {
        // 取出选中按钮
        YXLotusView *lotusView = self.selLotusViews[index];
        if (index == 0) { // 起点按钮
            CGContextMoveToPoint(ctx, lotusView.center.x, lotusView.center.y);
        }else{
            CGContextAddLineToPoint(ctx, lotusView.center.x, lotusView.center.y); // 全部是连线
        }
    }
    
    // 连接最后一个按钮到手指当前触摸得点
    if (CGPointEqualToPoint(self.currentPoint, CGPointZero) == NO) {
        [self.lotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger idx, BOOL *stop) {
            if ([self getLotusViewState] != YXLotusStateSelect) {
                // 如果是错误的状态下不连接到当前点
            } else {
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
            }
        }];
    }
    
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    // 设置绘图的属性
    CGContextSetLineWidth(ctx, AdaptSize(22));
    // 线条颜色
    [color set];
    //渲染路径
    CGContextStrokePath(ctx);
}


- (void)connectLotusInRect:(CGRect)rect lineColor:(UIColor *)color{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 遍历数组中的circle
    for (int index = 0; index < self.selLotusViews.count; index++) {
        // 取出选中按钮
        YXLotusView *lotusView = self.selLotusViews[index];
        if (index == 0) { // 起点按钮
            CGContextMoveToPoint(ctx, lotusView.center.x, lotusView.center.y);
        }else{
            CGContextAddLineToPoint(ctx, lotusView.center.x, lotusView.center.y); // 全部是连线
        }
    }
    
    // 连接最后一个按钮到手指当前触摸得点
    if (CGPointEqualToPoint(self.currentPoint, CGPointZero) == NO) {
        [self.lotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger idx, BOOL *stop) {
            if ([self getLotusViewState] != YXLotusStateSelect) {//
                // 如果是错误的状态下不连接到当前点
            } else {
                CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
            }
        }];
    }
    //线条转角样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    // 设置绘图的属性
    CGContextSetLineWidth(ctx, AdaptSize(5));
    // 线条颜色
    [color set];
    //渲染路径
    CGContextStrokePath(ctx);
}


- (void)clipSubviewsWhenConnectInContext:(CGContextRef)ctx clip:(BOOL)clip
{
    //    return;
    if (clip) {
        
        // 遍历所有子控件
        [self.subviews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger idx, BOOL *stop) {
            CGContextAddEllipseInRect(ctx, lotusView.frame); // 确定"剪裁"的形状
        }];
    }
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetLotusViews];
    
    [self cancleFlashCorrectLotusViews];
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.lotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger index, BOOL * _Nonnull stop) {
        CGRect labelRect = [lotusView convertRect:lotusView.characterLabel.frame toView:self];
        if (CGRectContainsPoint(labelRect, point)) {
            lotusView.state = YXLotusStateSelect;
            [self.selLotusViews addObject:lotusView];
            [self waveAnimateToPoint:lotusView.center];
            
            NSString *answer = [self selectedLotusWord];
            self.spellWordBgIcon.hidden = NO;
            self.spellWordLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(19)];
            self.spellWordLabel.textColor = UIColorOfHex(0xA05924);
            self.spellWordLabel.text = answer;
            
            *stop = YES;
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentPoint = CGPointZero;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self.lotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger index, BOOL * _Nonnull stop) {
        CGRect labelRect = [lotusView convertRect:lotusView.characterLabel.frame toView:self];
        if (CGRectContainsPoint(labelRect, point)) {
            if ([self.selLotusViews containsObject:lotusView]) {
                
            }else {
                [self.selLotusViews addObject:lotusView];
                [self waveAnimateToPoint:lotusView.center];
            }
        }else {
            self.currentPoint = point;
        }
    }];
    
    [self.selLotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger index, BOOL * _Nonnull stop) {
        lotusView.state = YXLotusStateSelect;
    }];
    
    NSString *answer = [self selectedLotusWord];
    self.spellWordLabel.text = answer;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.hasClean = NO;
    NSString *answer = [self selectedLotusWord];
    if (answer.length == 0) {
        return;
    }
    
    self.gameQuesModel.answerRecord.answer = answer;
    BOOL isRight = NO;
    if ([self.gameQuesModel.word isEqualToString:answer]) {
        [self changeLotusViewState:YXLotusStateCorrect];
        [self cancleFlashCorrectLotusViews];
        [self playRightSound];
        isRight = YES;
    }else {
        [self changeLotusViewState:YXLotusStateError];
        [self flashCorrectLotusViews];
        [self playWrongSound];
    }
    
    self.userInteractionEnabled = NO;
    if (isRight) {
        [self spellRightLabelAnimateWith:answer];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self resetLotusViews];
        self.spellWordBgIcon.hidden = YES;
        self.userInteractionEnabled = YES;
        if (isRight) {
            [self doCloseAnimationWith:^{
                if ([self.delegate respondsToSelector:@selector(squareViewEnterNextQuestion:)]) {
                    [self.delegate squareViewEnterNextQuestion:self];
                }
            }]; 
        }
    });
}

- (NSString *)selectedLotusWord {
    NSMutableString *word = [NSMutableString string];
    for (YXLotusView *lotusView in self.selLotusViews) {
        if (lotusView.character) {
            [word appendString:lotusView.character];
        }
    }
    return [word copy];
}

- (YXLotusState)getLotusViewState {
    YXLotusView *lotusView = self.selLotusViews.firstObject;
    return lotusView.state;
}
#pragma mark - 手势结束时的清空操作
- (void)resetLotusViews {
    @synchronized(self) { // 保证线程安全
        if (!self.hasClean) {
            // 手势完毕，选中的圆回归普通状态
            [self changeLotusViewState:YXLotusStateNormal];
            // 清空数组
            [self.selLotusViews removeAllObjects];
            // 完成之后改变clean的状态
            [self setHasClean:YES];
            self.waveIcon.hidden = YES;
        }
    }
}

#pragma mark - 改变选中数组CircleSet子控件状态
- (void)changeLotusViewState:(YXLotusState)state {
    for (YXLotusView *lotusView in self.selLotusViews) {
        lotusView.state = state;
    }
    [self setNeedsDisplay];
}

#pragma mark - playsound
- (void)playRightSound {
    NSURL *path = [[NSBundle mainBundle]URLForResource:@"right" withExtension:@"mp3"];
    [[AVAudioPlayerManger shared] startPlay:path finish:nil];
}

- (void)playWrongSound {
    NSURL *path = [[NSBundle mainBundle]URLForResource:@"wrong" withExtension:@"mp3"];
    [[AVAudioPlayerManger shared] startPlay:path finish:nil];
}
#pragma mark - animation
- (void)doOpenAnimation {
    NSInteger col = 3;
    CGFloat horMargin = (self.frame.size.width - col * kNormalLotusSize.width - 2 * kLotusInsertMargin) / (col - 1);
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self.lotusViews enumerateObjectsUsingBlock:^(UIView *lotusView, NSUInteger index, BOOL * _Nonnull stop) {
            NSUInteger row = index % 3;
            NSUInteger col = index / 3;
            CGFloat x = kLotusInsertMargin + (horMargin + kNormalLotusSize.width) * col;
            CGFloat y = kLotusTopMargin + (kLotusVerMargin + kNormalLotusSize.height) * row;
            CGRect frame = CGRectMake(x, y, kNormalLotusSize.width, kNormalLotusSize.height);
            lotusView.frame = frame;
        }];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)doCloseAnimationWith:(void(^)(void))completion {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self.lotusViews enumerateObjectsUsingBlock:^(YXLotusView *lotusView, NSUInteger index, BOOL * _Nonnull stop) {
            lotusView.center = self.centerLoc;
            lotusView.characterLabel.text = @"";
            lotusView.state = YXLotusStateNormal;
        }];
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (completion) {
            completion();
        }
    }];
}

- (void)doCloseAnimation {
    [self doCloseAnimationWith:nil];
}

- (void)waveAnimateToPoint:(CGPoint)point {
    [self.waveIcon.layer removeAnimationForKey:kWaveAnimateKey];
    self.waveIcon.hidden = NO;
    self.waveIcon.center = CGPointMake(point.x , point.y + AdaptSize(8));
    
    // 弹框动画有必要时添加
    CAKeyframeAnimation *animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animater.values = @[@0.8,@1.2,@0.9,@1.1,@1];
    animater.duration = 1.2;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.waveIcon.layer addAnimation:animater forKey:kWaveAnimateKey];
}

- (void)correctLotusViewsAnimation {
    // 弹框动画有必要时添加
    CAKeyframeAnimation*animater = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animater.values = @[@1,@1.2,@1];
    animater.duration = 0.5;
    animater.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    for (YXLotusView *lotusView in self.correctLotusViews) {
        [lotusView.layer addAnimation:animater forKey:kCorrectScaleAnimateKey];
    }
    
    [self performSelector:@selector(correctLotusViewsAnimation) withObject:nil afterDelay:10.f];
}

- (void)spellRightLabelAnimateWith:(NSString *)answer{
    self.spellWordLabel.font = [UIFont systemFontOfSize:AdaptSize(22)];
    self.spellWordLabel.textColor = [UIColor redColor];
    self.spellWordLabel.text = @"GOOD!";
    self.spellWordLabel.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.spellWordLabel.transform = CGAffineTransformIdentity;
                     } completion:nil];

}

#pragma mark - subviews
- (UIImageView *)waveIcon {
    if (!_waveIcon) {
        UIImageView *waveIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lotusWave"]];
        waveIcon.frame = CGRectMake(0, 0, AdaptSize(136), AdaptSize(180));
        waveIcon.userInteractionEnabled = YES;
        waveIcon.hidden = YES;
        [self insertSubview:waveIcon atIndex:0];
        _waveIcon = waveIcon;
    }
    return _waveIcon;
}

- (UIImageView *)frogIcon {
    if (!_frogIcon) {
        UIImageView *frogIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frogIcon"]];
        frogIcon.userInteractionEnabled = YES;
        frogIcon.frame = CGRectMake(kLotusInsertMargin, AdaptSize(9), AdaptSize(56), AdaptSize(53));
        [self addSubview:frogIcon];
        _frogIcon = frogIcon;
    }
    return _frogIcon;
}

- (UIImageView *)spellWordBgIcon {
    if (!_spellWordBgIcon) {
        UIImageView *spellWordBgIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spellBGIamge"]];
        spellWordBgIcon.hidden = YES;
        [self addSubview:spellWordBgIcon];
        _spellWordBgIcon = spellWordBgIcon;
        
        UILabel *spellWordLabel = [[UILabel alloc] init];
        spellWordLabel.textAlignment = NSTextAlignmentCenter;
        spellWordLabel.font = [UIFont pfSCMediumFontWithSize:AdaptSize(19)];
        spellWordLabel.textColor = UIColorOfHex(0xA05924);
        [spellWordBgIcon addSubview:spellWordLabel];
        _spellWordLabel = spellWordLabel;
        
        [spellWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(spellWordBgIcon);
            make.left.equalTo(spellWordBgIcon).offset(AdaptSize(20));
            make.right.equalTo(spellWordBgIcon).offset(AdaptSize(-8));
        }];
    }
    return _spellWordBgIcon;
}
@end
