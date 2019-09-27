//
//  YXMissionViewController.m
//  YXEDU
//
//  Created by yixue on 2018/12/26.
//  Copyright © 2018 shiji. All rights reserved.
//

#import "YXMissionViewController.h"
#import "YXMissonTableViewCell.h"
#import "YXComNaviView.h"
#import "YXMissionCallenderView.h"
#import "YXBaseWebViewController.h"
#import "UICountingLabel.h"

#import "YXMissionSignModel.h"
#import "YXRouteManager.h"
#import "YXComHttpService.h"

@interface YXMissionViewController () <UITableViewDelegate,UITableViewDataSource,YXMissonTableViewCellDelegate>

@property (nonatomic, strong) UITableView *missionTableView;
@property (nonatomic, weak) YXComNaviView *naviView;
@property (nonatomic, weak) UIImageView *naviBGView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UICountingLabel *bannerScoreLabel;
@property (nonatomic, strong) YXMissionCallenderView *callenderView;
@property (nonatomic, strong) UIButton *bannerCheckInBtn;
@property (nonatomic, strong) UIImageView *headerBanner;

// MARK: Data from Model
@property (nonatomic, strong) NSString *userSignIn;
@property (nonatomic, strong) NSArray *baseScore;
@property (nonatomic, strong) NSString *userCredits;
@property (nonatomic, strong) NSString *multiplierScore;

@property (nonatomic, strong) NSMutableArray *taskListAry;
@property (nonatomic, strong) NSMutableArray *filteredTaskList;
@property (nonatomic, strong) CALayer *bannerCheckInBtnShadow;

@end

@implementation YXMissionViewController

// MARK: Life Circle -> viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupUI];
    [self setupSignInInfoModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

//MARK: Setup Model
- (void)setupSignInInfoModel {
    //无网络状态
    _userSignIn = @"0";
    _baseScore = @[];
    _userCredits = @"0";
    _multiplierScore = @"5";
    
    _taskListAry = [YXConfigure shared].confModel.taskList;
    [self filterTaskList];
    
    [self showLoadingView];
    
    [YXDataProcessCenter GET:DOMAIN_SIGNININFO parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSDictionary *userSignInInfo = [response.responseObject objectForKey:@"userSignInInfo"];
            YXMissionSignModel *model = [YXMissionSignModel mj_objectWithKeyValues:userSignInInfo];
            
            _userSignIn = model.convertedUserSignIn;
            _baseScore = model.convertedBaseScore;
            _userCredits = model.userCredits;
            _multiplierScore = model.multiplierScore;
            if (model.isTodayCheck) {
                [_bannerCheckInBtn setTitle:@"已签到" forState:UIControlStateNormal];
                _bannerCheckInBtn.backgroundColor = UIColorOfHex(0xEFF4F7);
                [_bannerCheckInBtn setTitleColor: UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
                _bannerCheckInBtn.enabled = NO;
                _bannerCheckInBtnShadow.shadowColor = [UIColor whiteColor].CGColor;
            }
            
            NSString *tipsString = @"0";
            if (![_userSignIn  isEqual: @"0"]) { tipsString = [NSString stringWithFormat:@"%lu",(unsigned long)_userSignIn.length]; }
            _tipsLabel.attributedText = [self splicedString:tipsString];
            _callenderView.userSignIn = _userSignIn;
            _bannerScoreLabel.text = _userCredits;
            [_bannerScoreLabel countFrom:0 to:_bannerScoreLabel.text.floatValue withDuration:1];

            [self hideNoNetWorkView];
        } else {
            if (response.error.code == kBADREQUEST_TYPE) {
                __weak typeof (self) weakself = self;
                [self showNoNetWorkView:^{
                    [weakself setupSignInInfoModel];
                }];
            }
        }
        [self hideLoadingView];
    }];
    
}

- (void)showNoNetWorkView:(YXTouchBlock)touchBlock {
    [super showNoNetWorkView:touchBlock];
    self.naviBGView.alpha = 1;
    [self.view bringSubviewToFront:self.naviView];
}

-(void)hideNoNetWorkView {
    [super hideNoNetWorkView];
    self.naviBGView.alpha = 0;
}

