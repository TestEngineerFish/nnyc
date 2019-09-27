//
//  YXMyWordBookBaseVC.h
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXWordBookBaseVC.h"
#import "MyWordBookDefine.h"
#import "YXMyWordBaseCell.h"
#import "YXMyWordDetailCell.h"
#import "YXSelectMyWordHeaderView.h"
#import "YXChangeWordlistNameView.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * const ReuseIdentifierKey = @"CellReuseIdentifierKey";
static NSString * const ReuseClassKey = @"ReuseClassKey";
@interface YXMyWordBookBaseVC : YXWordBookBaseVC <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readonly, weak) UIView *bgView;
@property (nonatomic, readonly, weak) UITableView *wordListTableView;
@property (nonatomic, readonly, weak) UIView *bottomView;
@property (nonatomic, readonly, weak) UIButton *rightBarItemBtn;
@property (nonatomic, readonly, weak) UIButton *changeNameBtn;

- (void)showChangeNameViewWithDefaultName:(NSString *)defName;

- (nonnull NSDictionary *)registerCellInfo;
- (NSDictionary *)registerSectionHeaderInfo;
- (NSArray *)rightBarItemImages;
- (void)rightBarItemClick:(UIButton *)btn;
- (void)changeWordListName;
@end

NS_ASSUME_NONNULL_END
