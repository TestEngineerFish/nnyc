//
//  YXMaterialCell.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^deleteResBlock) (id obj);
@interface YXMaterialCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *resultLab;
@property (nonatomic, copy) deleteResBlock delBlock;
@end
