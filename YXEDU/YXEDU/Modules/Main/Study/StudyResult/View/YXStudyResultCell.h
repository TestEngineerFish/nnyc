//
//  YXStudyResultCell.h
//  YXEDU
//
//  Created by Jake To on 11/2/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXStudyResultModel.h"
@interface YXStudyResultCell : UITableViewCell

@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UILabel *phoneticLabel;
@property (nonatomic, strong) UILabel *meanLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) YXStudiedWordBrefInfo *swbInfo;
@end

