//
//  YXCalendarFresherGuideView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/5/5.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXCalendarFresherGuideView;
@protocol YXCalendarFresherGuideViewDelegate <NSObject>
- (CGRect)fresherGuideViewBlankArea:(YXCalendarFresherGuideView *)frensherView stepIndex:(NSInteger)step;
- (void)stepPrecondition:(NSInteger)step;
@end

@interface YXCalendarFresherGuideView : UIView
@property (nonatomic, weak) id<YXCalendarFresherGuideViewDelegate> delegate;
@property (nonatomic, readonly, assign) NSInteger step;
+ (YXCalendarFresherGuideView *)showGuideViewToView:(UIView *)view delegate: (id<YXCalendarFresherGuideViewDelegate>)delegate;
+ (BOOL)isFresherGuideShowed;
@end