- (void)filterTaskList {
    [self.filteredTaskList removeAllObjects];
//    _filteredTaskList = [[NSMutableArray alloc] init];
    NSMutableArray *temAry = [[NSMutableArray alloc] init];
    NSMutableArray *temAry2 = [[NSMutableArray alloc] init];
    NSInteger temcount1 = 0;
    NSInteger temcount2 = 0;
    for (NSInteger i = 0; i < _taskListAry.count; i++) {
        YXTaskModel *model = _taskListAry[i];
        if (model.type == 1) {
            if (model.state == 0) {
                [temAry insertObject:model atIndex:temcount1];
            } else if (model.state == 2) {
                [temAry addObject:model];
            } else {
                [temAry insertObject:model atIndex:0];
                temcount1 += 1;
            }
        } else {
            if (model.state == 0) {
                [temAry2 insertObject:model atIndex:temcount2];
            } else if (model.state == 2) {
                [temAry2 addObject:model];
            } else {
                [temAry2 insertObject:model atIndex:0];
                temcount2 += 1;
            }
        }
    }
    [self.filteredTaskList addObject:temAry];
    if (temAry2.count != 0) {
       [self.filteredTaskList addObject:temAry2];
    }
    
    [_missionTableView reloadData];
}

- (NSMutableArray *)filteredTaskList {
    if (!_filteredTaskList) {
        _filteredTaskList = [NSMutableArray array];
    }
    return _filteredTaskList;
}

// MARK: Setup UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
    [self naviView];
    [self naviBGView];
}

- (void)setupTableView{
    _missionTableView = [[UITableView alloc] init];
    _missionTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kSafeBottomMargin);
    
    _missionTableView.delegate = self;
    _missionTableView.dataSource = self;
    
    _missionTableView.bounces = false;
    _missionTableView.showsVerticalScrollIndicator = false;
    _missionTableView.rowHeight = AdaptSize(280);
    _missionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_missionTableView registerClass:[YXMissonTableViewCell class] forCellReuseIdentifier:@"YXMissonTableViewCellID"];
    
    [self setupHeaderView];
    
    [self.view addSubview:_missionTableView];
}

- (void)setupHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, AdaptSize(275) + kNavHeight);
    headerView.backgroundColor = [UIColor whiteColor];
    _missionTableView.tableHeaderView = headerView;
    
    UIImageView *headerBg = [[UIImageView alloc] init];
    headerBg.frame = CGRectMake(0, 0, SCREEN_WIDTH, AdaptSize(150-64) + kNavHeight);
    headerBg.image = [UIImage imageNamed:@"Mission_header_bg"];
    [headerView addSubview:headerBg];
    _headerView = headerView;
    
    UIImageView *headerBanner = [[UIImageView alloc] init];
    headerBanner.size = MakeAdaptCGSize(345, 130);
    headerBanner.center = CGPointMake(headerBg.center.x, headerBg.center.y + headerBg.height / 2);
    headerBanner.image = [UIImage imageNamed:@"Mission_header_banner"];
    headerBanner.layer.cornerRadius = headerBanner.height / 10;
    headerBanner.layer.masksToBounds = YES;
    [headerBanner setUserInteractionEnabled:YES];
    //[headerView addSubview:headerBanner];
    
    CALayer *shadowLayer = [[CALayer alloc] init];
    shadowLayer.backgroundColor = [UIColor whiteColor].CGColor;
    shadowLayer.frame = headerBanner.frame;
    shadowLayer.cornerRadius = headerBanner.height / 10;
    shadowLayer.shadowOffset = CGSizeMake(0,1);
    shadowLayer.shadowOpacity = 1;
    shadowLayer.shadowRadius = 10;
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowColor = [UIColor colorWithRed:98/255.0 green:151/255.0 blue:231/255.0 alpha:0.5].CGColor;
    [headerView.layer addSublayer:shadowLayer];
    [headerView addSubview:headerBanner];
    _headerBanner = headerBanner;
    
    UILabel *bannerTitleLabel = [[UILabel alloc] init];
    bannerTitleLabel.frame = CGRectMake(AdaptSize(64), AdaptSize(36), AdaptSize(60), AdaptSize(13));
    bannerTitleLabel.textAlignment = NSTextAlignmentLeft;
    bannerTitleLabel.text = @"我的积分";
    bannerTitleLabel.textColor = UIColorOfHex(0x8095AB);
    bannerTitleLabel.font = [UIFont systemFontOfSize:AdaptSize(14)];
    [headerBanner addSubview:bannerTitleLabel];
    
    _bannerScoreLabel = [[UICountingLabel alloc] init];
    _bannerScoreLabel.frame = CGRectMake(AdaptSize(24), AdaptSize(65), AdaptSize(200), AdaptSize(32));
    _bannerScoreLabel.textAlignment = NSTextAlignmentLeft;
    _bannerScoreLabel.format = @"%d";
    _bannerScoreLabel.method = UILabelCountingMethodEaseIn;
    //NSMutableString *bannerScoreStr = _userCredits.mutableCopy;
