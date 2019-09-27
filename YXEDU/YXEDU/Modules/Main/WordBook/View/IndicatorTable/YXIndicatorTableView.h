//
//  YXIndicatorTableView.h
//  YXEDU
//
//  Created by yao on 2019/2/22.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YXIndicatorTableViewCell : UITableViewCell
@property (nonatomic, readonly, weak) UIView *indicatorView;
@property (nonatomic, readonly, weak) UILabel *titleLabel;
@end


@interface YXIndicatorTableView : UITableView
- (YXIndicatorTableViewCell *)dequeueReusableIndicatorCellforIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
