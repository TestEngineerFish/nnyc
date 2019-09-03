//
//  YXHomeVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/27.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXHomeVC.h"
#import "BSCommon.h"
#import "YXPersonalCenterVC.h"
#import "YXPersonalBookVC.h"
#import "VTMagic.h"
#import "YXHomeUnitView.h"
#import "MJRefresh.h"
#import "YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView.h"
#import "YXHomeTabView.h"
#import "YXHomeWordDetailView.h"
#import "YXHomeUnitView.h"
#import "YXHomeViewModel.h"
#import "YXUtils.h"
#import "YXUnitDetailVC.h"
#import "YXSelectBookVC.h"
#import "YXConfigure.h"
#import "YXNavigationController.h"
#import "YXMediator.h"

@interface YXHomeVC () <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,YXHomeUnitViewDelegate>
@property (nonatomic, strong) YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView *homeTable;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabView;
@property (nonatomic, assign) BOOL isTopIsCanNotMoveTabViewPre;
@property (nonatomic, strong) YXHomeWordDetailView *wordDetailView;
@property (nonatomic, strong) YXHomeViewModel *mainViewModel;
@property (nonatomic, strong) YXHomeTabView *tabView;
@end

@implementation YXHomeVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainViewModel = [[YXHomeViewModel alloc]init];
        self.coverAll = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorOfHex(0x4DB3FE);
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [leftBtn setImage:[UIImage imageNamed:@"home_personal"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.exclusiveTouch = YES;
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftImageView];
    [leftImageView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.exclusiveTouch = YES;
    [rightBtn setFrame:CGRectMake(SCREEN_WIDTH-60, 14, 38, 25)];
    [rightBtn setImage:[UIImage imageNamed:@"home_mybook"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorOfHex(0x1CB0F6) forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.wordDetailView = [[YXHomeWordDetailView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 110)];
    [self.view addSubview:self.wordDetailView];
    
    //
    self.homeTable = [[YXIgnoreHeaderTouchAndRecognizeSimultaneousTableView alloc]init];
    self.homeTable.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    self.homeTable.dataSource = self;
    self.homeTable.delegate = self;
    self.homeTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.homeTable];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 110)];
    headView.backgroundColor = [UIColor clearColor];
    self.homeTable.tableHeaderView = headView;
    [self.homeTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:@"kLeaveTopNotificationName" object:nil];
}

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}

- (void)showSelectBookView {
    if (![YXConfigure shared].loginModel.learning.bookid.length) {
        YXSelectBookVC *versionVC = [[YXSelectBookVC alloc]init];
        versionVC.transType = TransationPresent;
        YXNavigationController *nav = [[YXNavigationController alloc]initWithRootViewController:versionVC];
        [[YXMediator shared].window.rootViewController presentViewController:nav animated:NO completion:nil];
    }
}

- (void)leftBtnClicked:(id)sender {
    YXPersonalCenterVC *personalVC = [[YXPersonalCenterVC alloc]init];
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)rightBtnClicked:(id)sender {
    YXPersonalBookVC *personalVC = [[YXPersonalBookVC alloc]init];
    personalVC.transType = TransationPop;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refreshBtnClicked {
    [self refresh];
}

// 页面刷新
- (void)refresh {
    __weak YXHomeVC *weakSelf = self;
    [YXUtils showHUD:self.navigationController.view];
    [self.mainViewModel refreshMainView:^(id obj, BOOL result) {
        if (result) {
            [YXUtils hideHUD:weakSelf.navigationController.view];
            weakSelf.wordDetailView.detailLab1.text = [NSString stringWithFormat:@"%ld", (long)[weakSelf.mainViewModel getAllWord]];
            weakSelf.wordDetailView.detailLab2.text = [NSString stringWithFormat:@"%ld", (long)[weakSelf.mainViewModel getAllLearned]];
            weakSelf.title = [weakSelf.mainViewModel getTitle];
            [weakSelf.homeTable reloadData];
            [weakSelf showSelectBookView];
            weakSelf.noSignalView.hidden = YES;
        } else {
            weakSelf.noSignalView.hidden = NO;
            [YXUtils showHUD:weakSelf.view title:@"网络错误"];
            [YXUtils hideHUD:weakSelf.navigationController.view];
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(self.view.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL needAddView = YES;
    for (UIView *views in cell.contentView.subviews) {
        if (views.class == [YXHomeTabView class]) {
            needAddView = NO;
            break;
        }
    }
    if (needAddView) {
        self.tabView = [[YXHomeTabView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)
                                                              rootVC:self
                                                       rootViewModel:self.mainViewModel];
        [cell.contentView addSubview:self.tabView];
    }
    [self.tabView reloadSubViews];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat tabOffsetY = [self.homeTable rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    _isTopIsCanNotMoveTabViewPre = _isTopIsCanNotMoveTabView;
    if (offsetY>=tabOffsetY) {
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        _isTopIsCanNotMoveTabView = YES;
    }else{
        _isTopIsCanNotMoveTabView = NO;
    }
    if (_isTopIsCanNotMoveTabView != _isTopIsCanNotMoveTabViewPre) {
        if (!_isTopIsCanNotMoveTabViewPre && _isTopIsCanNotMoveTabView) {
            //NSLog(@"滑动到顶端");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kGoTopNotificationName" object:nil userInfo:@{@"canScroll":@"1"}];
            _canScroll = NO;
        }
        if(_isTopIsCanNotMoveTabViewPre && !_isTopIsCanNotMoveTabView){
            //NSLog(@"离开顶端");
            if (!_canScroll) {
                scrollView.contentOffset = CGPointMake(0, tabOffsetY);
            }
        }
    }
}

#pragma mark -YXHomeUnitViewDelegate-
- (void)didSelectedRow:(id)model {
    YXUnitDetailVC *startVC = [[YXUnitDetailVC alloc]init];
    [startVC insertModel:model];
    [self.navigationController pushViewController:startVC animated:YES];
}

- (void)changeBookBtnClicked:(id)sender {
    YXPersonalBookVC *personalVC = [[YXPersonalBookVC alloc]init];
    personalVC.transType = TransationPop;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
