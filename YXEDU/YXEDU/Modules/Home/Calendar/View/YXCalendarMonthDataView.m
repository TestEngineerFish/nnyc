//
//  YXCalendarMonthDataView.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/8.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarMonthDataView.h"

@interface YXCalendarMonthDataView()
@property (nonatomic, strong) UIView *calendarStatusView; // 日历状态栏
@property (nonatomic, strong) UIView *chartStatusView; // 图表状态栏
@end

@implementation YXCalendarMonthDataView

+ (YXCalendarMonthDataView *)showDataView {
    YXCalendarMonthDataView *view = [[YXCalendarMonthDataView alloc] init];
    return view;
}

- (UIView *)screenShowView {
    if (!_screenShowView) {
        UIView *screenShowView = [[UIView alloc] init];
        screenShowView.backgroundColor = UIColor.clearColor;
        _screenShowView = screenShowView;
    }
    return  _screenShowView;
}

//日历组件
- (FSCalendar *)calendarView
{
    if (!_calendarView) {
        FSCalendar *calendarView = [[FSCalendar alloc] init];
        calendarView.headerHeight                     = 0.f;
        calendarView.scrollDirection                  = FSCalendarScrollDirectionHorizontal;
        calendarView.backgroundColor                  = UIColor.whiteColor;
        calendarView.appearance.weekdayTextColor      = UIColorOfHex(0xC0C0C0);
        calendarView.appearance.weekdayFont           = [UIFont mediumFontOfSize:12];
        calendarView.appearance.titleDefaultColor     = UIColorOfHex(0x323232);
        calendarView.appearance.titleTodayColor       = UIColorOfHex(0xFBA217);
        calendarView.appearance.todayColor            = UIColor.clearColor;
        calendarView.appearance.borderSelectionColor  = UIColorOfHex(0xFBA217);
        calendarView.appearance.selectionColor        = UIColor.clearColor;
        calendarView.appearance.titlePlaceholderColor = UIColorOfHex(0xDCDCDC);
        calendarView.weekdayHeight                    = AdaptSize(50.f);
        calendarView.locale                           = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        calendarView.appearance.titleFont             = [UIFont systemFontOfSize:AdaptSize(16.f)];
        _calendarView = calendarView;
    }
    return _calendarView;
}

// 图表组件
- (UIView *)chartView {
    if (!_chartView) {
        YXCalendarChartView *chartView = [[YXCalendarChartView alloc] init];
        chartView.backgroundColor = UIColor.clearColor;
        _chartView = chartView;
    }
    return _chartView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 添加日历和图表容器视图
        [self addSubview:self.screenShowView];
        // 添加日历视图
        [self.screenShowView addSubview:self.calendarView];
        // 添加日历状态栏
        [self.screenShowView addSubview:self.calendarStatusView];
        // 添加图表视图
        [self.screenShowView addSubview:self.chartView];
        // 添加图表状态栏
        [self.screenShowView addSubview:self.chartStatusView];

        [self.screenShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.height.equalTo(self);
            make.width.equalTo(self).multipliedBy(2.f);
        }];

        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.screenShowView);
            make.width.equalTo(self);
            
            if (isPad()) {
                make.height.equalTo(self).with.offset(AdaptSize(-200.f));

            } else {
                make.height.equalTo(self).with.offset(AdaptSize(-100.f));
            }
        }];

        [self.calendarStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.calendarView.mas_right).with.offset(-20);
            make.top.equalTo(self.calendarView.mas_bottom).with.offset(25.f);
            make.height.mas_equalTo(15.f);
        }];

        [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.calendarView.mas_right);
            make.top.equalTo(self);
            make.width.equalTo(self);
            make.height.equalTo(self.calendarView);
        }];

        [self.chartStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.chartView.mas_right).with.offset(-20);
            make.top.equalTo(self.chartView.mas_bottom).with.offset(25.f);
            make.height.mas_equalTo(15.f);
        }];
    }
    return self;
}

