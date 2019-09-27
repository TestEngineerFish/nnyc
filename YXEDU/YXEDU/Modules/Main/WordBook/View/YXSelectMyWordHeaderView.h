//
//  YXSelectMyWordHeaderView.h
//  YXEDU
//
//  Created by yao on 2019/2/21.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBookCategoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXMyWordBaseHeaderView : UITableViewHeaderFooterView
@property (nonatomic, readonly, weak) UIView *seprateLine;
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@property (nonatomic, readonly, weak) UILabel *progressLabel;
@end


@interface YXSelectMyWordHeaderView : YXMyWordBaseHeaderView
@property (nonatomic, readonly, weak) UIImageView *openIndicator;
@property (nonatomic, strong) YXBookUnitContentModel *unitModel;
@property (nonatomic, copy) void(^headerViewTapedBlock)(void);
- (void)updateInfo;
@end

NS_ASSUME_NONNULL_END
