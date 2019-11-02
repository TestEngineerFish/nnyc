//
//  YXMyWordBookListVC.m
//  YXEDU
//
//  Created by yao on 2019/2/19.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookListVC.h"
#import "YXMyWordBookListBlankView.h"
#import "YXTopActionView.h"
#import "YXMyWordBookCell.h"
#import "YXMyBookFooterView.h"
#import "YXMyWordBookModel.h"
#import "YXMyWordBookDetailVC.h"
#import "YXCreateWordBookVC.h"
#import "MyWordBookDefine.h"
#import "YXWordListBaseInfo.h"
#import "YXWordBookBaseManageView.h"
#import "YXMyWordListDetailModel.h"
#import "YXWordListView.h"
#import "YXLoadingView.h"

static NSString *const kYXMyWordBookCellID = @"YXMyWordBookCellID";

@interface YXMyWordBookListVC ()<UITableViewDelegate,UITableViewDataSource,YXMyWordBookCellDelegate,YXMyWordBookActionProtocol,YXWordBookBaseManageViewDelegate>
@property (nonatomic, strong) UIButton *manageBtn;
@property (nonatomic, weak) UITableView *myBookListTableView;
@property (nonatomic, weak) YXTopActionView *tableHeaderView;
@property (nonatomic, weak) YXMyWordBookListBlankView *blankView;
@property (nonatomic, strong) NSMutableArray *myBookListData;
@property (nonatomic, strong) NSMutableArray *selmyWordBooks;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) YXSpringAnimateButton *deleteBtn;
@property (nonatomic, strong) YXWordListBaseInfo *wordListBaseInfo;
@property (nonatomic, weak) YXWordListView *wordListView;
@property (nonatomic, strong) UIButton *createBtn;
@property(nonatomic, weak) YXLoadingView *loadingAnimaterView;
@end

@implementation YXMyWordBookListVC
- (void)loadView {
    YXWordListView *view = [[YXWordListView alloc] init];
    self.wordListView = view;
    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGFloat y = self.manageBtn.selected ? self.view.height - kBottomViewHeight : self.view.height + kBottomViewHeight;
    self.bottomView.frame = CGRectMake(0, y, kSCREEN_WIDTH, kBottomViewHeight);
    [self checkPasteboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0xFFFFFF);
    self.title = @"我的词单";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.manageBtn];
    self.myBookListTableView.frame = self.view.bounds;
    self.myBookListTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //创建头部view
//    [self tableHeaderView];
    self.bottomView.frame = CGRectMake(0, self.view.height + kBottomViewHeight, kSCREEN_WIDTH, kBottomViewHeight);
    [self getWordListBaseInfo];
    [kNotificationCenter addObserver:self selector:@selector(refreshData) name:kSaveWordListSuccessNotify object:nil];
    
    //创建新词单的按钮
    [self createBtn];
    [self.createBtn setFrame:CGRectMake(SCREEN_WIDTH - AdaptSize(64+15.0),SCREEN_HEIGHT - kNavHeight-kSafeBottomMargin-AdaptSize(64)-AdaptSize(16.0) , AdaptSize(64), AdaptSize(64))];
    
//    [self getMyWordListData];
}

#pragma mark - YXMyWordBookCellDelegate
- (void)myWordBookCellManageBtnClicked:(YXMyWordBookCell *)myWordBookCell {
    BOOL selected = NO;
    if ([self.selmyWordBooks containsObject:myWordBookCell.myWordBookModel]) {
        [self.selmyWordBooks removeObject:myWordBookCell.myWordBookModel];
    }else {
        [self.selmyWordBooks addObject:myWordBookCell.myWordBookModel];
        selected = YES;
    }
    self.deleteBtn.enabled = self.selmyWordBooks.count;
//    NSIndexPath *clickedIndexPath = [self.myBookListTableView indexPathForCell:myWordBookCell];
    myWordBookCell.selectState = selected;
    
//    [self.myBookListTableView reloadRowsAtIndexPaths:@[clickedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self.myBookListTableView reloadData];
}

