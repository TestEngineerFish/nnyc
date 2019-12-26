//
//  YXPersonalInformationCell.h
//  YXEDU
//
//  Created by Jake To on 10/12/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPersonalInformationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalInformationCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rightDetailLabel;
@property (nonatomic, strong) UIImageView *accessoryImage;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YXPersonalInformationModel *model;

@end

NS_ASSUME_NONNULL_END
