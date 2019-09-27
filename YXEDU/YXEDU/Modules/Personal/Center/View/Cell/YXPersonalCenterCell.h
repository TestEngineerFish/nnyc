//
//  YXPersonalCenterCell.h
//  YXEDU
//
//  Created by Jake To on 10/13/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXPersonalCenterCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalCenterCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UIImageView *accessoryImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YXPersonalCenterCellModel *model;

@end

NS_ASSUME_NONNULL_END
