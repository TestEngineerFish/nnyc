//
//  YXHomeTabTitleView.m
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeTabTitleView.h"
#import "BSCommon.h"
#import "NSString+YR.h"
@interface YXHomeTabTitleView ()
@property (nonatomic, strong) UIScrollView *tabContentScroll;
@property (nonatomic, strong) UIView  *indicateLine;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@end
@implementation YXHomeTabTitleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorOfHex(0x4DB3FE);
        self.btnArr = [NSMutableArray array];
        self.titleArr = [NSMutableArray arrayWithObjects:@"全  部", @"待学习", @"已学完", nil];
        
        CGFloat btnWidth = SCREEN_WIDTH/self.titleArr.count;
        for (int i = 0; i < self.titleArr.count; i++) {
            NSString *strTitle = self.titleArr[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:strTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setTag:i];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [btn setFrame:CGRectMake(btnWidth*i, 0, btnWidth, 40)];
            [self addSubview:btn];
            [self.btnArr addObject:btn];
        }
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 35, btnWidth, 3)];
        _indicateLine.backgroundColor = [UIColor whiteColor];
        _indicateLine.layer.cornerRadius = 1.5f;
        _indicateLine.clipsToBounds = YES;
        [self addSubview:_indicateLine];
        
        [self setAllBtnIdx:0];
    }
    return self;
}

- (void)btnClicked:(UIButton *)sender {
    [self setAllBtnIdx:sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleBtnDidClicked:)]) {
        [self.delegate titleBtnDidClicked:sender];
    }
}

- (void)setAllBtnIdx:(NSInteger )btnIdx {
    UIButton *btn = self.btnArr[btnIdx];
    CGFloat titleWidth = 30;
    _indicateLine.frame = CGRectMake((SCREEN_WIDTH/3.0)*btn.tag + ((SCREEN_WIDTH/3.0)-titleWidth)/2.0, 35, titleWidth, 3);
    for (UIButton *button in self.btnArr) {
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    }
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
}
@end
