//
//  YXCalendarChartView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarChartView.h"
#import "NSDate+Extension.h"

@interface YXCalendarChartView ()
@property (nonatomic, strong) NSArray<NSDictionary *> *dataArray;
@property (nonatomic, strong) UIView *xAxisView;
@property (nonatomic, strong) UIView *yAxisView;
@property (nonatomic, assign) CGFloat screenViewHeight;
@end

@implementation YXCalendarChartView

- (CGFloat)screenViewHeight {
    return SCREEN_WIDTH*1.15f - 135.f;
}

- (void)setDataArray:(NSArray<NSDictionary *> *)dataArray selected:(NSNumber *)index {
    self.dataArray = dataArray;
    [self scrollView];
    [self xAxisView];
    [self yAxisView];
    [self layoutIfNeeded];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.contentSize = CGSizeMake(1000, self.screenViewHeight);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview: scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self).with.offset(15.f);
            make.size.mas_equalTo(CGSizeMake(self.width - 30.f, self.screenViewHeight));

        }];
        scrollView.height = 0.f;
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIView *)xAxisView {
    if (!_xAxisView) {
        _xAxisView = [[UIView alloc] init];
        _xAxisView.backgroundColor = UIColorOfHex(0xDF8619);
        [self addSubview:_xAxisView];
        [self bringSubviewToFront:_xAxisView];
        [_xAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(15);
            make.right.equalTo(self).with.offset(-15);
            make.bottom.equalTo(self.scrollView).with.offset(-40);
            make.height.mas_equalTo(1.f);
        }];
    }
    return _xAxisView;
}

- (UIView *)yAxisView {
    if (!_yAxisView) {
        _yAxisView = [[UIView alloc] init];
        _yAxisView.backgroundColor = UIColorOfHex(0xDF8619);
        [self addSubview:_yAxisView];
        [self bringSubviewToFront:_yAxisView];
        [_yAxisView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).with.offset(-1.f);
            make.top.equalTo(self).with.offset(15);
            make.bottom.equalTo(self.xAxisView);
            make.width.mas_equalTo(1.f);
        }];
    }
    return _yAxisView;
}
@end
