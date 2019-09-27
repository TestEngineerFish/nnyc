//
//  YXCycleView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/18.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCycleView.h"

@interface YXCycleView()

@property(assign,nonatomic)CGFloat startValue;
@property(assign,nonatomic)CGFloat lineWidth;
@property(assign,nonatomic)CGFloat value;
@property(strong,nonatomic)UIColor *lineColor;
@property(strong,nonatomic)UIColor *bgColor;

@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *bgLayer;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)FinishBlock finishBlock;

@end

@implementation YXCycleView

+ (YXCycleView *)showCycleViewWith:(CGRect)frame {
    YXCycleView *cycleView = [[YXCycleView alloc] initWithFrame:frame];
    [cycleView setLineWidth:10.f];
    [cycleView setLineColor:UIColorOfHex(0x0EADFD)];
    [cycleView setBgColor:UIColorOfHex(0xCED3E1)];
    return cycleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];

        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = 2.f;
        _bgLayer.strokeColor = [UIColor clearColor].CGColor;
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = 1.f;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];

        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 2.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeStart = 0.f;
        _shapeLayer.strokeEnd = 0.f;

        _shapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_shapeLayer];
        CGAffineTransform transform = CGAffineTransformIdentity;
        self.transform = CGAffineTransformRotate(transform, -M_PI / 2);
    }
    return self;
}

- (void)startProgressAnimate:(CGFloat)second finishBlock:(FinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:second/100.f target:self selector:@selector(progressAnimtion) userInfo:nil repeats:YES];
}

- (void)progressAnimtion {
    if (self.shapeLayer.strokeEnd >= 1) {
        if (self.finishBlock) {
            self.finishBlock();
        }
        return;
    }
    self.shapeLayer.strokeEnd += 0.01f;
}

- (void)dealloc
{
    [self.timer invalidate];
}

@synthesize value = _value;
-(void)setValue:(CGFloat)value{
    _value = value;
    _shapeLayer.strokeEnd = value;
}
-(CGFloat)value{
    return _value;
}

@synthesize lineColor = _lineColor;
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    _shapeLayer.strokeColor = lineColor.CGColor;
}
-(UIColor*)lineColor{
    return _lineColor;
}

@synthesize bgColor = _bgColor;
- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    _bgLayer.strokeColor = bgColor.CGColor;
}

- (UIColor *)bgColor{
    return _bgColor;
}


@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}


@end
