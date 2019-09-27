//
//  YXPreviousListViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/24.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXPreviousListViewController.h"
#import "YXDescoverTitleView.h"
#import "YXPreviousChallengeCell.h"
#import "YXPreviousRankModel.h"
static NSString *const kYXPreviousChallengeCellID = @"YXPreviousChallengeCellID";
@interface YXPreviousListViewController ()
@property (nonatomic, weak)YXMyChallengeCell *myChallengeView;
@property (nonatomic, weak)YXDescoverTitleView *titleView;
@property (nonatomic, strong) YXPreviousRankModel *previousRankModel;
@end

@implementation YXPreviousListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupTableView {
    [super setupTableView];
    self.title = @"上期排行榜";
    self.headView.backgroundColor = [UIColor whiteColor];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 145);
    YXMyChallengeCell *myChallengeView = [[YXMyChallengeCell alloc] init];
    myChallengeView.frame = CGRectMake(0, 15, SCREEN_WIDTH, 80);
    [self.headView addSubview:myChallengeView];
    _myChallengeView = myChallengeView;
    
    CGFloat margin = AdaptSize(15);
    YXDescoverTitleView *titleView = [[YXDescoverTitleView alloc] initWithFrame:CGRectMake(margin, 120, SCREEN_WIDTH - 2 *margin, 17)];
    titleView.titleLabel.text = @"2018-11-11 期排行榜";
    [self.headView addSubview:titleView];
    _titleView = titleView;
    
    [self refreshPreviousData];
}

- (NSDictionary *)registerCellDictionary {
    return @{ kYXPreviousChallengeCellID  : [YXPreviousChallengeCell  class] };
}

#pragma mark - handleData
- (void)refreshPreviousData {
    __weak typeof(self) weakSelf = self;
    [self showLoadingView];
    [YXDataProcessCenter GET:DIMAIN_PREVIOUSRANKING
                  modelClass:[YXPreviousRankModel class]
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         [self hideLoadingView];
         if (result) {
             weakSelf.previousRankModel = response.responseObject;
             [weakSelf refreshView];
             [self hideNoNetWorkView];
         }else {
             if (response.error.type == kBADREQUEST_TYPE) {
                 [weakSelf showNoNetWorkView:^{
                     [weakSelf refreshPreviousData];
                 }];
             }
         }
     }];
}

- (void)refreshView {
    self.titleView.titleLabel.text = self.previousRankModel.title;
    self.myChallengeView.preRankModel = self.previousRankModel.myGrades;
    [self.tableView reloadData];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)descover_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.previousRankModel.currentRankings.count;
}

- (UITableViewCell *)descover_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXPreviousChallengeCell *cell = (YXPreviousChallengeCell *)[super descover_tableView:tableView cellForRowAtIndexPath:indexPath];
    cell.userRankModel = self.previousRankModel.currentRankings[indexPath.row];
    return cell;
}

- (CGFloat)descover_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSString *)identifierOfIndexPath:(NSIndexPath *)indexPath {
    return kYXPreviousChallengeCellID;
}
@end
