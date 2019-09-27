//
//  YXReportAblityView.m
//  YXEDU
//
//  Created by yao on 2018/12/10.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXReportAblityView.h"
#define kPolygonCount 5
#define kPolygonlength AdaptSize(99)
#define kPolygonPerAngel (2 * M_PI / kPolygonCount)
#define kPloygonBottomAngle ((M_PI - kPolygonPerAngel) * 0.5)
#define kPolygonRadius (kPolygonlength * 1.0 * cos(kPloygonBottomAngle) / (1 - cos(kPolygonPerAngel)))

#define kRadiusMargin AdaptSize(14)
@interface YXReportAblityView ()
@property (nonatomic, strong)UIImageView *abilityBGIcon;
@property (nonatomic, weak)UIView *abilityView;

@property (nonatomic, weak)CAShapeLayer *polygonLayer;
@property (nonatomic, weak)CAShapeLayer *outerPolygonLayer;
@property (nonatomic, weak)CAShapeLayer *middlePolygonLayer;
@property (nonatomic, weak)CAShapeLayer *insidePolygonLayer;

@property (nonatomic, strong)NSMutableArray *outerPoints;
@property (nonatomic, strong)NSMutableArray *insiderPoints;

@property (nonatomic, weak)CAGradientLayer *gradientLayer;
@property (nonatomic, weak)CAShapeLayer *abilityShapeLayer;
@property (nonatomic, strong)NSMutableArray *dotLayers;
@end
@implementation YXReportAblityView

- (NSMutableArray *)outerPoints {
    if (!_outerPoints) {
        _outerPoints = [NSMutableArray array];
    }
    return _outerPoints;
}

- (NSMutableArray *)insiderPoints {
    if (!_insiderPoints) {
        _insiderPoints = [NSMutableArray array];
    }
    return _insiderPoints;
}

- (NSMutableArray *)dotLayers {
    if (!_dotLayers) {
        CGFloat dotWH = AdaptSize(4);
        NSMutableArray *dotLayers = [NSMutableArray array];
        for (NSInteger i = 0; i < kPolygonCount; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = UIColorOfHex(0xF3A9FB).CGColor;
            layer.frame = CGRectMake(0, 0, dotWH, dotWH);
            UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, dotWH, dotWH)];
            layer.path = path.CGPath;
            layer.hidden = YES;
            [self.abilityView.layer addSublayer:layer];
            [dotLayers addObject:layer];
        }
        _dotLayers = dotLayers;
    }
    return _dotLayers;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleL.text = @"能力维度";
    
        self.abilityBGIcon = [[UIImageView alloc] init];
        self.abilityBGIcon.image = [UIImage imageNamed:@"AbilityImage"];
        [self addSubview:self.abilityBGIcon];
        [self abilityView];
        
        CGFloat firstRadius = kPolygonRadius;
        CGFloat radiusMargin = kRadiusMargin;
        CGFloat secondRadius = firstRadius - radiusMargin;
        CGFloat thirdRadius = secondRadius - radiusMargin;

        CAShapeLayer *outerPolygonLayer = [CAShapeLayer layer];
        CGFloat wh = 2 * firstRadius;
        outerPolygonLayer.frame = CGRectMake(0, 0, wh, wh);
        outerPolygonLayer.fillColor = UIColorOfHex(0xDCE9FF).CGColor;
        [self.abilityView.layer addSublayer:outerPolygonLayer];
        _outerPolygonLayer = outerPolygonLayer;
        
        
        CAShapeLayer *middlePolygonLayer = [CAShapeLayer layer];
        wh = 2 * secondRadius;
        middlePolygonLayer.frame = CGRectMake(0, 0, wh, wh); //CGRectMake(radiusMargin, radiusMargin, wh, wh);
        middlePolygonLayer.fillColor = UIColorOfHex(0xf0f6ff).CGColor;
        [self.abilityView.layer addSublayer:middlePolygonLayer];
        _middlePolygonLayer = middlePolygonLayer;
        
        CAShapeLayer *insidePolygonLayer = [CAShapeLayer layer];
        wh = 2 * secondRadius;
        insidePolygonLayer.frame = CGRectMake(0, 0, wh, wh); //CGRectMake(2 * radiusMargin, 2 * radiusMargin, wh, wh);
        insidePolygonLayer.fillColor = UIColor.whiteColor.CGColor;
        [self.abilityView.layer addSublayer:insidePolygonLayer];
        _insidePolygonLayer = insidePolygonLayer;
        
        CGFloat startAngle = M_PI_2;
        UIBezierPath *outerRollPath = [UIBezierPath bezierPath];
