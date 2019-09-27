//
//  YXCalendarHeaderView.h
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/22.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCalendarStudyDayData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCalendarHeaderView : UITableViewHeaderFooterView
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIImageView *openIndicator;
@property (nonatomic, strong) NSObject *unitModel;
@property (nonatomic, strong) UIView *separatorView;
//@property (nonatomic, copy) void(^headerViewTapedBlock)(void);

- (void)setHeaderViewWithSection:(NSInteger)section data:(YXCalendarStudyDayData *)day;
@end

NS_ASSUME_NONNULL_END
