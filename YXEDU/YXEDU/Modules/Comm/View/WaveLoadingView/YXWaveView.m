//
//  YXWaveView.m
//  waveLoading
//
//  Created by yao on 2018/10/18.
//  Copyright © 2018年 yao. All rights reserved.
//

#import "YXWaveView.h"
@interface YXWaveView ()
@property (nonatomic,strong)CADisplayLink *wavesDisplayLink;

@property (nonatomic,strong)CAShapeLayer *firstWavesLayer;

@property (nonatomic,strong)UIColor *firstWavesColor;

@property (nonatomic,strong)CAShapeLayer *secondWavesLayer;

@property (nonatomic,strong)UIColor *secondWavesColor;
@end

@implementation YXWaveView
{
    CGFloat waveA;//水纹振幅
    CGFloat waveW ;//水纹周期
    CGFloat offsetX; //位移
    CGFloat currentK; //当前波浪高度Y
    CGFloat wavesSpeed;//水纹速度
    CGFloat WavesWidth; //水纹宽度
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
         [self setUpWaves];
    }
    return self;
}

- (void)setUpWaves{
//    //设置波浪的宽度
    WavesWidth = self.frame.size.width;
    //第一个波浪颜色
    UIColor *color = [UIColor colorWithRed:110/255.0f green:195/255.0f blue:254/255.0f alpha:0.64];
//    self.secondWavesColor = [UIColor colorWithRed:86/255.0f green:180/255.0f blue:139/255.0f alpha:1];
    //设置波浪的速度
    wavesSpeed = 1/M_PI;

    //初始化layer
    //初始化
    self.firstWavesLayer = [CAShapeLayer layer];
    self.secondWavesLayer = [CAShapeLayer layer];
    //设置闭环的颜色
    self.firstWavesLayer.fillColor = color.CGColor;
    self.secondWavesLayer.fillColor = color.CGColor;
    [self.layer addSublayer:self.firstWavesLayer];
    [self.layer addSublayer:self.secondWavesLayer];
    
    //同正弦函数不同,会有交错效果
    //设置波浪流动速度
    wavesSpeed = 0.04;
    //设置振幅
    waveA = 8;
    //设置周期
    waveW = 1/30.0;
    //设置波浪纵向位置
    currentK = self.frame.size.height/2 + 10;//屏幕居中
    [self wavesDisplayLink];
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    //实时的位移
    //实时的位移
    offsetX += wavesSpeed;
    
    [self setCurrentFirstWaveLayerPath];
}

-(void)setCurrentFirstWaveLayerPath{
    
    //创建一个路径
    CGMutablePathRef firstPath = CGPathCreateMutable();
    CGMutablePathRef secondPath = CGPathCreateMutable();
    CGFloat firstY = currentK;
    CGFloat secondY = currentK;
    //将点移动到 x=0,y=currentK的位置
    CGPathMoveToPoint(firstPath, nil, 0, firstY);
    CGPathMoveToPoint(secondPath, nil, 0, secondY);
    
    for (NSInteger i = 0.0f; i <= WavesWidth; i++) {
        firstY = waveA * sin(waveW * i+ offsetX)+currentK;
        //余弦函数波浪公式
        secondY = waveA * cos(waveW*i + offsetX)+currentK;
        
        //将点连成线
        CGPathAddLineToPoint(firstPath, nil, i, firstY);
        CGPathAddLineToPoint(secondPath, nil, i, secondY);
    }
    CGPathAddLineToPoint(firstPath, nil, WavesWidth, self.frame.size.height);
    CGPathAddLineToPoint(firstPath, nil, 0,  self.frame.size.height);
    
    CGPathAddLineToPoint(secondPath, nil, WavesWidth, self.frame.size.height);
    CGPathAddLineToPoint(secondPath, nil, 0,  self.frame.size.height);
    CGPathCloseSubpath(firstPath);
    CGPathCloseSubpath(secondPath);
    self.secondWavesLayer.path = secondPath;
    self.firstWavesLayer.path = firstPath;
    
    //使用layer 而没用CurrentContext
    CGPathRelease(firstPath);
    CGPathRelease(secondPath);
}


- (CADisplayLink *)wavesDisplayLink {
    if (!_wavesDisplayLink) {
        //启动定时器
        _wavesDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
        if(@available(iOS 10.0, *)) {
            _wavesDisplayLink.preferredFramesPerSecond = 60;
        }else {
            _wavesDisplayLink.frameInterval = 1;
        }
        
    }
    return _wavesDisplayLink;
}

-(void)dealloc
{
    [self.wavesDisplayLink invalidate];
}

- (void)startAnimating {
    [_wavesDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimating {
    [self.wavesDisplayLink invalidate];
    self.wavesDisplayLink = nil;
}


@end
