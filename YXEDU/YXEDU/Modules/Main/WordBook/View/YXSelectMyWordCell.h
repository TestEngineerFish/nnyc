//
//  YXSelectMyWordCell.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBaseCell.h"
#import "YXBookCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN
@class YXSelectMyWordCell;
@protocol YXSelectMyWordCellDelegate <NSObject>
- (void)selectMyWordCellManageBtnClicked:(YXSelectMyWordCell *)selectMyWordCell;
@end


@interface YXSelectMyWordCell : YXMyWordBaseCell
@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UIButton *manageBtn;
@property (nonatomic, weak) id<YXSelectMyWordCellDelegate> delegate;
@property (nonatomic, assign) BOOL selectState;
- (void)refreshContent;
@end

NS_ASSUME_NONNULL_END
