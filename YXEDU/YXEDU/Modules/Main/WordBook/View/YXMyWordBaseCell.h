//
//  YXMyWordBaseCell.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXWordDetailModel.h"
#import "YXMyWordCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXMyWordBaseCell : UITableViewCell
//@property (nonatomic, strong) YXWordDetailModel *wordDetailModel;
@property (nonatomic, readonly, weak)UILabel *wordL;
@property (nonatomic, readonly, weak)UILabel *explanationL;
@property (nonatomic, strong) YXMyWordCellBaseModel *wordModel;
- (void)setUpSubviews;

@end

NS_ASSUME_NONNULL_END
