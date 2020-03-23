//
//  YXLearnProgressView.m
//  YXEDU
//
//  Created by shiji on 2018/3/29.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXLearnProgressView.h"
#import "BSCommon.h"
#import "NSString+YR.h"

#define kMarginWidth 10

@interface YXLearnProgressView ()

@property (nonatomic, strong) UIView *pView;
@property (nonatomic, strong) NSMutableArray *totalArr;

@end

@implementation YXLearnProgressView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.totalArr = [NSMutableArray array];
        self.progressLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.progressLab.textColor = UIColorOfHex(0x7BC70D);
        self.progressLab.font = [UIFont boldSystemFontOfSize:18];
        self.progressLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.progressLab];
        
        self.pView = [[UIView alloc]init];
        [self addSubview:self.pView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setUnitGroupTotal:(NSInteger)unitGroupTotal {
    _unitGroupTotal = unitGroupTotal;
    YXEventLog(@"unitGroupTotal:%ld", (long)unitGroupTotal);
    for (int i=0; i<unitGroupTotal + 1; i++) {
        UIView *v = [UIView new];
        v.layer.borderColor = UIColorOfHex(0xBBBBBB).CGColor;
        v.layer.borderWidth = 0.5;
        v.clipsToBounds = YES;
        v.frame = CGRectMake(0, 0, 0, 12);
        [self.totalArr addObject:v];
        [self.pView addSubview:v];
    }
}

- (void)setUnitGroupIdx:(NSInteger)unitGroupIdx {
    _unitGroupIdx = unitGroupIdx;
//    YXEventLog(@"unitGroupNum:%ld", (long)unitGroupIdx);
}

- (void)setUnitGroupQuestionCount:(NSInteger)unitGroupQuestionCount {
    _unitGroupQuestionCount = unitGroupQuestionCount;
}

- (void)setUnitGroupQuestionLearnCount:(NSInteger)unitGroupQuestionLearnCount {
    _unitGroupQuestionLearnCount = unitGroupQuestionLearnCount;
    [self reloadView];
}

- (void)reloadView {
    self.progressLab.text = [NSString stringWithFormat:@"%ld/%ld组",_unitGroupIdx+1,_unitGroupTotal];
    CGFloat labWidth = [self.progressLab.text sizeWithMaxWidth:SCREEN_WIDTH font:self.progressLab.font].width + kMarginWidth;
    self.progressLab.frame = CGRectMake(self.frame.size.width-labWidth, 0, labWidth, 12);
    self.pView.frame = CGRectMake(0, 0, self.frame.size.width-labWidth, 12);
    self.pView.layer.cornerRadius = 6.0f;
    self.pView.backgroundColor = UIColorOfHex(0xDDDDDD);
    self.pView.clipsToBounds = YES;
    
    for (int i=0; i< _unitGroupTotal + 1; i++) {
        if (i < _unitGroupIdx) {
            if (i+1 == _unitGroupIdx) { // 最后一个加动画
                UIView *v = self.totalArr[i];
                [UIView animateWithDuration:0.5 animations:^{
                    v.frame = CGRectMake(i*13, 0, 13, 12);
                } completion:^(BOOL finished) {
                    v.backgroundColor = UIColorOfHex(0x7BC70D);
                }];
            } else {
                UIView *v = self.totalArr[i];
                v.frame = CGRectMake(i*13, 0, 13, 12);
                v.backgroundColor = UIColorOfHex(0x7BC70D);
            }
        } else if (i == _unitGroupIdx) {
            [UIView animateWithDuration:0.5 animations:^{
                CGFloat ratio = (CGFloat)_unitGroupQuestionLearnCount/(CGFloat)_unitGroupQuestionCount;
                CGFloat width1 = (CGRectGetWidth(self.pView.frame)-(_unitGroupTotal-1)*13)*ratio;
                CGFloat width2 = (CGRectGetWidth(self.pView.frame)-(_unitGroupTotal-1)*13)*(1-ratio);
                UIView *v1 = self.totalArr[i];
                v1.frame = CGRectMake(i*13, 0, width1, 12);
                v1.backgroundColor = UIColorOfHex(0xACDE65);
                UIView *v2 = self.totalArr[i+1];
                v2.frame = CGRectMake(i*13+width1, 0, width2, 12);
                v2.backgroundColor = UIColorOfHex(0xDDDDDD);
            } completion:^(BOOL finished) {
                
            }];
            
        } else if (i-1 > _unitGroupIdx) {
            CGFloat x = CGRectGetWidth(self.pView.frame) - (_unitGroupTotal-i+1)*13;
            UIView *v = self.totalArr[i];
            v.frame = CGRectMake(x, 0, 13, 12);
            v.backgroundColor = UIColorOfHex(0xDDDDDD);
        }
    }
}



@end
