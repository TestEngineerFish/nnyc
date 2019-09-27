//
//  YXReadHistoryCell.h
//  YXEDU
//
//  Created by jukai on 2019/5/28.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXReadHistoryCell : UITableViewCell

@property (nonatomic, weak)UIImageView *bgView;
@property (nonatomic, weak)UILabel *titleL;
@property (nonatomic, weak)UILabel *bookL;
@property (nonatomic, weak)UILabel *progressL;
@property (nonatomic, weak)UILabel *lastLearnL;

@end

NS_ASSUME_NONNULL_END
