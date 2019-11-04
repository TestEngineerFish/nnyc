//
//  YXDescoveryViewController.m
//  YXEDU
//
//  Created by yao on 2018/12/21.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXDescoveryViewController.h"
#import "YXWordsChallengeCell.h"
#import "YXRangeListCell.h"
#import "YXPreviousListViewController.h"
#import "YXDescoverBlankCell.h"
#import "YXZoomBanner.h"
#import "YXDescoverModel.h"
#import "YXBaseWebViewController.h"
#import "YXRefreshView.h"
#import "YXRefreshNormalHeader.h"
#import "YXShareChallengeRankView.h"

#import "YXGameViewController.h"
#import "YXGameDetailModel.h"
#import "YXGameResultViewController.h"

#import "YXRouteManager.h"
#import "YXRouteManager.h"
#import "YXSearchView.h"
#import "YXSearchVC.h"

static NSString *const kYXWordsChallengeCellID = @"YXWordsChallengeCellID";
static NSString *const kYXRangeListCellID = @"YXRangeListCellID";
static NSString *const kYXChallengeUserCellID = @"YXChallengeUserCellID";
static NSString *const kYXMyChallengeCellID = @"YXMyChallengeCellID";
static NSString *const kYXDescoverBlankCellID = @"YXDescoverBlankCellID";

#define kHeaderViewHeight AdaptSize(230)
static CGFloat const kBlankCellHeight = 350.f;
static CGFloat const kRefreshViewHeight = 60;
static NSInteger const kBankRows = 1;
static NSInteger const kNonBlankDefultRows = 3;

@interface YXDescoveryViewController ()<YXWordsChallengeCellDelegate,YXZoomBannerDelegate,UIScrollViewDelegate>
@property (nonatomic, weak) YXZoomBanner *banner;
@property (nonatomic, strong) YXDescoverModel *descoverModel;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, weak) YXShareChallengeRankView *shareView;

@property (nonatomic, weak) YXRefreshView *refreshView;
@property (nonatomic, weak) YXRefreshNormalHeader *mjRefresher;
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger leftSeconds;
@property (nonatomic, weak) YXSearchView *searchView;


@end

@implementation YXDescoveryViewController
- (NSDictionary *)registerCellDictionary {
    return @{
             kYXChallengeUserCellID  : [YXChallengeUserCell class],
             kYXMyChallengeCellID    : [YXMyChallengeCell class],
             kYXWordsChallengeCellID : [YXWordsChallengeCell class],
             kYXRangeListCellID      : [YXRangeListCell class],
             kYXDescoverBlankCellID  : [YXDescoverBlankCell class]
             };
}

- (void)setupTableView {
    [super setupTableView];
    [kNotificationCenter addObserver:self selector:@selector(loginOut) name:kLogoutNotify object:nil];
//    [kNotificationCenter addObserver:self selector:@selector(refreshDescoverData) name:kReloadRankNotify object:nil];
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight);
    self.headView.backgroundColor = UIColorOfHex(0xDCF2FF);
    [self banner];
    UIImageView *bannerArcImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bannerArcImage"]];
    [self.headView addSubview:bannerArcImage];
    CGFloat bannerArcH = AdaptSize(15);
    bannerArcImage.frame = CGRectMake(0, self.headView.height - bannerArcH, SCREEN_WIDTH, bannerArcH);
    self.pageControl.frame = CGRectMake(0, bannerArcImage.top - 10, SCREEN_WIDTH, 10);
    
    [self mjRefresher];
    [self headView];
    [self searchView];

    self.leftSeconds = 2000;
    [self setupTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self refreshDescoverData];
    [self checkPasteboard];
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}
#pragma mark - handleData
- (void)refreshDescoverData {
    
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DIMAIN_DESCOVERINDEX
                  modelClass:[YXDescoverModel class]
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
    {
        [UIView animateWithDuration:0.5 animations:^{
            [weakSelf.searchView setHidden:NO];
        } completion:^(BOOL finished) {
        }];
        
        
        [weakSelf.mjRefresher endRefreshing];
        if (result) {
            [weakSelf refreshView:response.responseObject];
            [self hideNoNetWorkView];
        }else {
            if (response.error.type == kBADREQUEST_TYPE) {
                [weakSelf showNoNetWorkView:^{
                    [weakSelf refreshDescoverData];
                }];
            }
        }
    }];
}

