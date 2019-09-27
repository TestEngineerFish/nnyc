//
//  YXArticleUnitCell.h
//  YXEDU
//
//  Created by jukai on 2019/5/30.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXArticleUnitCell : UITableViewCell

@property (nonatomic, weak)UIImageView *bgView;
@property (nonatomic, weak)UILabel *titleL;
@property (nonatomic, weak)UILabel *bookL;
@property (nonatomic, weak)UILabel *progressL;

@end

NS_ASSUME_NONNULL_END
