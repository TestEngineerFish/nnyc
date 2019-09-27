//
//  YXCalendarChartView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarChartView.h"
#import "NSDate+Extension.h"

@interface YXCalendarChartView ()<XJYChartDelegate>
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
    if (self.lineChartView) {
        [self.lineChartView removeFromSuperview];
        [self.barChartView removeFromSuperview];
        self.lineChartView = nil;
        self.barChartView = nil;
    }
    [self scrollView];
    [self lineChartView];
    [self barChartView];
    [self xAxisView];
    [self yAxisView];
    [self layoutIfNeeded];
    
    if (index) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.barChartView.barChartView.barContainerView selectedBarItemWithIndex:index.unsignedIntegerValue];
            CGFloat width = self.scrollView.bounds.size.width;
            CGFloat targetX = 30.f * index.floatValue;
            if (targetX > self.scrollView.contentSize.width - width/2.f) {
                targetX = self.scrollView.contentSize.width - width/2.f;
            }
            if (targetX < width) {
                targetX = width/2.f;
            }
            [self.scrollView setContentOffset:CGPointMake(targetX - width/2.f, 0) animated:NO];
        });
    }
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

- (XLineChart *)lineChartView {
    if (!_lineChartView) {
        NSMutableArray* itemArray = [[NSMutableArray alloc] init];

        NSMutableArray* numbersArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
        NSMutableArray *descriptionArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
        NSNumber *maxY = @10;
        //点的数据
        for (NSDictionary *dict in self.dataArray) {
            NSNumber *numWord = dict[@"costTime"];
            [numbersArray addObject:numWord];
            [descriptionArray addObject:@""];//不显示X轴标题
            //获得最高的Y轴值
            if ([numWord compare:maxY] == NSOrderedDescending) {
                maxY = numWord;
            }
        }

        //数据和颜色
        XLineChartItem* item =
        [[XLineChartItem alloc] initWithDataNumberArray:numbersArray
                                                  color:UIColor.whiteColor];
        [itemArray addObject:item];

        XNormalLineChartConfiguration* configuration =
        [[XNormalLineChartConfiguration alloc] init];
        configuration.lineMode = CurveLine;
        configuration.numberLabelColor = UIColor.redColor;
        configuration.isScrollable = NO;
        configuration.isShowAuxiliaryDashLine = NO;
        configuration.chartBackgroundColor = UIColor.clearColor;
        configuration.isDisableTouch = YES;
        configuration.isShowShadow = NO;
        XLineChart* lineChart =
        [[XLineChart alloc] initWithFrame:CGRectMake(0, 0, 1000, self.screenViewHeight * 0.4f)
                            dataItemArray:itemArray
                        dataDiscribeArray:descriptionArray
                                topNumber:maxY
                             bottomNumber:@0
                                graphMode:MutiLineGraph
                       chartConfiguration:configuration];
        [self.scrollView addSubview:lineChart];
        lineChart.backgroundColor = UIColor.clearColor;
        _lineChartView = lineChart;
    }
    return _lineChartView;
}

- (XBarChart *)barChartView {
    if (!_barChartView) {
        NSMutableArray<XBarItem *>* itemArray = [[NSMutableArray alloc] init];

        //数据准备
        NSNumber *maxY = @10;
        for (NSDictionary *dict in self.dataArray) {
            NSDate *date = dict[@"date"];
            NSNumber *numWord = dict[@"numWord"];
            if ([numWord compare:maxY] == NSOrderedDescending) {
                maxY = numWord;
            }
            XBarItem* item = [[XBarItem alloc] initWithDataNumber:numWord color:[UIColor whiteColor] dataDescribe:[NSString stringWithFormat:@"%ld", date.day]];
            [itemArray addObject:item];
        }
        //配置文件
        XBarChartConfiguration *configuration = [XBarChartConfiguration new];
        configuration.isScrollable = NO;
        configuration.x_width = 10;
        //选中后显示渐变色
        configuration.selectedColor = @[ (__bridge id)UIColorOfHex(0xFDFCA3).CGColor, (__bridge id)UIColorOfHex(0xFDFCA3).CGColor];
        XBarChart* barChart = [[XBarChart alloc] initWithFrame:CGRectMake(0, self.screenViewHeight * 0.4f, 1000, self.screenViewHeight * 0.6f)
                           dataItemArray:itemArray
                               topNumber:maxY
                            bottomNumber:@(0)
                      chartConfiguration:configuration];
        barChart.barChartDeleagte = self;
        [self.scrollView addSubview:barChart];
        barChart.backgroundColor = UIColor.clearColor;
        _barChartView = barChart;
    }
    return _barChartView;
}

- (UIView *)xAxisView {
    if (!_xAxisView) {
        _xAxisView = [[UIView alloc] init];
        _xAxisView.backgroundColor = UIColorOfHex(0x57d7f3);
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
        _yAxisView.backgroundColor = UIColorOfHex(0x57d7f3);
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

#pragma mark XBarChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)idx {
    if (self.delegate) {
        [self.delegate updateCalendarWithDate:idx];
    }
}

@end
