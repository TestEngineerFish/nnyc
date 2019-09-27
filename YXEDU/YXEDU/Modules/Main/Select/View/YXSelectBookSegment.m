//
//  YXSelectBookSegment.m
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookSegment.h"

@implementation YXSelectBookSegment
{
    NSInteger _currentSelectIndex;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorOfHex(0xDFEAFF);
        _currentSelectIndex = NSNotFound;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = [titles copy];
    _currentSelectIndex = NSNotFound;
    [self handleSubViews];
}

- (void)handleSubViews {
    if (self.subviews.count) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (NSString *title in self.titles) {
        NSInteger index = [self.titles indexOfObject:title];
        UIButton *btn = [self titleButton];
        btn.tag = index;
        [btn setTitle:title forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    [self layoutIfNeeded];
    // 选中第一个
    [self titleClicked:self.subviews.firstObject];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    CGFloat margin = 1;
    
    CGFloat btnWidth = size.width * 1.0 / self.subviews.count;
    
    for (UIView *view in self.subviews) {
        CGFloat x = (btnWidth + margin) * view.tag;
        view.frame = CGRectMake(x, 0, btnWidth, size.height);
    }
}

- (UIButton *)titleButton {
    UIButton *btn = [[UIButton alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:UIColorOfHex(0x849EC5) forState:UIControlStateNormal];
    [btn setTitleColor:UIColorOfHex(0x55A7FD) forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
#pragma mark - actions
- (void)titleClicked:(UIButton *)btn {
    if (btn.tag != self.currentSelectIndex) {
        if([self.delegate respondsToSelector:@selector(selectBookSegment:selectTitleIndex:)]) {
            [self.delegate selectBookSegment:self selectTitleIndex:btn.tag];
        }
    }
    
    [self selectTitleAtIndex:btn.tag];
}

- (void)selectTitleAtIndex:(NSInteger)index {
    if (self.currentSelectIndex == index && index >= self.subviews.count) { // 选中的是同一个
        return;
    }
    
    if (self.currentSelectIndex != NSNotFound ) {
        UIButton *currentBtn = [self.subviews objectAtIndex:self.currentSelectIndex];
        currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        currentBtn.selected = NO;
    }
    
    UIButton *clickBtn = [self.subviews objectAtIndex:index];
    clickBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    clickBtn.selected = YES;
    _currentSelectIndex  = index;
}

@end
