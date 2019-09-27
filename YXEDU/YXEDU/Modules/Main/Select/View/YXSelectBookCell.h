//
//  YXSelectBookCell.h
//  YXEDU
//
//  Created by yao on 2018/10/12.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXSelectBookCell : UITableViewCell
@property (nonatomic, readonly, strong)UIImageView *bookIcon;
@property (nonatomic, readonly, strong)UIView *bookContent;
@property (nonatomic, readonly, strong)UILabel *bookNameL;
@property (nonatomic, readonly, strong)UILabel *totolWordL;
@property (nonatomic, readonly, strong)UILabel *studyStatusL;
@property (nonatomic, readonly, weak) UIImageView *selImageView;
@end

NS_ASSUME_NONNULL_END
