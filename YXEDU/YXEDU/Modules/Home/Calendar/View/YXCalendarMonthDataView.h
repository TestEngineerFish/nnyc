//
//  YXCalendarMonthDataView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/8.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"
#import "YXCalendarChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarMonthDataView : UIView
@property (nonatomic, strong) UIView *screenShowView;//日历和月报的显示视图
@property (nonatomic, strong) FSCalendar *calendarView;//日历组件
@property (nonatomic, strong) YXCalendarChartView *chartView;//月报图表组件

+ (YXCalendarMonthDataView *)showDataView;
@end

NS_ASSUME_NONNULL_END
