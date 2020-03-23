//
//  YXMyWordBookBaseVC.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXMyWordBookBaseVC.h"
#import "YXWordDetailViewControllerOld.h"


static NSString *const kYXMyWordBaseCellID = @"YXMyWordBaseCellID";
static NSString *const kYXMyWordBaseHeaderViewID = @"YXMyWordBaseHeaderViewID";
@interface YXMyWordBookBaseVC ()<YXWordBookBaseManageViewDelegate>
@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITableView *wordListTableView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UIButton *rightBarItemBtn;
@property (nonatomic, weak) UIButton *changeNameBtn;
@end

@implementation YXMyWordBookBaseVC
- (NSArray *)rightBarItemImages {
    return nil;
}

- (NSDictionary *)registerCellInfo {
    return @{
             ReuseIdentifierKey : kYXMyWordBaseCellID,
             ReuseClassKey : [YXMyWordBaseCell class]
             };
}

- (NSDictionary *)registerSectionHeaderInfo {
    return @{
             ReuseIdentifierKey : kYXMyWordBaseCellID,
             ReuseClassKey : [YXMyWordBaseHeaderView class]
             };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorOfHex(0xF3F8FB);
    [self rightBarItemBtn];
    [self bgView];
    [self wordListTableView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(kBottomViewHeight);
    }];
    
    CGFloat lrMargin = AdaptSize(15);
    [self.wordListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AdaptSize(80));
        make.left.equalTo(self.view).offset(lrMargin);
        make.right.equalTo(self.view).offset(-lrMargin);
        make.bottom.equalTo(self.bottomView.mas_top).offset(AdaptSize(8));
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.wordListTableView);
    }];
}
#pragma mark - action
- (void)rightBarItemClick:(UIButton *)btn {
    
}

- (void)changeWordListName {
    YXLog(@"改名字------------------");
}

- (void)showChangeNameViewWithDefaultName:(NSString *)defName {
    YXChangeWordlistNameView *changeNameView = [YXChangeWordlistNameView wordBookBaseManageViewShowToView:self.navigationController.view
                                                                                                    title:@"请设置词单名称"
                                                                                             inputDefText:defName
                                                                                                 delegate:self];
    [changeNameView.confirmButton setTitle:@"保 存" forState:UIControlStateNormal];
}

- (void)wordBookBaseManageView:(YXWordBookBaseManageView *)wordBookBaseManageView clickedButonAtIndex:(NSInteger)idnex {}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [self.registerSectionHeaderInfo objectForKey:ReuseIdentifierKey];
    UIView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self.registerCellInfo objectForKey:ReuseIdentifierKey]
                                                            forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyWordBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YXMyWordCellBaseModel *wordModel = cell.wordModel;
    
    YXWordDetailViewControllerOld *detailVC = [YXWordDetailViewControllerOld wordDetailWith:wordModel.wordDetail bookId:wordModel.bookId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableView *)wordListTableView {
    if (!_wordListTableView) { //UITableViewStylePlain 悬停
        UITableView *wordListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [wordListTableView registerClass:[self.registerCellInfo objectForKey:ReuseClassKey]
                  forCellReuseIdentifier:[self.registerCellInfo objectForKey:ReuseIdentifierKey]];
        
        [wordListTableView registerClass:[self.registerSectionHeaderInfo objectForKey:ReuseClassKey]
      forHeaderFooterViewReuseIdentifier:[self.registerSectionHeaderInfo objectForKey:ReuseIdentifierKey]];
        
        wordListTableView.delegate = self;
        wordListTableView.dataSource = self;
        wordListTableView.backgroundColor = [UIColor whiteColor];//UIColorOfHex(0xF3F8FB);
        wordListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        wordListTableView.rowHeight = AdaptSize(49);
        wordListTableView.sectionHeaderHeight = AdaptSize(50);
        
        wordListTableView.layer.cornerRadius = AdaptSize(8);
        wordListTableView.showsVerticalScrollIndicator = NO;
        wordListTableView.contentInset = UIEdgeInsetsMake(0, 0, AdaptSize(8), 0);
        [self.view addSubview:wordListTableView];
        _wordListTableView = wordListTableView;
    }
    return _wordListTableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.shadowColor = UIColorOfHex(0xCAD2DD).CGColor;
        bottomView.layer.shadowOpacity = 0.2;
        bottomView.layer.shadowOffset = CGSizeMake(0, 0);
        bottomView.layer.shadowRadius = 5;
        bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bottomView];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor; ////[UIColor greenColor].CGColor;
        bgView.layer.shadowOpacity = 0.44;
        bgView.layer.shadowOffset = CGSizeMake(0, 0);
        bgView.layer.shadowRadius = 5;
        bgView.layer.cornerRadius = AdaptSize(8);
        [self.view addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}

- (UIButton *)rightBarItemBtn {
    if (!_rightBarItemBtn) {
        UIButton *rightBarItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [rightBarItemBtn setImage:[UIImage imageNamed:self.rightBarItemImages.firstObject]
                         forState:UIControlStateNormal];

        [rightBarItemBtn setImage:[UIImage imageNamed:self.rightBarItemImages.lastObject]
                         forState:UIControlStateHighlighted];
        [rightBarItemBtn addTarget:self
                            action:@selector(rightBarItemClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItemBtn];
        _rightBarItemBtn = rightBarItemBtn;
    }
    return _rightBarItemBtn;
}

- (UIButton *)changeNameBtn {
    if (!_changeNameBtn) {
        UIButton *changeNameBtn = [[UIButton alloc] init];
        changeNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [changeNameBtn addTarget:self action:@selector(changeWordListName) forControlEvents:UIControlEventTouchUpInside];
        [changeNameBtn setImage:[UIImage imageNamed:@"chageNameIcon"] forState:UIControlStateNormal];
        [self.view addSubview:changeNameBtn];
        _changeNameBtn = changeNameBtn;
    }
    return _changeNameBtn;
}
@end

