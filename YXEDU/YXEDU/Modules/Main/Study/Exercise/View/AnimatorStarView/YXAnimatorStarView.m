//
//  YXAnimatorStarView.m
//  YXEDU
//
//  Created by yixue on 2019/1/21.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXAnimatorStarView.h"

@interface YXAnimatorStarView ()

@property (nonatomic, copy) NSArray *starsArray;

@end

@implementation YXAnimatorStarView

- (id)initWithRadius:(CGFloat)spreadRadius position:(CGPoint)position {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _spreadRadius = spreadRadius;
        _position = position;

        _starRadius = 16;
        _numberOfStars = 5;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.center = _position;
    self.size = CGSizeMake(2*_spreadRadius, 2*_spreadRadius);
}

- (void)setPosition:(CGPoint)position {
    _position = position;
    self.center = _position;
    [self setNeedsLayout];
}

- (void)launchAnimations {
    [self createStarsOnPosition];
    [self spreadStarsAndDismiss];
}

- (void)createStarsOnPosition {
    if (_starsArray) {
        for (UIImageView *starView in _starsArray) {
            [starView removeFromSuperview];
        }
    }
    NSMutableArray *temStarsArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _numberOfStars; i++) {
        UIImageView *starView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
        starView.center = CGPointMake(_spreadRadius, _spreadRadius);
        starView.size = CGSizeMake(_starRadius, _starRadius);
        [self addSubview:starView];
        [temStarsArray addObject:starView];
    }
    _starsArray = temStarsArray;
}

- (void)spreadStarsAndDismiss { //扩散动画
    [UIView animateWithDuration:0.4 animations:^{
        for (NSInteger i = 0; i < _numberOfStars; i++) {
            UIImageView *starView = _starsArray[i];
            starView.center = [self getTargetPositionsWithIndex:i];
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            for (NSInteger i = 0; i < _numberOfStars; i++) {
                UIImageView *starView = _starsArray[i];
                starView.alpha = 0;
            }
        } completion:nil];
    }];
}

- (CGPoint)getTargetPositionsWithIndex:(NSInteger)index {
    NSNumber *num = [NSNumber numberWithInt:(int)_numberOfStars];
    CGFloat angle = 360.0/[num floatValue] * M_PI/180.0;
    
    CGFloat start = index * angle - M_PI_2;
    CGFloat end = start + angle;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_spreadRadius, _spreadRadius)
                                                        radius:_spreadRadius
                                                    startAngle:start
                                                      endAngle:end
                                                     clockwise:YES];
    CGPoint position = [path currentPoint];
    return position;
}

@end
