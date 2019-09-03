//
//  YXGraphWordCell.h
//  YXEDU
//
//  Created by shiji on 2018/4/8.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXGraphWordCell : UITableViewCell
@property (nonatomic, strong) UILabel *wordLab;
@property (nonatomic, strong) UILabel *phoneticLab;
- (void)reloadData;
@end