//    for (NSInteger i = 0; i < (bannerScoreStr.length - 1 - i) / 3; i++) {
//        [bannerScoreStr insertString:@"," atIndex: bannerScoreStr.length-4*i-3];
//    }
    //_bannerScoreLabel.text = bannerScoreStr;
    _bannerScoreLabel.textColor = UIColorOfHex(0x434A5D);
    _bannerScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:AdaptSize(32)];
    [headerBanner addSubview:_bannerScoreLabel];
    
    _bannerCheckInBtn = [[UIButton alloc] init];
    _bannerCheckInBtn.frame = CGRectMake(AdaptSize(231), AdaptSize(65), AdaptSize(95), AdaptSize(33));
    _bannerCheckInBtn.backgroundColor = [UIColor clearColor];
    _bannerCheckInBtn.layer.cornerRadius = AdaptSize(16);
    [_bannerCheckInBtn setTitle:@"立即签到" forState:UIControlStateNormal];
    [_bannerCheckInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bannerCheckInBtn.titleLabel.font = [UIFont systemFontOfSize:AdaptSize(14)];
    [_bannerCheckInBtn addTarget:self action:@selector(bannerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerBanner addSubview:_bannerCheckInBtn];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(AdaptSize(231), AdaptSize(65), AdaptSize(95),  AdaptSize(33));
    gl.cornerRadius = AdaptSize(16);
    gl.startPoint = CGPointMake(1, 0.5);
    gl.endPoint = CGPointMake(0, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:104/255.0 green:160/255.0 blue:253/255.0 alpha:1.0].CGColor,
                  (__bridge id)[UIColor colorWithRed:105/255.0 green:190/255.0 blue:251/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.shadowOffset = CGSizeMake(2, 3);
    gl.shadowOpacity = 0.5;
    gl.shadowRadius = 6;
    gl.shadowColor = UIColorOfHex(0x6D8FBC).CGColor;
    [headerBanner.layer insertSublayer:gl below:_bannerCheckInBtn.layer];
    _bannerCheckInBtnShadow = gl;
    
    _tipsLabel = [[UILabel alloc] init];
    _tipsLabel.size = MakeAdaptCGSize(350, 14);
    _tipsLabel.center = CGPointMake(SCREEN_WIDTH / 2, AdaptSize(241-64 + 5) + kNavHeight);
    NSString *tipsString = @"0";
    if (![_userSignIn  isEqual: @"0"]) { tipsString = [NSString stringWithFormat:@"%lu",(unsigned long)_userSignIn.length]; }
    _tipsLabel.attributedText = [self splicedString:tipsString];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_tipsLabel];
    
    _callenderView = [YXMissionCallenderView alloc];
    //_callenderView的数据从这传进去
    _callenderView.userSignIn = _userSignIn;
    _callenderView.baseScore = _baseScore;
    _callenderView.userCredits = _userCredits;
    _callenderView.multiplierScore = _multiplierScore;
    _callenderView = [_callenderView initWithFrame:CGRectMake(AdaptSize(16), AdaptSize(260-64 + 10) + kNavHeight, SCREEN_WIDTH - AdaptSize(32), AdaptSize(55))];
    [headerView addSubview:_callenderView];
}

- (NSMutableAttributedString *)splicedString:(NSString *)days {
    NSMutableString *string = [[NSMutableString alloc] init];
    NSMutableString *temString = [[NSMutableString alloc] init];
    [temString setString:@"—— 本周已签到"];
    [string appendString:temString];
    [temString setString:days];
    [string appendString:temString];
    [temString setString:@"天，签到越多，周日奖励越丰富！——"];
    [string appendString:temString];
    
    NSMutableAttributedString *atrString = [NSMutableAttributedString alloc];
    atrString = [atrString initWithString: string
                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:AdaptSize(13)],
                                            NSForegroundColorAttributeName: UIColorOfHex(0x8095AB)}];
    [atrString addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:AdaptSize(16)],
                               NSForegroundColorAttributeName: UIColorOfHex(0xFD9725)}
                       range:NSMakeRange(8,1)];
    return atrString;
}