- (void)myWordBookCellStudyBtnClicked:(YXMyWordBookCell *)myWordBookCell {
    [self myWordBookEnterProcess:myWordBookCell.myWordBookModel
                    exerciseType:YXExerciseWordListStudy];
}

- (void)myWordBookCellListenBtnClicked:(YXMyWordBookCell *)myWordBookCell {
    [self myWordBookEnterProcess:myWordBookCell.myWordBookModel
                    exerciseType:YXExerciseWordListListen];
}

#pragma mark - YXMyWordBookActionProtocol
- (void)myWordBookDoCreateAction {
    if (self.myBookListData.count >= self.wordListBaseInfo.maxWordListSize) {
        [self wordListOverLimited];
        return;
    }
    //创建自选词单
    YXCreateWordBookVC *createVC = [[YXCreateWordBookVC alloc] init];
    createVC.numOfNextList = self.myBookListData.count + 1;
    createVC.curBookBrefInf = self.curBookBrefInf;
    __weak typeof(self) weakSelf = self;
    createVC.saveWordListSuccessBlock = ^{
        [weakSelf getMyWordListData];
    };
    createVC.wordListMaxWordLimited = self.wordListBaseInfo.maxWordsSize;
    [self.navigationController pushViewController:createVC animated:YES];
}

- (void)myWordBookDoShareAction {
    [YXWordBookBaseManageView wordBookBaseManageViewShowToView:self.navigationController.view
                                                         title:@"请输入词单分享码"
                                                  inputDefText:@""
                                                      delegate:self];
}

- (void)wordBookBaseManageView:(YXWordBookBaseManageView *)wordBookBaseManageView
           clickedButonAtIndex:(NSInteger)idnex {
    [wordBookBaseManageView endEditing:YES];
    if (idnex == 1) {
        NSString *code = wordBookBaseManageView.currentText;
        if (code.length) {
            NSDictionary *param = @{@"shareCode" : code};
            [YXDataProcessCenter GET:DOMAIN_SHARECODEWORDLIST
                           parameters:param
                         finshedBlock:^(YRHttpResponse *response, BOOL result)
             {
                 if (result) {
                     [wordBookBaseManageView maskViewWasTapped];
                     NSDictionary *details = [response.responseObject objectForKey:@"wordListSimplifiedDetails"];
                     YXMyWordListDetailModel *detailModel = [YXMyWordListDetailModel mj_objectWithKeyValues:details];
                     YXMyWordBookDetailVC *detailVC = [[YXMyWordBookDetailVC alloc] initWithMyWordBookModel:detailModel];
                     detailVC.isOwnWordList = [[details objectForKey:@"isSelf"] boolValue];
                     [self.navigationController pushViewController:detailVC animated:YES];
                 }else {
                     [YXUtils showHUD:nil title:response.error.desc];
                 }
             }];
        }
    }else {
        [wordBookBaseManageView maskViewWasTapped];
    }
}

- (void)wordListOverLimited {
    __weak typeof(self) weakSelf = self;
    YXComAlertView *alert =  [YXComAlertView showAlert:YXAlertCommon
                                                inView:[UIApplication sharedApplication].keyWindow
                                                  info:@"词单已达上限！"
                                               content:@"删除不用的词单后也可继续添加"
                                            firstBlock:^(id obj) {
                                                [weakSelf manageBookList:weakSelf.manageBtn];
                                            }secondBlock:nil];
    [alert.firstBtn setTitle:@"删除词单" forState:UIControlStateNormal];
    [alert.secondBtn setTitle:@"我知道了" forState:UIControlStateNormal];
}
#pragma mark - actions
- (void)manageBookList:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.wordListView.manageState = btn.selected;
//    self.tableHeaderView.manageState = btn.selected;
    [self.createBtn setHidden:btn.selected];
    CGFloat y = btn.selected ? self.view.height - kBottomViewHeight : self.view.height + kBottomViewHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.frame = CGRectMake(0, y, kSCREEN_WIDTH, kBottomViewHeight);
    }];
    [self.selmyWordBooks removeAllObjects];
    self.deleteBtn.enabled = self.selmyWordBooks.count;
    [self.myBookListTableView reloadData];
}

