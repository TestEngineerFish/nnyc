//
//  YXBarChartView.m
//  YXEDU
//
//  Created by yao on 2018/12/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXBarChartView.h"
@interface YXBarChartView ()
@property (nonatomic, strong)NSMutableArray *gradientLayers;
@property (nonatomic, strong)NSMutableArray *textLayers;
@property (nonatomic, strong)NSArray *percents;
@end
@implementation YXBarChartView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.gradientLayers = [NSMutableArray array];
        self.textLayers = [NSMutableArray array];
        NSArray *textColors = @[UIColorOfHex(0x74CDFF),UIColorOfHex(0xC0ACFA),UIColorOfHex(0xEFC841)];
        NSArray *layerColors = @[
                                 @[(__bridge id)UIColorOfHex(0x61EEFF).CGColor, (__bridge id)UIColorOfHex(0x84B3FF).CGColor],
                                 @[(__bridge id)UIColorOfHex(0xE4DAFE).CGColor, (__bridge id)UIColorOfHex(0xC9B8FA).CGColor],
                                 @[(__bridge id)UIColorOfHex(0xFEE48A).CGColor, (__bridge id)UIColorOfHex(0xFEE48A).CGColor]
                                 ];
        for (NSInteger i =0; i < textColors.count; i++) {
            CAGradientLayer *myLayer = [self gradinatLayerWithColors:layerColors[i]];
            [self.layer addSublayer:myLayer];
            [self.gradientLayers addObject:myLayer];
            
            CATextLayer *textLayer = [self textLayerWithColor:textColors[i]];
            [self.layer addSublayer:textLayer];
            [self.textLayers addObject:textLayer];
        }
        self.alignmentMode = kCAAlignmentCenter;
    }
    return self;
}

- (void)setDatas:(NSArray *)datas {
    _datas = datas;
    [self refreshView];
}

- (void)refreshView {
    if (!self.datas.count) {
        return;
    }
    NSInteger max = [[_datas valueForKeyPath:@"@max.integerValue"] integerValue];
    NSMutableArray *percents = [NSMutableArray array];
    for (NSInteger i = 0 ; i < self.datas.count; i++) {
        NSString *num = [self.datas objectAtIndex:i];
        CATextLayer *textLayer = [self.textLayers objectAtIndex:i];
        if ([num containsString:@"."]) {
            CGFloat value = [num floatValue];
            [percents addObject:@(value / max)];
            textLayer.string = [NSString stringWithFormat:@"%.2f",value];
        }else {
            [percents addObject:@(1.0 * [num integerValue] / max)];
            textLayer.string = [NSString stringWithFormat:@"%@",num];
        }
    }
    self.percents = [percents copy];
    [self setNeedsLayout];
}

- (void)setAlignmentMode:(CATextLayerAlignmentMode)alignmentMode {
    _alignmentMode = alignmentMode;
    for (CATextLayer *textLayer in self.textLayers) {
        textLayer.alignmentMode = alignmentMode;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat textH = AdaptSize(16);
    CGFloat barWith = AdaptSize(12);
    CGFloat margin = (size.width - 3 * barWith) * 0.5;
    
    CGFloat blankH = AdaptSize(30); // 图标留白
    CGFloat avaiableH = size.height - textH - blankH;
    CGFloat textWidth = margin + barWith;
    
    for (NSInteger i =0; i< self.gradientLayers.count;i++) {
        CGFloat x = (barWith + margin) * i;
        CGFloat percent = [[self.percents objectAtIndex:i] floatValue];
        CGFloat height = avaiableH * percent;
        CGFloat y = size.height - height;
        CAGradientLayer *layer = [self.gradientLayers objectAtIndex:i];
        layer.frame = CGRectMake(x , y, barWith, height);
        
        CATextLayer *textLayer = [self.textLayers objectAtIndex:i];
        CGFloat textY = layer.frame.origin.y - textH;
        if ([self.alignmentMode isEqualToString:kCAAlignmentCenter]) {
            CGFloat textX = x - margin * 0.5;
            textLayer.frame = CGRectMake(textX, textY, textWidth, textH);
        }else if([self.alignmentMode isEqualToString:kCAAlignmentLeft]) {
            CGFloat textX = x;
            textLayer.frame = CGRectMake(textX, textY, textWidth, textH);
        }else if([self.alignmentMode isEqualToString:kCAAlignmentRight]) {
            CGFloat textX = x - margin;
            textLayer.frame = CGRectMake(textX, textY, textWidth, textH);
        }
    }
}

- (CAGradientLayer *)gradinatLayerWithColors:(NSArray *)colors {
    CAGradientLayer *gradinatLayer = [CAGradientLayer layer];
    gradinatLayer.colors = colors;//
    gradinatLayer.locations = @[@0.0,@1.0];
    gradinatLayer.startPoint = CGPointMake(0, 0);
    gradinatLayer.endPoint = CGPointMake(0, 1);
    return gradinatLayer;
}

- (CATextLayer *)textLayerWithColor:(UIColor *)color {
    CATextLayer *textlayer = [CATextLayer layer];
    textlayer.contentsScale = [UIScreen mainScreen].scale; // 文字模糊
    textlayer.fontSize = AdaptSize(12);
    textlayer.foregroundColor = color.CGColor;
    return textlayer;
}


@end