#pragma mark - refresh View
- (void)refreshView:(YXDescoverModel *) descoverModel{
    self.descoverModel = descoverModel;
    if (descoverModel.bannerImageLinks.count) { // banner
        self.pageControl.numberOfPages = descoverModel.bannerImageLinks.count;
        
        self.banner.localImageNames = descoverModel.bannerImageLinks; //@[@"bannerPlaceHolder",@"banner0"];
        self.pageControl.numberOfPages = self.banner.localImageNames.count;
        self.pageControl.currentPage = 0;
    }
    
    [self.tableView reloadData];
    
    if (self.descoverModel.state == 1) { // 正常状态且在一个小时之内
        if (self.descoverModel.game.isLessAnHour) { // 还剩下一个小时
            self.leftSeconds = self.descoverModel.game.interverToGameEnd;
            [self setupTimer];
        }else {
            [self invalidateTimer];
        }
    }else {
        [self invalidateTimer];
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)descover_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.descoverModel) {
        return 0;
    }
    
    if (self.descoverModel.state == 1) {
        NSInteger rankingRows = 0;
        if (self.descoverModel.currentRankings.count > 3) {
            rankingRows += (self.descoverModel.currentRankings.count - 3);
        }
        return rankingRows + kNonBlankDefultRows;
    }else {
        return kBankRows;
    }
}

- (UITableViewCell *)descover_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super descover_tableView:tableView cellForRowAtIndexPath:indexPath];
    if (self.descoverModel.state == 1) {
        if (indexPath.row == 0) { //单词挑战
            YXWordsChallengeCell *challengeCell = (YXWordsChallengeCell *)cell;
            challengeCell.delegate = self;
            [challengeCell configWithGameModel:self.descoverModel.game
                                     gradeMode:self.descoverModel.myGrades];
        }else if(indexPath.row == 1) { //排行榜
            YXRangeListCell *rangeListCell = (YXRangeListCell *)cell;
            rangeListCell.delegate = self;
            rangeListCell.topThreeUsers = self.descoverModel.topThreeUsers;
            rangeListCell.rightLabel.hidden = !self.descoverModel.preState;
        }else if(indexPath.row == 2){
            YXMyChallengeCell *myChallengeCell = (YXMyChallengeCell *)cell;
            myChallengeCell.myRankModel = self.descoverModel.myGrades;
            myChallengeCell.shareBlock = ^{
                [self showShareView];
            };
        }else {
            YXChallengeUserCell *userCell = (YXChallengeUserCell *)cell; // 从第三组开始三名以外排名
            userCell.userRankModel = self.descoverModel.currentRankings[indexPath.row];// + 1 - kNonBlankDefultRows
        }
    }else { // 空 cell
        YXDescoverBlankCell *blankCell = (YXDescoverBlankCell *)cell;
        blankCell.rightLabel.hidden = !self.descoverModel.preState;
        [blankCell configGameName:self.descoverModel.game.name
                        gameState:self.descoverModel.state];
        blankCell.delegate = self;
    }

    return cell;
    
}

- (CGFloat)descover_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.descoverModel.state == 1) { // 正常状态
        if (indexPath.row == 0) {
//            return AdaptSize(270);
            YXGameModel *game = self.descoverModel.game;
            YXMyGradeModel *myGrades = self.descoverModel.myGrades;
            if (game.needCredits != 0 && myGrades.userCredits < game.needCredits) { //不能挑战
                return AdaptSize(270);
            }else {
                return AdaptSize(250);
            }
        }else if (indexPath.row == 1) {
            return AdaptSize(270);
        } else if(indexPath.row == 2) {
            return 80;
        }else {
            return 66;
        }
    }else {
        return kBlankCellHeight;
    }
}

- (NSString *)identifierOfIndexPath:(NSIndexPath *)indexPath {
    if (self.descoverModel.state == 1) { // 正常状态
        NSInteger row = indexPath.row;
        if (row == 0) {
            return kYXWordsChallengeCellID;
        }else if(row == 1) {
            return kYXRangeListCellID;
        }else if(row ==2 ){
            return kYXMyChallengeCellID;
        }else {
            return kYXChallengeUserCellID;
        }
    }else {
        return kYXDescoverBlankCellID;
    }
}

