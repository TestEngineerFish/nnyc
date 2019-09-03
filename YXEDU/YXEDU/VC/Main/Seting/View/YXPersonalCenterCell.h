//
//  YXPersonalCenterCell.h
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonalCenterCellType) {
    PersonalCenterCellIcon,
    PersonalCenterCellBindIcon,
    PersonalCenterCellText,
    PersonalCenterCellButton,
    PersonalCenterCellTextAndIcon,
    PersonalCenterCellIconAndText,
};

@interface YXPersonalCenterCell : UITableViewCell
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *resultLab;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *bindBtn;

@property (nonatomic, assign) PersonalCenterCellType personalCenterCellType;

@end
