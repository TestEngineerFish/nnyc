//
//  YXCalendarShareView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/26.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarStudyMonthData.h"

@protocol CalendarShareViewDelegate <NSObject>

- (void)closeShareViewBlock;
- (void)reloadShareData;

@end
NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarShareView : UIView
@property (nonatomic, weak) id<CalendarShareViewDelegate> delegate;
+ (YXCalendarShareView *)showCompletedViewWithMonthDate:(YXCalendarStudyMonthData *)monthData;
@end

NS_ASSUME_NONNULL_END