#pragma mark - YXDescoverBaseCellDelegate
- (void)descoverBaseCellShouldCheckPreviousRangeList:(YXDescoverBaseCell *)baseCell {
    YXPreviousListViewController *previousListVC = [[YXPreviousListViewController alloc] init];
    [self.navigationController pushViewController:previousListVC animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

#pragma mark - handle banner<UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGFloat headerH = kHeaderViewHeight;

    CGFloat absOffsetY = fabs(offset.y);
    if (offset.y >= 0.01) {
        self.banner.layer.transform = CATransform3DIdentity;
        self.banner.layer.position = self.headView.center;
        
        self.refreshView.alpha = 0;
        self.refreshView.layer.transform = CATransform3DIdentity;
        self.refreshView.layer.position = CGPointMake(SCREEN_WIDTH * 0.5, kRefreshViewHeight * 0.5);
        [self.searchView setHidden:YES];
    }else {
//        [self.searchView setHidden:NO];
        CGFloat scale = absOffsetY / headerH;
        self.banner.layer.position = CGPointMake(SCREEN_WIDTH * 0.5,(headerH + offset.y) * 0.5);
        self.banner.layer.transform = CATransform3DMakeScale(scale + 1, scale + 1, 1.0);
        
        CGFloat refreshViewParkY = (kStatusBarHeight > 20) ? 30 : kStatusBarHeight;
        self.refreshView.alpha = absOffsetY / refreshViewParkY;
        if (offset.y < - refreshViewParkY) {
            self.refreshView.layer.position = CGPointMake(SCREEN_WIDTH * 0.5, kRefreshViewHeight * 0.5 + refreshViewParkY + offset.y);
        }
        
        CGFloat zoomStartY = refreshViewParkY + 10;
        if (offset.y > - zoomStartY) { // trans
            CGFloat scale = (absOffsetY + zoomStartY) / kRefreshViewHeight;
            self.refreshView.layer.transform = CATransform3DMakeScale(scale , scale, 1.0);//CGAffineTransformMakeScale(scale, scale);
        }
        
        if (offset.y > -64) {
            self.refreshView.currentImageIndex = (absOffsetY / kRefreshViewHeight) * 10;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [UIView animateWithDuration:0.5 animations:^{
        [self.searchView setHidden:YES];
    } completion:^(BOOL finished) {
    }];
    [self.banner invalidateTimer]; // 释放timer
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (!self.mjRefresher.isRefreshing){
//        [UIView animateWithDuration:0.5 animations:^{
//            [self.searchView setHidden:NO];
//        } completion:^(BOOL finished) {
//        }];
//    }
    
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y >= 0.01) {
        self.banner.layer.transform = CATransform3DIdentity;
        self.banner.layer.position = self.headView.center;
        
        self.refreshView.alpha = 0;
        self.refreshView.layer.transform = CATransform3DIdentity;
        self.refreshView.layer.position = CGPointMake(SCREEN_WIDTH * 0.5, kRefreshViewHeight * 0.5);
        [self.searchView setHidden:YES];
    }
    else {
        [self.searchView setHidden:NO];
    }    
    [self.banner setupTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.mjRefresher.isRefreshing){
        
    }
    [self.banner setupTimer];
}

- (void)zoomBanner:(YXZoomBanner *)zoomBanner didSelectItemAtIndex:(NSInteger)index {
    YXDescoverBannerModel *banner = [self.descoverModel.banners objectAtIndex:index];
    if (banner) {
        [[YXRouteManager shared] openUrl:banner.url title:banner.title];
    }
}

- (void)zoomBanner:(YXZoomBanner *)zoomBanner didScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
}

#pragma mark - play games
- (void)wordsChallengeCellTapChallenge:(YXWordsChallengeCell *)cell {
    NSDictionary *param = @{@"gameId" : self.descoverModel.game.gameId};
    [YXUtils showProgress:self.view];
    [YXDataProcessCenter GET:DIMAIN_GAMEAVAIABLE parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSInteger state = [[response.responseObject objectForKey:@"state"] integerValue];
            if (state == 0) {
                [YXUtils hideHUD:self.view];
                [YXUtils showHUD:self.view title:@"你的积分不足，无法参与挑战"];
            }else if(state == 1 ) {
                [self requestGameDetailInfo];
            }else if(state == 2) {
                [YXUtils showHUD:self.view title:@"未选择词书"];
                [YXUtils hideHUD:self.view];
            }
        }else {
            [YXUtils hideHUD:self.view];
        }
    }];
}

- (void)requestGameDetailInfo {
//    [[YXRouteManager shared] openUrl:@"nnyc://main/home?type=main" title:nil];
//    YXGameResultViewController *resVC = [[YXGameResultViewController alloc] init];
//    [self.navigationController pushViewController:resVC animated:YES];
//    return;
    NSDictionary *param = @{@"gameId" : self.descoverModel.game.gameId};
    [YXDataProcessCenter GET:DIMAIN_GAMESTART
                  modelClass:[YXGameDetailModel class]
                  parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
                      if (result) {
                          YXGameViewController *gameVC =[[YXGameViewController alloc] init];
                          gameVC.gameModel = self.descoverModel.game;
                          gameVC.gameDetail = response.responseObject;
                        
                          self.hidesBottomBarWhenPushed = YES;
                          [self.navigationController pushViewController:gameVC animated:YES];
                          self.hidesBottomBarWhenPushed = NO;
                      }
                      [YXUtils hideHUD:self.view];
                  }];
}