//        [firstRollPath moveToPoint:CGPointMake(firstRadius, 0)];
        UIBezierPath *middleRollpath = [UIBezierPath bezierPath];
//        [secondRollpath moveToPoint:CGPointMake(firstRadius, radiusMargin)];
        UIBezierPath *insiderRollpath = [UIBezierPath bezierPath];
//        [thirdRollpath moveToPoint:CGPointMake(firstRadius, 2 * radiusMargin)];
        
        NSArray *titles = @[@"学习习惯",@"记忆力",@"学习效率",@"毅力",@"学习稳定性"];
        CGFloat labelHMargin = AdaptSize(7);
        CGFloat labelVmargin = AdaptSize(5);
        CGFloat labelWidth = 2 * firstRadius;
        CGFloat labelHeight = radiusMargin + AdaptSize(1); // 字号 + 1
        
        for (NSInteger i = 0; i < kPolygonCount; i ++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:radiusMargin];
            label.textColor = UIColorOfHex(0x84B3FF);
            label.text = [titles objectAtIndex:i];
            [self.abilityView addSubview:label];
            
            CGFloat angle = startAngle - i * kPolygonPerAngel;
            CGFloat sinAngleValue = sin(angle);
            CGFloat cosAngleValue = cos(angle);
            CGFloat outerRollPointX = firstRadius * (1 + cosAngleValue);
            CGFloat outerRollPointY = firstRadius * (1 - sinAngleValue );
            CGPoint outerRollPoint = CGPointMake(outerRollPointX, outerRollPointY);
            [self.outerPoints addObject:[NSValue valueWithCGPoint:outerRollPoint]];

            CGFloat xOff = outerRollPointX - firstRadius;
            CGFloat labelX = 0;
            if (xOff == 0) {
                label.textAlignment = NSTextAlignmentCenter;
                labelX = outerRollPointX - labelWidth * 0.5;
            }else if (xOff >= 0) {
                label.textAlignment = NSTextAlignmentLeft;
                labelX = outerRollPointX + labelHMargin;
            }else {
                label.textAlignment = NSTextAlignmentRight;
                labelX = outerRollPointX - labelHMargin - labelWidth;
            }
            
            CGFloat labelY = 0;
            if (outerRollPointY == 0) {
                labelY = outerRollPointY - labelVmargin - labelHeight;
            }else if (outerRollPointY == 2 * firstRadius) {
                labelY = outerRollPointY + labelHMargin;
            }else {
                labelY = outerRollPointY - labelHeight * 0.5;
            }
            
            label.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);

            CGFloat middleRollPointX = firstRadius + cosAngleValue * secondRadius;
            CGFloat middleRollPointY = firstRadius - sinAngleValue * secondRadius;
            CGPoint middleRollPoint = CGPointMake(middleRollPointX, middleRollPointY);
            
            CGFloat insiderRollPointX = firstRadius + cosAngleValue * thirdRadius;
            CGFloat insiderRollPointY = firstRadius - sinAngleValue * thirdRadius;
            CGPoint insiderRollPoint = CGPointMake(insiderRollPointX, insiderRollPointY);
            [self.insiderPoints addObject:[NSValue valueWithCGPoint:insiderRollPoint]];
            
            if (i == 0) {
                [outerRollPath moveToPoint:outerRollPoint];
                [middleRollpath moveToPoint:middleRollPoint];
                [insiderRollpath moveToPoint:insiderRollPoint];
            }else {
                [outerRollPath addLineToPoint:outerRollPoint];
                [middleRollpath addLineToPoint:middleRollPoint];
                [insiderRollpath addLineToPoint:insiderRollPoint];
            }
        }
    
        [outerRollPath fill];
        [middleRollpath fill];
        [insiderRollpath fill];
        UIBezierPath *outPolygonPath = [UIBezierPath bezierPath];
        [outPolygonPath appendPath:outerRollPath];
        [outPolygonPath appendPath:[middleRollpath bezierPathByReversingPath]];
        outerPolygonLayer.path = outPolygonPath.CGPath;
        
        UIBezierPath *middlePolygonPath = [UIBezierPath bezierPath];
        [middlePolygonPath appendPath:middleRollpath];
        [middlePolygonPath appendPath:[insiderRollpath bezierPathByReversingPath]];
        middlePolygonLayer.path = middlePolygonPath.CGPath;
        
        insidePolygonLayer.path = insiderRollpath.CGPath;
        
        self.gradientLayer.frame = CGRectMake(0, 0, 2 * firstRadius, 2 * firstRadius);
        self.abilityShapeLayer.frame = self.gradientLayer.bounds;
        [self dotLayers];
    }
    return self;
}