- (void)bannerBtnClicked:(UIButton *)sender {
    [sender setEnabled:NO];
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    [YXDataProcessCenter POST:DOMAIN_SIGNIN parameters:@{@"time":timeString} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            if (response.responseObject) { //防过期签到
                NSDictionary *userSignInInfo = [response.responseObject objectForKey:@"userSignInInfo"];
                YXMissionSignModel *model = [YXMissionSignModel mj_objectWithKeyValues:userSignInInfo];
                
                _userSignIn = model.convertedUserSignIn;
                _baseScore = model.convertedBaseScore;
                _userCredits = model.userCredits;
                _multiplierScore = model.multiplierScore;
                
                NSString *tipsString = @"0";
                if (![_userSignIn  isEqual: @"0"]) { tipsString = [NSString stringWithFormat:@"%lu",(unsigned long)_userSignIn.length]; }
                _tipsLabel.attributedText = [self splicedString:tipsString];
                _callenderView.userSignIn = _userSignIn;
                //_bannerScoreLabel.text = _userCredits;
                [_bannerScoreLabel countFrom:_bannerScoreLabel.text.floatValue to:_userCredits.floatValue withDuration:1];
                
                [sender setTitle:@"已签到" forState:UIControlStateNormal];
                sender.backgroundColor = UIColorOfHex(0xEFF4F7);
                [sender setTitleColor: UIColorOfHex(0x8095AB) forState:UIControlStateNormal];
                _bannerCheckInBtnShadow.shadowColor = [UIColor whiteColor].CGColor;//
                
            } else {
                [sender setEnabled:YES];
            }
        } else { //请求失败
            [sender setEnabled:YES];
        }
    }];
}

