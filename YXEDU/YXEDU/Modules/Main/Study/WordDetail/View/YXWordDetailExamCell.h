//
//  YXWordDetailExamCell.h
//  YXEDU
//
//  Created by jukai on 2019/5/14.
//  Copyright © 2019 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXWordDetailExamCell : UITableViewCell

@property (nonatomic, weak)UIImageView *bgView;
@property (nonatomic, weak)UILabel *titleL;
@property (nonatomic, weak)UILabel *contentL;
@property (nonatomic, weak)UILabel *freL;//频率点数
@property (nonatomic, weak)UIButton *openBtn;
@property (nonatomic, assign)BOOL isOpenCell;

@end

NS_ASSUME_NONNULL_END
