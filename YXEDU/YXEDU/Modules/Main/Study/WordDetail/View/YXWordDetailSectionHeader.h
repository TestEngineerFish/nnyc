//
//  YXWordDetailSectionHeader.h
//  YXEDU
//
//  Created by yao on 2018/10/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWordDetailSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, copy)NSString *title;
@property (nonatomic, weak)UILabel *titleL;
@property (nonatomic, weak)UILabel *verticalL;

@end

NS_ASSUME_NONNULL_END
