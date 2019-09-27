//
//  YXDataSituationView.m
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDataSituationView.h"
#import "YXBarChartView.h"


@interface YXReportMarkView : UIView
@property (nonatomic, strong)CALayer *rectlayer;
@property (nonatomic, strong)CATextLayer *textLayer;
@end

@implementation YXReportMarkView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.rectlayer = [CALayer layer];
        self.rectlayer.cornerRadius = AdaptSize(1.5);
        [self.layer addSublayer:self.rectlayer];
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [UIScreen mainScreen].scale; // 文字模糊
        textLayer.fontSize = AdaptSize(12);
        [self.layer addSublayer:textLayer];
        self.textLayer = textLayer;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat rectWH = AdaptSize(6);
    CGFloat y = (size.height - rectWH) * 0.5;
    self.rectlayer.frame = CGRectMake(0, y, rectWH, rectWH);
    CGFloat textX = rectWH + rectWH;
    self.textLayer.frame = CGRectMake(textX, -AdaptSize(1), size.width - textX, size.height);
}
@end






@interface YXDataSituationView ()
@property (nonatomic, strong)YXBarChartView *learnedView;
@property (nonatomic, weak) YXBarChartView *averRightView;
@property (nonatomic, weak) YXBarChartView *punchView;
@property (nonatomic, weak) CALayer *LineLayer;

@property (nonatomic, weak)CATextLayer *learnedTitle;
@property (nonatomic, weak)CATextLayer *avergeTitle;
@property (nonatomic, weak)CATextLayer *punchTitle;

@property (nonatomic, strong)YXReportMarkView *firstMark;
@property (nonatomic, strong)YXReportMarkView *averMark;
@property (nonatomic, strong)YXReportMarkView *MyMark;
@end

@implementation YXDataSituationView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleL.text = @"数据概况";
        [self learnedView];
        [self averRightView];
        [self punchView];
        
        self.firstMark = [[YXReportMarkView alloc] init];
        self.firstMark.rectlayer.backgroundColor = UIColorOfHex(0xF3D784).CGColor;
        self.firstMark.textLayer.foregroundColor = UIColorOfHex(0xEFC841).CGColor;
        self.firstMark.textLayer.string = @"第一名";
        [self addSubview:self.firstMark];
        
        self.averMark = [[YXReportMarkView alloc] init];
        self.averMark.rectlayer.backgroundColor = UIColorOfHex(0xD0BFFD).CGColor;
        self.averMark.textLayer.foregroundColor = UIColorOfHex(0xBCA6F8).CGColor;
        self.averMark.textLayer.string = @"全国平均";
        [self addSubview:self.averMark];
        
        self.MyMark = [[YXReportMarkView alloc] init];
        self.MyMark.rectlayer.backgroundColor = UIColorOfHex(0x6DDBFF).CGColor;
        self.MyMark.textLayer.foregroundColor = UIColorOfHex(0x74CDFF).CGColor;
        self.MyMark.textLayer.string = @"我的";
        [self addSubview:self.MyMark];
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = UIColorOfHex(0xD0CDDD).CGColor;
        [self.layer addSublayer:layer];
        self.LineLayer = layer;
        
        CATextLayer *learnedTitle = [self custextLayer];
        learnedTitle.string = @"做题数";
        [self.layer addSublayer:learnedTitle];
        _learnedTitle = learnedTitle;
        
        CATextLayer *avergeTitle = [self custextLayer];
        avergeTitle.string = @"平均正答率(%)";
        [self.layer addSublayer:avergeTitle];
        _avergeTitle = avergeTitle;
        
        
        CATextLayer *punchTitle = [self custextLayer];
        punchTitle.string = @"学习天数(d)";
        [self.layer addSublayer:punchTitle];
        _punchTitle = punchTitle;
        
    }
    return self;
}

- (void)refreshWith:(NSArray *)learnedQues
    correctPercents:(NSArray *)corPercents
          learnDays:(NSArray *)learnDays {
    self.learnedView.datas = learnedQues;
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *str in corPercents) {
        NSInteger value = [str floatValue] * 100;
        [array addObject:[NSString stringWithFormat:@"%zd",value]];
    }
    self.averRightView.datas = [array copy];
    self.punchView.datas = learnDays;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat margin = AdaptSize(10);
    CGFloat chartW = AdaptSize(80);
    CGFloat chartH = AdaptSize(146);
    
    self.learnedView.frame = CGRectMake(margin, 22, chartW, chartH);
    CGRect oriRect = CGRectMake(margin, self.learnedView.bottom + margin, chartW, 16);
    self.learnedTitle.frame = oriRect;
    
    CGFloat punchViewX = size.width - margin - chartW;
    self.punchView.frame = CGRectMake(punchViewX, 22, chartW, chartH);
    oriRect.origin.x = punchViewX;
    self.punchTitle.frame = oriRect;
    
    CGFloat averRightViewX = (size.width - chartW) * 0.5;
    self.averRightView.frame = CGRectMake(averRightViewX, 22, chartW, chartH);
    
    CGFloat extend = 10;
    oriRect.origin.x = averRightViewX - extend;
    oriRect.size.width += 2 * extend;
    self.avergeTitle.frame = oriRect;

    self.LineLayer.frame = CGRectMake(margin, self.learnedView.bottom, size.width - 2 *margin, 0.5);
    
    CGFloat firstMarkW = AdaptSize(50);
    CGRect markRect = CGRectMake(size.width - margin - firstMarkW, AdaptSize(17), firstMarkW, AdaptSize(14));
    self.firstMark.frame = markRect;
    
    CGFloat markmargin = AdaptSize(15);
    CGFloat averMarkW = AdaptSize(64);
    markRect.origin.x = self.firstMark.origin.x - markmargin - averMarkW;
    markRect.size.width = averMarkW;
    self.averMark.frame = markRect;
    
    CGFloat myMarkW = AdaptSize(37);
    markRect.origin.x = self.averMark.origin.x - markmargin - myMarkW;
    markRect.size.width = myMarkW;
    self.MyMark.frame = markRect;
}

- (YXBarChartView *)learnedView {
    if (!_learnedView) {
        YXBarChartView *learnedView = [[YXBarChartView alloc] init];
        learnedView.alignmentMode = kCAAlignmentLeft;
        [self addSubview:learnedView];
        _learnedView = learnedView;
    }
    return _learnedView;
}

- (YXBarChartView *)averRightView {
    if (!_averRightView) {
        YXBarChartView *averRightView = [[YXBarChartView alloc] init];
        [self addSubview:averRightView];
        _averRightView = averRightView;
    }
    return _averRightView;
}

- (YXBarChartView *)punchView {
    if (!_punchView) {
        YXBarChartView *punchView = [[YXBarChartView alloc] init];
        punchView.alignmentMode = kCAAlignmentRight;
        [self addSubview:punchView];
        _punchView = punchView;
    }
    return _punchView;
}

- (CATextLayer *)custextLayer {
    CATextLayer *textlayer = [CATextLayer layer];
    textlayer.contentsScale = [UIScreen mainScreen].scale; // 文字模糊
    textlayer.fontSize = AdaptSize(12);
    textlayer.alignmentMode = kCAAlignmentCenter;
    textlayer.foregroundColor = UIColorOfHex(0x485562).CGColor;
    return textlayer;
}

@end
