//
//  YXPersonalBadgeCell.h
//  YXEDU
//
//  Created by Jake To on 10/19/18.
//  Copyright © 2018 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXPersonalBadgeCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) UILabel *badgeNameLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

NS_ASSUME_NONNULL_END
