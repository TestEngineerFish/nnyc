//
//  YXMaterialCell.h
//  YXEDU
//
//  Created by shiji on 2018/6/1.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^deleteBlock) (id obj);

@interface YXPersonalMaterialCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *sizeLabel;

@property (nonatomic, copy) deleteBlock deleteBlock;
@end
