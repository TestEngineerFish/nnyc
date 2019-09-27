//
//  YXBookCollectionViewCell.h
//  YXEDU
//
//  Created by yao on 2018/11/26.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXBookInfoModel.h"
static CGFloat const kYXBookIconHWScale = 1.25;
static CGFloat const kYXBookCellMargin = 15;
static CGFloat const kYXBookDescribHeiht = 66;
static CGFloat const kYXBookSectionHeaderHeight = 50;
static CGFloat const kYXBookSectionFooterHeight = 6;

@interface YXBookCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)YXBookInfoModel *bookModel;
@property (nonatomic, readonly, strong) UIImageView *bookIcon;
- (void)selectedSuccessed:(BOOL)isSuccess;
@end

