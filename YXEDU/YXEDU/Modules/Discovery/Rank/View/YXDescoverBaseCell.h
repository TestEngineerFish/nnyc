//
//  YXDescoverBaseCell.h
//  YXEDU
//
//  Created by yao on 2018/12/22.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXDescoverTitleView.h"

@class YXDescoverBaseCell;
@protocol YXDescoverBaseCellDelegate <NSObject>
- (void)descoverBaseCellShouldCheckPreviousRangeList:(YXDescoverBaseCell *)baseCell;
@end



@interface YXDescoverBaseCell : UITableViewCell
@property (nonatomic, weak)id<YXDescoverBaseCellDelegate> delegate;
@property (nonatomic, weak)YXDescoverTitleView *titleView;
@property (nonatomic, weak)UIImageView *bgImageView;
@property (nonatomic, weak)UILabel *rightLabel;
- (void)setupSubviews;
- (BOOL)rightLabelCanReceiveClick;
@end

