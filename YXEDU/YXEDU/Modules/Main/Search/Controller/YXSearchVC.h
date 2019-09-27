//
//  YXSearchVC.h
//  YXEDU
//
//  Created by jukai on 2019/4/12.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "BSRootVC.h"

NS_ASSUME_NONNULL_BEGIN
//搜索
@interface YXSearchVC : BSRootVC<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readonly, weak) UIView *bgView;
@property (nonatomic, readonly, weak) UITableView *wordListTableView;
@end

NS_ASSUME_NONNULL_END
