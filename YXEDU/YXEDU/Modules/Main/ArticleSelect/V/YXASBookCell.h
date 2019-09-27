//
//  YXASBookCell.h
//  YXEDU
//
//  Created by jukai on 2019/5/27.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXASBookCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UIImageView *studyFlag;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *totalArticleLab;

@end

NS_ASSUME_NONNULL_END
