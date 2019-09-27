//
//  YXMyWordBookCell.h
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXMyWordBookModel.h"
NS_ASSUME_NONNULL_BEGIN
@class YXMyWordBookCell;

@protocol YXMyWordBookCellDelegate <NSObject>
- (void)myWordBookCellManageBtnClicked:(YXMyWordBookCell *)myWordBookCell;
- (void)myWordBookCellStudyBtnClicked:(YXMyWordBookCell *)myWordBookCell;
- (void)myWordBookCellListenBtnClicked:(YXMyWordBookCell *)myWordBookCell;
@end

@interface YXMyWordBookCell : UITableViewCell
@property (nonatomic, weak) id<YXMyWordBookCellDelegate> delegate;
@property (nonatomic, assign) BOOL switchToManage;
@property (nonatomic, strong) YXMyWordBookModel *myWordBookModel;
@property (nonatomic, assign) BOOL selectState;
- (void)clickManageBtn;
@end

NS_ASSUME_NONNULL_END
