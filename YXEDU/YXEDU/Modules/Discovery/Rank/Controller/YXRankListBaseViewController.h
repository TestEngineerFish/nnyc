//
//  YXPreviousListViewController.h
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSRootVC.h"
#import "YXChallengeUserCell.h"
#import "YXMyChallengeCell.h"

@interface YXRankListBaseViewController : BSRootVC
@property (nonatomic,readonly, strong)UITableView *tableView;
@property (nonatomic,readonly, strong)UIView *headView;

- (void)setupTableView;
- (NSString *)identifierOfIndexPath:(NSIndexPath *)indexPath;
- (NSDictionary *)registerCellDictionary;

- (NSInteger)descover_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)descover_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)descover_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end

