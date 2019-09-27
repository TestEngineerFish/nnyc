//
//  YXReportIndexView.m
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportIndexView.h"
static inline CGPoint CGPointMid(CGPoint a,CGPoint b) {
    return CGPointMake((a.x  + b.x) * 0.5, (a.y + b.y) * 0.5);
}

@interface YXReportIndexView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong)UIImageView *indexBGIcon;
@property (nonatomic, weak)CAShapeLayer *indexShapeLayer;
@property (nonatomic, weak)CAGradientLayer *gradientLayer;
@property (nonatomic, strong)NSMutableArray *dateLabels;

@property (nonatomic, assign)NSInteger indexMaxValue;
@property (nonatomic, weak)UILabel *indexNumLabel;
@property (nonatomic, strong)NSMutableArray *indexPoints;
@end

@implementation YXReportIndexView
{
    UIButton *_tipsButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.titleL.text = @"单词学习指数";
        [self tipsButton];

        [self indexBGIcon];
        [self indexShapeLayer];
        [self gradientLayer];
        
        self.dateLabels = [NSMutableArray array];
        for (NSInteger i = 0; i < 7; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:10];
            label.textColor = UIColorOfHex(0x434A5D);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"00.00";
            [self.indexBGIcon addSubview:label];
            [self.dateLabels addObject:label];
        }
        
        self.indexNumLabel.frame = CGRectMake(0, 0, 100, AdaptSize(13));
        self.indexPoints = [NSMutableArray array];
    }
    return self;
}

