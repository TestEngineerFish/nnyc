//
//  YXCareerWordListTableViewCell.h
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXCareerWordListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXCareerWordListTableViewCell : UITableViewCell

@property (nonatomic, strong) YXCareerWordListModel *wordListModel;

@property (nonatomic, strong) UILabel *label;

@end

NS_ASSUME_NONNULL_END
