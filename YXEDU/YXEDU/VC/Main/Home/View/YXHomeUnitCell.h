//
//  YXHomeUnitCell.h
//  YXEDU
//
//  Created by shiji on 2018/6/2.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXHomeUnitCell : UITableViewCell
@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UILabel *startLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *unitLab;
@property (nonatomic, strong) UILabel *haveLearnLab;
@property (nonatomic, strong) UIView *progressYellowView;
@property (nonatomic, strong) UIImageView *flowerImageView;
- (void)insertModel:(id)model;
@end
