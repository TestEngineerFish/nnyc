//
//  YXPreviousListViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXRankListBaseViewController.h"

@interface YXRankListBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YXRankListBaseViewController
{
    UITableView *_tableView;
    UIView *_headView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self tableView];
    
    [self setupTableView];
}

- (void)setupTableView {
    NSDictionary *registerCellDictionary = [self registerCellDictionary];
    [registerCellDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (key && obj) {
            [self.tableView registerClass:obj forCellReuseIdentifier:key];
        }
    }];
}

- (NSDictionary *)registerCellDictionary {
    return @{};
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self descover_tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self descover_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self descover_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSString *)identifierOfIndexPath:(NSIndexPath *)indexPath {
    return @"";
}

- (NSInteger)descover_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)descover_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierOfIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

- (CGFloat)descover_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

#pragma mark - subviews
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [self.view addSubview:tableView];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionFooterHeight = CGFLOAT_MIN;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFLOAT_MIN)];
        tableView.backgroundColor = [UIColor whiteColor];//UIColorOfHex(0xF3F8FB);
        _tableView = tableView;
    }
    return _tableView;
}


- (UIView *)headView {
    if (!_headView) {
        UIView *headView = [[UIView alloc] init];
        self.tableView.tableHeaderView = headView;
        _headView = headView;
    }
    return _headView;
}
@end
