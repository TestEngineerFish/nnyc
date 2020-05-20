//
//  YXCalendarViewController.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "BSRootVC.h"

@protocol YXCalendarUpdateData <NSObject>

@optional
- (void)updateCalendarWithDate:(NSInteger)idx;
- (void)updateChartWithDate:(NSDate *)date;

@end

@interface YXCalendarViewController : BSRootVC

@end