- (void)deleteMyWordBook { //    DOMAIN_DELETEMYWORDLIST
    NSInteger count = self.selmyWordBooks.count;
    __weak typeof(self) weakSelf = self;
    YXComAlertView *alert = [YXComAlertView showAlert:YXAlertCommon
                       inView:[UIApplication sharedApplication].keyWindow
                         info:@"词单删除后无法恢复,是否确认删除？"
                      content:[NSString stringWithFormat:@"正在删除 %zd 个词单",count]
                   firstBlock:^(id obj) {
                       [weakSelf confirmDeleteAction];
                   } secondBlock:^(id obj) {
                       
                  }];
    [alert.firstBtn setTitle:@"确认删除" forState:UIControlStateNormal];
    [alert.secondBtn setTitle:@"点错了" forState:UIControlStateNormal];
    alert.titleLab.font = [UIFont pfSCMediumFontWithSize:AdaptSize(17)];
}

- (void)confirmDeleteAction {
    NSArray *listIds = [self.selmyWordBooks valueForKeyPath:@"wordListId"];
    
    NSString *listIdsString = [listIds componentsJoinedByString:@"|"];
    NSDictionary *param = @{@"wordListIds" : listIdsString};
    [YXDataProcessCenter POST:DOMAIN_DELETEMYWORDLIST
                   parameters:param
                 finshedBlock:^(YRHttpResponse *response, BOOL result) {
                     if (result) {
//                         [self requestDeleteSuccess];
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         NSString *wordListId = [defaults objectForKey:kCurrentLearnWordListIdKey];
                         if ([listIds containsObject:wordListId]) {
                             [defaults removeObjectForKey:kCurrentLearnWordListIdKey];
                             [defaults setObject:kDefaultWordListName forKey:kUnfinishedWordListNameKey];
                         }
                         [self.myBookListData removeObjectsInArray:self.selmyWordBooks];
                         [self manageBookList:self.manageBtn];
                     }
                 }];
}

- (void)requestDeleteSuccess {
    [self.myBookListData removeObjectsInArray:self.selmyWordBooks];
    [self.selmyWordBooks removeAllObjects];
    [self.myBookListTableView reloadData];
}
#pragma mark - handleData
- (NSMutableArray *)selmyWordBooks {
    if (!_selmyWordBooks) {
        _selmyWordBooks = [NSMutableArray array];
    }
    return _selmyWordBooks;
}

- (void)getWordListBaseInfo {
    [self showTVLoadingView];
    [YXDataProcessCenter GET:DOMAIN_WORDLISTBASEINFO
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    [self hideTVLoadingView];
                    if (result) {
                        NSDictionary *baseInfoDic = [response.responseObject objectForKey:@"wordListBaseInfo"];
                        self.wordListBaseInfo = [YXWordListBaseInfo mj_objectWithKeyValues:baseInfoDic];
                        [self getMyWordListData];
                        [self hideNoNetWorkView];
                    }else {
                        if (response.error.code == kBADREQUEST_TYPE) {
                            __weak typeof(self) weakSelf = self;
                            [self showNoNetWorkView:^{
                                [weakSelf getWordListBaseInfo];
                            }];
                        }
                    }
                }];
}

- (void)refreshData {
    [self getMyWordListData];
}