//日历状态栏
- (UIView *)calendarStatusView {
    if (!_calendarStatusView) {
        UIView *statusView = [[UIView alloc] init];
        statusView.backgroundColor = UIColor.clearColor;

        UIImageView *studiedIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"calendar_icon_learned"]];
        [statusView addSubview:studiedIcon];
        [studiedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusView);
            make.centerY.equalTo(statusView);
            make.size.mas_equalTo(CGSizeMake(10.f, 10.f));
        }];

        UILabel *studiedLabel = [[UILabel alloc] init];
        studiedLabel.text = @"已学习";
        studiedLabel.font = [UIFont systemFontOfSize:13];
        studiedLabel.textColor = UIColorOfHex(0x4F4F4F);
        studiedLabel.layer.shadowColor = UIColor.blackColor.CGColor;
        studiedLabel.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        [statusView addSubview: studiedLabel];
        [studiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(studiedIcon.mas_right).with.offset(5.f);
            make.centerY.equalTo(statusView);
        }];

        UIImageView *punchedIcon = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"calendar_icon_punched"]];
        [statusView addSubview:punchedIcon];
        [punchedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(studiedLabel.mas_right).with.offset(15);
            make.centerY.equalTo(statusView);
            make.size.mas_equalTo(CGSizeMake(12.f, 12.f));
        }];

        UILabel *punchedLabel = [[UILabel alloc] init];
        punchedLabel.text = @"完成打卡";
        punchedLabel.font = [UIFont systemFontOfSize:13];
        punchedLabel.textColor = UIColorOfHex(0x4F4F4F);
        punchedLabel.layer.shadowColor = UIColor.blackColor.CGColor;
        punchedLabel.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        [statusView addSubview: punchedLabel];
        [punchedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(punchedIcon.mas_right).with.offset(5);
            make.centerY.equalTo(statusView);
            make.right.equalTo(statusView);
        }];
        _calendarStatusView = statusView;
    }
    return _calendarStatusView;
}

// 图表状态栏
- (UIView *)chartStatusView {
    if (!_chartStatusView) {
        UIView *statusView = [[UIView alloc] init];
        statusView.backgroundColor = UIColor.clearColor;
        UIView *studiedIcon = [[UIView alloc] init];
        studiedIcon.backgroundColor = [UIColor whiteColor];
        [statusView addSubview:studiedIcon];
        [studiedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusView);
            make.centerY.equalTo(statusView);
            make.size.mas_equalTo(CGSizeMake(10.f, 10.f));
        }];

        UILabel *studiedLabel = [[UILabel alloc] init];
        studiedLabel.text = @"学习单词数";
        studiedLabel.font = [UIFont systemFontOfSize:13];
        studiedLabel.textColor = UIColor.whiteColor;
        studiedLabel.layer.shadowColor = UIColor.blackColor.CGColor;
        studiedLabel.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        [statusView addSubview: studiedLabel];
        [studiedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(studiedIcon.mas_right).with.offset(5.f);
            make.centerY.equalTo(statusView);
        }];

        UIView *timeIcon = [[UIView alloc] init];
        timeIcon.backgroundColor = UIColorOfHex(0xc1e8fd);
        [statusView addSubview:timeIcon];
        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(studiedIcon);
            make.left.equalTo(studiedLabel.mas_right).with.offset(15.f);
            make.size.mas_equalTo(CGSizeMake(15.f, 2));
        }];

        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"学习耗时";
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.textColor = UIColor.whiteColor;
        timeLabel.layer.shadowColor = UIColor.blackColor.CGColor;
        timeLabel.layer.shadowOffset = CGSizeMake(2.f, 2.f);
        [statusView addSubview: timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeIcon.mas_right).with.offset(5);
            make.centerY.equalTo(statusView);
            make.right.equalTo(statusView);
        }];
        _chartStatusView = statusView;
    }
    return _chartStatusView;
}

@end