- (YXComNaviView *)naviView {
    if (!_naviView) {
        YXComNaviView *naviView = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonWhite];
        naviView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        naviView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:naviView];
        [naviView.leftButton addTarget:self action:@selector(naviLeftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [naviView setRightButtonNormalImage:[UIImage imageNamed:@"Mission_QuesMark"]
                            hightlightImage:[UIImage imageNamed:@"Mission_QuesMark_pressed"]];
        [naviView.rightButton addTarget:self action:@selector(naviRightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        naviView.titleLabel.textColor = [UIColor whiteColor];
        naviView.titleLabel.font = [UIFont systemFontOfSize:19];
        naviView.titleLabel.text = @"任务中心";
        _naviView = naviView;
    }
    return _naviView;
}

- (void)naviLeftBtnClicked {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)naviRightBtnClicked {
    YXBaseWebViewController *webVC = [[YXBaseWebViewController alloc] init];
    webVC.link = @"http://app.xstudyedu.com/share/explain/wordbean.html";
    webVC.title = @"积分说明";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (UIImageView *)naviBGView {
    if (!_naviBGView) {
        UIImageView *naviBGView = [[UIImageView alloc] init];
        naviBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        naviBGView.image = [UIImage imageNamed:@"scaleBgImage"];
        naviBGView.alpha = 0;
        [_naviView insertSubview:naviBGView atIndex:0];
        _naviBGView = naviBGView;
    }
    return _naviBGView;
}

// MARK: UITableView Protocol Methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YXMissonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXMissonTableViewCellID" forIndexPath:indexPath];
    cell.delegate = self;
    cell.taskListAfterSelected = _filteredTaskList[indexPath.row];

    NSMutableString *str = [NSMutableString stringWithString:@""];
    if (indexPath.row == 0) {
        [str appendString:@"每日任务（"];
    } else if (indexPath.row == 1) {
        [str appendString:@"特殊任务（"];
    }
    NSInteger count = cell.taskListAfterSelected.count;
    for (YXTaskModel *item in self.filteredTaskList[indexPath.row]) { if (item.state == 0) { count -= 1; } }
    [str appendFormat:@"%zd",count];
    [str appendString:@"/"];
    [str appendFormat:@"%zd",cell.taskListAfterSelected.count];
    [str appendString:@"）"];
    if (indexPath.row == 0) {
        cell.title = str;
    } else if (indexPath.row == 1) {
        cell.title = str;
    }
    return cell; 
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredTaskList.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat curOffSet = scrollView.contentOffset.y;
    CGFloat maxOffSet = kNavHeight + AdaptSize(30);
    if (curOffSet > maxOffSet) {
        _naviBGView.alpha = 1;
    } else {
        _naviBGView.alpha = curOffSet / maxOffSet;
    }
}

- (NSInteger)getWeekDayFordate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDate *now = [NSDate date];// 在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    if ([comps weekday] - 2 == -1) { return 6; }
    return [comps weekday] - 2;
}

// MARK: custom protocol
- (void)missonTableViewCellTransferTo:(YXMissionCollectionViewCell *)missionCollectionCell {
    NSLog(@"--------missonTableViewCellTransferTo--------");
    NSString *action =  missionCollectionCell.model.action;
    [[YXRouteManager shared] openUrl:action];
}

- (void)missonTableViewCellGetNewTask:(YXMissionCollectionViewCell *)missionCollectionCell taskModel:(YXTaskModel *)model {
    NSLog(@"--------missonTableViewCellGetNewTask--------");
    NSInteger oldTaskId = model.taskId;
    [YXDataProcessCenter POST:DOMAIN_GETNEWTASK parameters:@{@"taskId":@(oldTaskId)} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            CGPoint point = [missionCollectionCell convertPoint:missionCollectionCell.centerImgBox.center toView:self.view];
            [self refreshCreditsWithPoint:point];
            
            NSDictionary *getNewTask = [response.responseObject objectForKey:@"newTask"];
            if (getNewTask) { //有后续任务
                YXTaskModel *newTaskModel = [YXTaskModel mj_objectWithKeyValues:getNewTask];
                NSInteger index = [_taskListAry indexOfObject:model];
                [_taskListAry replaceObjectAtIndex:index withObject:newTaskModel];
                [self filterTaskList];
                NSLog(@"有后续任务");
            } else { //无后续任务
                //变成已完成状态
                YXTaskModel *newTaskModel = model;
                newTaskModel.state = 2;
                NSInteger index = [_taskListAry indexOfObject:model];
                [_taskListAry replaceObjectAtIndex:index withObject:newTaskModel];
                [self filterTaskList];
                NSLog(@"变成已完成状态,无后续任务");
            }
        } else {
            NSLog(@"请求失败");
            if (response.error.code != kBADREQUEST_TYPE && response.error.desc.length) {
                [YXUtils showHUD:self.view title:response.error.desc];
                [self reloadConfig];
            }
        }
    }];
}

- (void)reloadConfig {
    [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 成功
            _taskListAry = [YXConfigure shared].confModel.taskList;
            [self filterTaskList];
        }
    }];
}

- (void)refreshCreditsWithPoint:(CGPoint)point {
    [YXDataProcessCenter GET:DOMAIN_CREDITS parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSInteger newScore = [[response.responseObject objectForKey:@"userCredits"] integerValue];
            CGPoint targetPoint = [_headerBanner convertPoint:CGPointMake(AdaptSize(40), AdaptSize(42)) toView:self.view];
            UIImageView *bean = [[UIImageView alloc] init];
            bean.image = [UIImage imageNamed:@"convertPoint"];
            bean.frame = CGRectMake(0, 0, 30, 20);
            bean.center = point;
            [self.view insertSubview:bean belowSubview:_naviView];
            [_bannerScoreLabel countFrom:_bannerScoreLabel.text.integerValue to:newScore];
            [UIView animateWithDuration:0.25 animations:^{
                bean.center = targetPoint;
            } completion:^(BOOL finished) {
                [bean removeFromSuperview];
            }];
        }
    }];
}



@end