- (void)setLearnIndex:(NSArray *)learnIndex {
    if (!learnIndex.count) {
        return;
    }

    NSArray *sortArr = [learnIndex sortedArrayUsingComparator:^NSComparisonResult(YXIndexModel *obj1, YXIndexModel *obj2) {
        if (obj1.value > self.indexMaxValue) {
            self.indexMaxValue = obj1.value;
        }

        if (obj2.value > self.indexMaxValue) {
            self.indexMaxValue = obj2.value;
        }
        if (obj1.date > obj2.date) {
            return NSOrderedDescending;
        }else {
            return NSOrderedAscending;
        }
        
    }];
    
    _learnIndex = sortArr;
    self.indexMaxValue += 1; //0值保护
    CGFloat gradientW = AdaptSize(304);
    CGFloat gradientH = AdaptSize(102);
    NSInteger indexCount = self.learnIndex.count;
    
    CGFloat lineWidth = self.indexShapeLayer.lineWidth;
    CGFloat pointGap = 1.0 * (gradientW - lineWidth) / (indexCount - 1); // -lineWidth，线端点圆角保护
    
    for (NSInteger i = 0; i < indexCount; i ++) {
        YXIndexModel *indexModel = [self.learnIndex objectAtIndex:i];
        if (indexModel.value > self.indexMaxValue) {
            self.indexMaxValue = indexModel.value;
        }
        UILabel *label = [self.dateLabels objectAtIndex:i];
        label.text = indexModel.dateStr;
        
        CGFloat percent = 1.0 * indexModel.value / _indexMaxValue;
        CGFloat x = lineWidth * 0.5 + i * pointGap;;
        CGFloat y = (gradientH - lineWidth * 0.5) * (1 - percent);
        CGPoint point = CGPointMake(x, y);
        [self.indexPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint firstPoint = [[self.indexPoints firstObject] CGPointValue];
    [path moveToPoint:firstPoint];

    CGPoint point2 = [[self.indexPoints objectAtIndex:1] CGPointValue];
    CGPoint firstMidPoint = CGPointMid(firstPoint, point2);
    [path addLineToPoint:firstMidPoint];
    
    for (NSInteger i = 1; i < indexCount - 1; i++) {
        CGPoint point =  [[self.indexPoints objectAtIndex:i] CGPointValue];
        
        NSInteger nextIndex = i + 1;
        CGPoint nextPoint =  [[self.indexPoints objectAtIndex:nextIndex] CGPointValue];
        
        CGPoint curPoint = path.currentPoint;
        CGPoint midPoint = CGPointMid(point, nextPoint);
        
        CGFloat cx1 = (curPoint.x + 2 * point.x) / 3;
        CGFloat cy1 = (curPoint.y + 2 * point.y) / 3;
        
        CGFloat cx2 = (midPoint.x + 2 * point.x) / 3;
        CGFloat cy2 = (midPoint.y + 2 * point.y) / 3;
        
        [path addCurveToPoint:midPoint controlPoint1:CGPointMake(cx1, cy1) controlPoint2:CGPointMake(cx2, cy2)];
    }
    
    CGPoint point = [[self.indexPoints lastObject] CGPointValue];
    [path addLineToPoint:point];
    
    self.indexShapeLayer.lineJoin = kCALineJoinRound;
    self.indexShapeLayer.lineCap = kCALineCapRound;
    self.indexShapeLayer.path = path.CGPath;
    [path stroke];
    
    [self setNeedsLayout];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = AdaptSize(10);
    CGSize size = self.bounds.size;
    
    CGFloat tipBtnWh = AdaptSize(38);
    self.tipsButton.frame = CGRectMake(AdaptSize(100), 0, tipBtnWh, tipBtnWh);
    
    CGFloat indexBGHeight = AdaptSize(148);
    CGFloat indexBGWidth = size.width - 2 * margin;
    CGFloat indexBGY = size.height - AdaptSize(12) - indexBGHeight;
    self.indexBGIcon.frame = CGRectMake(margin, indexBGY, indexBGWidth, indexBGHeight);
    
    CGFloat gradientW = AdaptSize(304);
    CGFloat gradientH = AdaptSize(102);
    CGFloat gradientX = AdaptSize(15);
    self.gradientLayer.frame = CGRectMake(gradientX, AdaptSize(22), gradientW, gradientH);
    self.indexShapeLayer.frame = self.gradientLayer.bounds;
    
    CGFloat count = self.dateLabels.count;
    CGFloat labelW = 1.0 * gradientW / count;
    CGFloat gap = 1.0 * gradientW / (count - 1);
    CGFloat dateLHeight = 11;
    for (NSInteger i = 0; i < count; i++) {
        UILabel *label = [self.dateLabels objectAtIndex:i];
        CGFloat centerX = gradientX + i * gap;
        CGFloat x = centerX - labelW * 0.5;
        label.frame = CGRectMake(x, indexBGHeight - dateLHeight, labelW, dateLHeight);
    }
}



- (void)showTips:(UIButton *)tipsButton {
    if ([self.delegate respondsToSelector:@selector(reportIndexViewClikShowTips:)]) {
        [self.delegate reportIndexViewClikShowTips:self];
    }
}

#pragma mark - subviews
- (UIButton *)tipsButton {
    if (!_tipsButton) {
        UIButton *tipsButton = [[UIButton alloc] init];
        [tipsButton setImage:[UIImage imageNamed:@"reportIndexTipsImage"] forState:UIControlStateNormal];
        [tipsButton addTarget:self action:@selector(showTips:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tipsButton];
        _tipsButton = tipsButton;
    }
    return _tipsButton;
}

- (CAShapeLayer *)indexShapeLayer {
    if (!_indexShapeLayer) {
        CAShapeLayer *indexShapeLayer = [CAShapeLayer layer];
        indexShapeLayer.lineWidth = 3.0;
        indexShapeLayer.fillColor = [UIColor clearColor].CGColor;
        indexShapeLayer.strokeColor = [UIColor whiteColor].CGColor;
//        indexShapeLayer.lineJoin = kCALineJoinRound;
//        indexShapeLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:indexShapeLayer];
        _indexShapeLayer = indexShapeLayer;
    }
    return _indexShapeLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.locations = @[@0.3,@1.0];
        gradientLayer.colors = @[(__bridge id)UIColorOfHex(0x82CCFF).CGColor, (__bridge id)UIColorOfHex(0xC981FB).CGColor];
        [self.indexBGIcon.layer addSublayer:gradientLayer];
        gradientLayer.mask = self.indexShapeLayer;
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

- (UILabel *)indexNumLabel {
    if (!_indexNumLabel) {
        UILabel *indexNumLabel = [[UILabel alloc] init];
        indexNumLabel.font = [UIFont systemFontOfSize:12];
        indexNumLabel.textColor = UIColorOfHex(0xC981FB);
        indexNumLabel.textAlignment = NSTextAlignmentCenter;
        [self.indexBGIcon addSubview:indexNumLabel];
        _indexNumLabel = indexNumLabel;
    }
    return _indexNumLabel;
}

- (UIImageView *)indexBGIcon {
    if (!_indexBGIcon) {
        UIImageView *indexBGIcon = [[UIImageView alloc] init];
        indexBGIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIndexView:)];
        [indexBGIcon addGestureRecognizer:tap];
        tap.delegate = self;
        indexBGIcon.image = [UIImage imageNamed:@"indexBGImage"];
        [self addSubview:indexBGIcon];
        _indexBGIcon = indexBGIcon;
    }
    return _indexBGIcon;
}

- (void)tapIndexView:(UITapGestureRecognizer *)tap {
    NSInteger indexCount = self.learnIndex.count;
    if (!indexCount) {
        return;
    }
    
//    CGFloat bgWidth = self.indexBGIcon.width;
    CGRect pathRect = self.gradientLayer.frame;
    CGFloat startX = pathRect.origin.x;
    CGFloat startY = pathRect.origin.y;
    CGFloat pointMargin = 1.0 * pathRect.size.width / (indexCount - 1);
    CGPoint locPoint = [tap locationInView:self.indexBGIcon];
    
    NSInteger tapIndex = -1;
    if (CGRectContainsPoint(pathRect, locPoint)) {
        CGFloat with = locPoint.x - startX;
        tapIndex = round(with / pointMargin);
//        NSLog(@"-------inside");
    }else {
//        NSLog(@"-------outside");
        if (locPoint.x < CGRectGetMinX(pathRect)) { // 显示第一个
            tapIndex = 0;
        }else if(locPoint.x > CGRectGetMaxX(pathRect)) { // 显示最后一个
            tapIndex = indexCount - 1;
        }
    }
    
    if (tapIndex >= indexCount || tapIndex < 0) {
        return;
    }
    
    CGPoint indexPoint = [[self.indexPoints objectAtIndex:tapIndex] CGPointValue];
    CGPoint convertPoint = CGPointMake(startX + indexPoint.x, startY + indexPoint.y);
    YXIndexModel *indexModel = [self.learnIndex objectAtIndex:tapIndex];
    self.indexNumLabel.text = [NSString stringWithFormat:@"%zd",indexModel.value];
    self.indexNumLabel.center = CGPointMake(convertPoint.x, convertPoint.y - 5 - self.indexNumLabel.height * 0.5);
    self.indexNumLabel.hidden = NO;
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.indexNumLabel.hidden = YES;
        });
    }

}

@end