- (void)getMyWordListData {
    [YXUtils showProgress:self.view];
    [YXDataProcessCenter GET:DOMAIN_MYWORDLIST
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    [YXUtils hideHUD:self.view];
                    if (result) {
                        NSArray *myWordList = [response.responseObject objectForKey:@"myWordList"];
                        self.myBookListData = [YXMyWordBookModel mj_objectArrayWithKeyValuesArray:myWordList];
                        [self.myBookListTableView reloadData];
                        [self hideNoNetWorkView];
                    }else {
                        if (response.error.code == kBADREQUEST_TYPE) {
                            [self networkDisConnect];
                        }
                    }
                }];
}

- (void)networkDisConnect {
    __weak typeof(self) weakSelf = self;
    [self showNoNetWorkView:^{
        [weakSelf getMyWordListData];
    }];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.myBookListData) {// 数据加载成功
        if (self.myBookListData.count == 0) {
            tableView.hidden = YES;
            self.manageBtn.hidden = YES;
            self.createBtn.hidden = YES;
            self.blankView.hidden = NO;
        }else {
            self.manageBtn.hidden = NO;
            if (!self.manageBtn.selected) {
                self.createBtn.hidden = NO;
            }
            else{
                self.createBtn.hidden = YES;
            }
            tableView.hidden = NO;
            self.blankView.hidden = YES;
        }
    }

    return self.myBookListData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyWordBookCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMyWordBookCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.switchToManage = self.manageBtn.state;
    YXMyWordBookModel *myWordBookModel = self.myBookListData[indexPath.section];
    if (self.manageBtn.state) {
        cell.selectState = [self.selmyWordBooks containsObject:myWordBookModel];
        myWordBookModel.isEditing = YES;
    }else {
        cell.selectState = NO;
        myWordBookModel.isEditing = NO;
    }
    
    cell.myWordBookModel = myWordBookModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return AdaptSize(15);
//        return CGFLOAT_MIN;
    }
    return AdaptSize(5);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXMyBookFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYXMyBookFooterViewID];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.manageBtn.selected) {
        YXMyWordBookCell *cell =  [tableView cellForRowAtIndexPath:indexPath];
        [cell clickManageBtn];
        return;
    }
    YXMyWordBookDetailVC *detailVC = [[YXMyWordBookDetailVC alloc] initWithMyWordBookModel:self.myBookListData[indexPath.section]];
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - subViews
- (UIButton *)manageBtn {
    if (!_manageBtn) {
        UIButton *manageBtn = [[UIButton alloc] init];
        manageBtn.frame = CGRectMake(0, 0, 60, 44);
        [manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        manageBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:17];
        [manageBtn setTitle:@"管理" forState:UIControlStateNormal];
        [manageBtn setTitle:@"完成"forState:UIControlStateSelected];
        manageBtn.hidden = YES;
        [manageBtn addTarget:self action:@selector(manageBookList:) forControlEvents:UIControlEventTouchUpInside];
        _manageBtn = manageBtn;
    }
    return _manageBtn;
}

