//
//  YXCalendarChartView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarViewController.h"

@interface YXCalendarChartView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<YXCalendarUpdateData> delegate;

- (void)setDataArray:(NSArray<NSDictionary *> *)dataArray selected:(NSNumber *)index;
@end