- (void)setAbility:(YXMyAbility *)ability {
    _ability = ability;
    [self refreshAbilitylayer];
}

- (void)refreshAbilitylayer {
    if (_ability) {
        CGFloat ability[kPolygonCount] = {  _ability.habit,
                                            _ability.memory,
                                            _ability.efficiency,
                                            _ability.will,
                                            _ability.stability};
        
        CGFloat startAngle = M_PI_2;
        CGFloat outerRadius = kPolygonRadius;
        UIBezierPath *path = [UIBezierPath bezierPath];
        for (int i = 0; i < kPolygonCount; i ++) {
            CGFloat value = ability[i];
            CGFloat radius = value * outerRadius;
            CGFloat angle = startAngle - i * kPolygonPerAngel;
            CGFloat sinAngleValue = sin(angle);
            CGFloat cosAngleValue = cos(angle);

            CGFloat pointX = outerRadius + cosAngleValue * radius;
            CGFloat pointY = outerRadius - sinAngleValue * radius;
            CGPoint point = CGPointMake(pointX, pointY);
            (i == 0) ? [path moveToPoint:point] : [path addLineToPoint:point];
            
            CAShapeLayer *dot = [self.dotLayers objectAtIndex:i];
            CGRect frame = dot.frame;
            CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
            CGRect desRect = CGRectOffset(frame, pointX - center.x, pointY - center.y);
            dot.frame = desRect;
            dot.hidden = NO;
        }
        [path fill];
        
        self.abilityShapeLayer.path = path.CGPath;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat bgHeight = AdaptSize(142.5);
    self.abilityBGIcon.frame = CGRectMake(0, size.height - bgHeight, size.width, bgHeight);
    CGFloat wh = 2 * kPolygonRadius;
    CGFloat x = (size.width - wh) * 0.5;
    self.abilityView.frame = CGRectMake(x, AdaptSize(47), wh, wh);
}

- (UIView *)abilityView {
    if (!_abilityView) {
        UIView *abilityView = [[UIView alloc] init];
        [self addSubview:abilityView];
        _abilityView = abilityView;
    }
    return _abilityView;
}

- (CAShapeLayer *)abilityShapeLayer {
    if (!_abilityShapeLayer) {
        CAShapeLayer *abilityShapeLayer = [CAShapeLayer layer];
        abilityShapeLayer.fillColor = [UIColor whiteColor].CGColor;
        [self.abilityView.layer addSublayer:abilityShapeLayer];
        _abilityShapeLayer = abilityShapeLayer;
    }
    return _abilityShapeLayer;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.locations = @[@0.3,@1.0];
        UIColor *ltColor = [UIColorOfHex(0xff7af4) colorWithAlphaComponent:0.44];
        UIColor *rbColor = [UIColorOfHex(0x86ecff) colorWithAlphaComponent:0.55];
        gradientLayer.colors = @[(__bridge id)ltColor.CGColor, (__bridge id)rbColor.CGColor];
        [self.abilityView.layer addSublayer:gradientLayer];
        gradientLayer.mask = self.abilityShapeLayer;
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}
@end