- (UIButton *)createBtn {
    if (!_createBtn) {
        UIButton *createBtn = [[UIButton alloc] init];
//        [createBtn setImage:[UIImage imageNamed:@"create_word_book"] forState:UIControlStateNormal];
//        [createBtn setImage:[UIImage imageNamed:@"create_word_book"] forState:UIControlStateSelected];
//        createBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:17];
//        [createBtn setTitle:@"管理" forState:UIControlStateNormal];
//        [createBtn setTitle:@"完成"forState:UIControlStateSelected];
//        createBtn.hidden = YES;
        [createBtn addTarget:self action:@selector(CreateMyWordList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:createBtn];
        _createBtn = createBtn;
    }
    return _createBtn;
}

-(void)CreateMyWordList{
    
    if (self.myBookListData.count >= self.wordListBaseInfo.maxWordListSize) {
        [self wordListOverLimited];
        return;
    }
    //创建自选词单
    YXCreateWordBookVC *createVC = [[YXCreateWordBookVC alloc] init];
    createVC.numOfNextList = self.myBookListData.count + 1;
    createVC.curBookBrefInf = self.curBookBrefInf;
    __weak typeof(self) weakSelf = self;
    createVC.saveWordListSuccessBlock = ^{
        [weakSelf getMyWordListData];
    };
    createVC.wordListMaxWordLimited = self.wordListBaseInfo.maxWordsSize;
    [self.navigationController pushViewController:createVC animated:YES];
}


- (UITableView *)myBookListTableView {
    if (!_myBookListTableView) { //UITableViewStylePlain 悬停
        UITableView *myBookListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [myBookListTableView registerClass:[YXMyWordBookCell class] forCellReuseIdentifier:kYXMyWordBookCellID];
        [myBookListTableView registerClass:[YXMyBookFooterView class] forHeaderFooterViewReuseIdentifier:kYXMyBookFooterViewID];
        myBookListTableView.delegate = self;
        myBookListTableView.dataSource = self;
        myBookListTableView.backgroundColor = UIColorOfHex(0xF3F8FB);
        myBookListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myBookListTableView.hidden = YES;
        myBookListTableView.rowHeight =  AdaptSize(155);
        myBookListTableView.contentInset = UIEdgeInsetsMake(0, 0, kBottomViewHeight, 0);
        [self.view addSubview:myBookListTableView];
        
        _myBookListTableView = myBookListTableView;
    }
    return _myBookListTableView;
}

- (YXTopActionView *)tableHeaderView {
    if (!_tableHeaderView) {
        YXTopActionView *tableHeaderView = [[YXTopActionView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, AdaptSize(95))];
        tableHeaderView.delegate = self;
        self.myBookListTableView.tableHeaderView = tableHeaderView;
        _tableHeaderView = tableHeaderView;
    }
    return _tableHeaderView;
}

- (YXMyWordBookListBlankView *)blankView {
    if (!_blankView) {
        YXMyWordBookListBlankView *blankView = [[YXMyWordBookListBlankView alloc] initWithFrame:self.view.bounds];
        blankView.hidden = YES;
        blankView.delegate = self;
        [self.view addSubview:blankView];
        [self.view bringSubviewToFront:blankView];
        _blankView = blankView;
    }
    return _blankView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.layer.shadowColor = UIColorOfHex(0xCAD2DD).CGColor;
        bottomView.layer.shadowOpacity = 0.2;
        bottomView.layer.shadowOffset = CGSizeMake(-4, 0);
        bottomView.layer.shadowRadius = 4;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(kSCREEN_WIDTH, kBottomViewHeight));
        }];
        
        YXSpringAnimateButton *deleteBtn = [[YXSpringAnimateButton alloc] initWithNoHighLightState];
        [deleteBtn addTarget:self action:@selector(deleteMyWordBook) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        deleteBtn.enabled = NO;
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"reddeleteBGIcon"] forState:UIControlStateNormal];
        [bottomView addSubview:deleteBtn];
        _deleteBtn = deleteBtn;
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.top.equalTo(bottomView).offset(kIsIPhoneXSerious ? AdaptSize(10) : AdaptSize(5));
            make.size.mas_equalTo(MakeAdaptCGSize(200, 38));
        }];
    }
    return _bottomView;
}


- (void)showTVLoadingView {
    if (!_loadingAnimaterView) {
        YXLoadingView *loadingAnimaterView = [[YXLoadingView alloc] initWithFrame:CGRectMake(self.myBookListTableView.frame.origin.x-AdaptSize(15),self.myBookListTableView.frame.origin.y - kNavHeight , SCREEN_WIDTH, SCREEN_HEIGHT)];
        loadingAnimaterView.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication].keyWindow addSubview:loadingAnimaterView];
        _loadingAnimaterView = loadingAnimaterView;
    }
}

- (void)hideTVLoadingView {
    if (self.loadingAnimaterView) {
        [self.loadingAnimaterView removeFromSuperview];
    }
}

@end