#pragma mark - searchView

- (YXSearchView *)searchView{
    if (!_searchView) {
        //苹果X发现页搜索上移
        float height = 0.0;
        if (kIsIPhoneXSerious){
            height = 0.0;
        }
        else{
            height = 5.0;
        }
        YXSearchView *searchView = [[YXSearchView alloc]initWithFrame:CGRectMake(AdaptSize(15), AdaptSize(kStatusBarHeight)+height,SCREEN_WIDTH-2*AdaptSize(15) , AdaptSize(37))];
        [self.view addSubview:searchView];
        _searchView = searchView;
        
        //创建手势 使用initWithTarget:action:的方法创建
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
        
        //设置属性
        //tap 手势一共两个属性，一个是设置轻拍次数，一个是设置点击手指个数
        //设置轻拍次数
        tap.numberOfTapsRequired = 1;
        //设置手指字数
        tap.numberOfTouchesRequired = 1;
        
        //别忘了添加到View上
        [_searchView addGestureRecognizer:tap];
        
    }
    return _searchView;
}

-(void)tapView{
    NSLog(@"tapView");
    YXSearchVC *VC =  [[YXSearchVC alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
}

#pragma mark - banner
- (YXZoomBanner *)banner {
    if (!_banner) {
        YXZoomBanner *banner = [[YXZoomBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kHeaderViewHeight)];
        banner.delegate = self;
        [self.headView addSubview:banner];
        _banner = banner;
    }
    return _banner;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.currentPageIndicatorTintColor = UIColorOfHex(0x69BEFB);
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        [self.headView addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
}

- (YXRefreshNormalHeader *)mjRefresher {
    if (!_mjRefresher) {
        YXRefreshNormalHeader *header = [YXRefreshNormalHeader headerWithRefreshingTarget:self
                                                                         refreshingAction:@selector(refreshDescoverData)];
        self.tableView.mj_header = header;
        header.delegate = self.refreshView;
        _mjRefresher = header;
    }
    return _mjRefresher;
}

- (YXRefreshView *)refreshView {
    if (!_refreshView) {
        YXRefreshView *refreshView = [[YXRefreshView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kRefreshViewHeight)];
        refreshView.alpha = 0;
        [self.headView addSubview:refreshView];
        _refreshView = refreshView;
    }
    return _refreshView;
}

- (YXShareChallengeRankView *)shareView {
    if (!_shareView) {
        YXShareChallengeRankView *view = [[YXShareChallengeRankView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kWindow.height - kSafeBottomMargin)];
        view.descoverModel = self.descoverModel;
        [kWindow addSubview:view];
        _shareView = view;
    }
    return _shareView;
}

#pragma mark - 定时器
- (void)setupTimer {
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)countDown {
    if (self.descoverModel.state !=1 ) {
        [self invalidateTimer];
        return;
    }
    self.leftSeconds --;
    NSInteger leftSeconds = self.leftSeconds;
    if(self.leftSeconds <= 0){
        [self invalidateTimer];
        leftSeconds = 0;
    }
    
    [self.descoverModel.game updateTimeStampAttriString:[self countAttributeWith:leftSeconds]];
    // 刷新表格
    YXWordsChallengeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.rightLabel.attributedText = self.descoverModel.game.timeStampAttriString;
}

- (NSAttributedString *)countAttributeWith:(NSInteger)leftSeconds {
    NSInteger hour = leftSeconds / 3600;
    NSInteger minute = leftSeconds / 60;
    NSInteger second = leftSeconds % 60;
    NSString *countDownStr = [NSString stringWithFormat:@"剩余时间%02zd:%02zd:%02zd",hour,minute,second];
    
    NSString *descString = [NSString stringWithFormat:@"本期挑战%@",countDownStr];
    NSDictionary *attributes = self.descoverModel.game.timeStampAttributes;
    NSMutableAttributedString *desAttriString = [[NSMutableAttributedString alloc] initWithString:descString
                                                                                       attributes:attributes];
    NSRange stampRange = [descString rangeOfString:countDownStr];
    [desAttriString addAttribute:NSForegroundColorAttributeName value:UIColorOfHex(0xFD9725) range:stampRange];
    return [desAttriString copy];
}

- (void)invalidateTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)loginOut {
    [self invalidateTimer];
}

#pragma mark Event
- (void)showShareView {
    [self.shareView showWithAnimate];
}

@end


























/** 解决底部留白 两种方式
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
 return [[UIView alloc] init];
 }
 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 return 0.01;
 }
 
 tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
 */
