//
//  YXCalendarMonthSummaryView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/8.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarStudyMonthData.h"


@interface YXCalendarMonthSummaryView : UIView
- (void)updateView: (YXStudyMonthSummaryModel *)model;
@end
