//
//  YXMainVC.m
//  YXEDU
//
//  Created by shiji on 2018/8/28.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "BSUtils.h"
#import "YXMainVC.h"
#import "YXPersonalCenterVC.h"
#import "YXPersonalBookVC.h"
#import "BSCommon.h"
#import "YXSelectBookVC.h"
#import "YXConfigure.h"
#import "YXNavigationController.h"
// #import "AppDelegate.h"
#import "XJYChart.h"
#import "YXStudyProgressView.h"
#import "YXAPI.h"
#import "YXHttpService.h"
#import "YXUtils.h"
#import "YXMainModel.h"
#import "NSObject+YR.h"
#import "YXExerciseVC.h"
#import "YXLoadingView.h"
#import "YXComHttpService.h"
#import "YXCalendarViewController.h"
#import "YXArticleDetailViewController.h"

#import "FBYLineGraphView.h"
#import "YXBindPhoneVC.h"
#import "YXCareerViewController.h"

#import "YXRefreshView.h"
#import "YXRefreshNormalHeader.h"
#import "YXWordModelManager.h"
#import "YXFresherGuideView.h"
#import "YXShareView.h"
#import "YXWordQuestionModel.h"
#import "YXBadgeView.h"
#import "YXReporAreaView.h"
#import "YXNNCareerView.h"
#import "YXMainBGView.h"
#import "YXPunchModel.h"
#import "YXReportViewController.h"
#import "YXMissionViewController.h"
#import "YXMissionToCheckinView.h"
#import "YXMissionToReceiveView.h"
#import "YXAnimatorStarView.h"
#import "YXNinePalaceKeyBoardView.h"

#import "YXMissionSignModel.h"
#import "YXLearnReportModel.h"
#import "YXTaskViewModel.h"

#import "YXSynchroIndicatorView.h"
#import "YXBeansAnimateView.h"
#import "YXMyWordBookListVC.h"
#import "YXSearchVC.h"
#import "YXPosterShareView.h"
#import "YXReviewAccomplishView.h"
#import "YXWordDetailShareView.h"
#import "YXShareLodingView.h"
#import "BSUtils.h"
#import "YXUserSaveTool.h"
#import "YXMyWordBookDetailVC.h"
#import "YXStudyResultVC.h"
#import "YXBaseWebViewController.h"
#import "YXArticleSelectVC.h"
#import "WBQRCodeVC.h"
#import "UIDevice+YYAdd.h"
#import "YXMainItemsView.h"
#import "YXHttpService.h"


#define kDefaultBGHeight 437.5
#define kDefaultCardViewHeight (317 + 30) // 不包含复习单词label
#define kReviewCardViewHeight 373

#define kCareerViewHeight 198
#define kChartAreaHeight 175

//#define kBGBlueImageWidth 375
//static CGFloat const kBGBlueImageWidth = 375.0;

#define KBaseContentHeight (kCareerViewHeight + kChartAreaHeight + kSafeBottomMargin + kNavHeight + 20)
// content  cardHeight    careerH      chartAreaH
//                          198             175

@interface YXMainVC ()<UIScrollViewDelegate,YXSetProgressViewDelegate,YXFresherGuideViewDelegate,CAAnimationDelegate,YXWordDetailShareViewDelegate>
@property (nonatomic, strong) UIScrollView *contentScroll;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *wordNumLab;
@property (nonatomic, strong) UIButton *modifyBtn;
@property (nonatomic, strong) UILabel *totalStudyTitleLab;
@property (nonatomic, strong) UILabel *totalStudyLab;
@property (nonatomic, strong) UILabel *dayLeftTitleLab;
@property (nonatomic, strong) UILabel *dayLeftLab;
@property (nonatomic, strong) UIView *centerLine;

@property (nonatomic, strong) UILabel *reciteTitleLab;

@property (nonatomic, strong) YXMainBGView *headerView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) YXMainModel *mainModel;

@property (nonatomic, weak) UILabel *bookLabel;
@property (nonatomic, weak) UIView *studyCardView;
@property (nonatomic, weak) YXComNaviView *naviView;
@property (nonatomic, weak) UIImageView *naviBGView;
@property (nonatomic, weak) UIView *chartBGView;
@property (nonatomic, weak) FBYLineGraphView *chartView;
@property (nonatomic, strong) UIButton *calendarBtn;
@property (nonatomic, weak)UILabel *stsL;

@property (nonatomic, weak)YXLoadingView *loadingView;
@property (nonatomic, assign) BOOL isConfigSuccess;
@property (nonatomic, weak) UIImageView *scaleBlueView;
@property (nonatomic, weak)YXRefreshView *refreshView;
@property (nonatomic, weak)YXRefreshNormalHeader *mjRefresher;

@property (nonatomic, strong)NSMutableArray *todayWords;
@property (nonatomic, strong)NSMutableArray *allBadgesDetails;

@property (nonatomic, strong)YXNNCareerView *careerView;
@property (nonatomic, assign)BOOL fresherGuideShowed;

@property (nonatomic, assign)CGFloat scaleBlueDefaultHeight;
//@property (nonatomic, weak)YXReporAreaView *reportAreaView;
@property (nonatomic, weak)YXMainItemsView *reportAreaView;
@property (nonatomic, weak) YXFresherGuideView *fresherGuideView;
@property (nonatomic, strong) NSMutableArray *unshowedTaskAry;
@property (nonatomic, weak) YXMissionToReceiveView *alertView;
@property (nonatomic, weak) YXSynchroIndicatorView *synchroIndicatorView;
@property (nonatomic, weak) YXBeansAnimateView *beansAnimateView;
@property (nonatomic, weak) YXSpringAnimateButton *myWordBookBtn;

@property (nonatomic, weak) UILabel *selectWordTipsL;
@property (nonatomic, weak) UIImageView *bubble;
@end

@implementation YXMainVC
- (void)noNetWorkState {
    [self.headerView noNetworkState];
    self.naviView.titleLabel.text = @"--";
    self.totalStudyLab.text = @"--/--";
    NSString *textStr = [NSString stringWithFormat:@"%@ 剩余-天",kIconFont_pencil];
    [self.modifyBtn setTitle:textStr forState:UIControlStateNormal];
    self.careerView.haveLearnBtn.number = @"--";
    self.careerView.collectionbtn.number = @"--";
    self.careerView.wrongBookbtn.number = @"--";
    NSMutableArray *charts = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        YXNoteCharts *chatdata = [[YXNoteCharts alloc] init];
        chatdata.dateStr = @"-";
        chatdata.num = 0;
        [charts addObject:chatdata];
    }
    [self refreshChartView:charts];
}

- (BOOL)checkNetworkStatus {
    BOOL connected = [NetWorkRechable shared].connected;
    if (!connected) {
        [self noNetWorkState];
    }
    return connected;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [kNotificationCenter addObserver:self selector:@selector(presentSelectBookViewController) name:kShowSelectedBookVCNotify object:nil];
    [kNotificationCenter addObserver:self selector:@selector(updateUnshowedTaskAry) name:@"refreshCompletedTasks" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(showCompletedTaskAlertView) name:@"refreshCompletedTasks" object:nil];
    [kNotificationCenter addObserver:self selector:@selector(uploadExericiseResult:) name:kUploadExericiseResultNotify object:nil];
    self.contentScroll.frame = self.view.bounds;
    self.contentScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self naviView];
    self.naviBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
    if (kIsIPhoneXSerious) {
        _scaleBlueDefaultHeight = 22;
    }
    self.scaleBlueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _scaleBlueDefaultHeight);
    
    CGSize bgImageSize = self.headerView.image.size;
    self.headerView.frame = CGRectMake(0, self.scaleBlueDefaultHeight, SCREEN_WIDTH, AdaptSize(bgImageSize.height));//kDefaultBGHeight
    [self refreshView];
    [self mjRefresher];
    
    self.reportAreaView.frame = CGRectMake(0, self.headerView.bottom,SCREEN_WIDTH ,AdaptSize(119));//20
    self.myWordBookBtn.frame = CGRectMake(5, AdaptSize(65), 67, 67);
    [self.selectWordTipsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(AdaptSize(80));
        make.top.equalTo(self.headerView).offset(AdaptSize(75));
    }];
    
    self.modifyBtn.frame = CGRectMake(SCREEN_WIDTH-82, AdaptSize(82), 82, 27);
    
    CGFloat careerY = self.reportAreaView.bottom;
    self.careerView.frame = CGRectMake(0, careerY, SCREEN_WIDTH, AdaptSize(115));
    
    self.chartBGView.frame = CGRectMake(0, self.careerView.bottom , SCREEN_WIDTH, 175);// 140 + 35(header label)
    UILabel *statisticsL = [[UILabel alloc] initWithFrame:CGRectMake(AdaptSize(16), AdaptSize(4), 70, 15)];
    statisticsL.textAlignment = NSTextAlignmentLeft;
    statisticsL.textColor = UIColorOfHex(0x434A5D);
    statisticsL.text = @"学习统计";
    statisticsL.font = [UIFont systemFontOfSize:15];
    [self.chartBGView addSubview:statisticsL];
    _stsL = statisticsL;

    UIButton *calendar = [[UIButton alloc] init];
    calendar.frame = CGRectMake(SCREEN_WIDTH - 125 - AdaptSize(16), statisticsL.top + 1, 120, 26);
    calendar.backgroundColor = UIColor.whiteColor;
    [calendar setTitle:@" 查看打卡日历" forState:UIControlStateNormal];
    [calendar setImage:[UIImage imageNamed:@"calendar_main_icon_blue"] forState:UIControlStateNormal];
    calendar.titleLabel.font = [UIFont systemFontOfSize:AdaptSize(12)];
    [calendar setTitleColor:UIColorOfHex(0x60B8F8) forState:UIControlStateNormal];
    [calendar.layer setCornerRadius:13];
    [calendar.layer setBorderWidth:0.5f];
    [calendar.layer setBorderColor:UIColorOfHex(0x60B8F8).CGColor];
    [calendar addTarget:self action:@selector(checkCalendar) forControlEvents:UIControlEventTouchUpInside];
    [self.chartBGView addSubview:calendar];
    _calendarBtn = calendar;
    [_calendarBtn setHidden:YES];
    
    // 表格
    NSMutableArray *charts = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        YXNoteCharts *chatdata = [[YXNoteCharts alloc] init];
        chatdata.dateStr = @"-";
        chatdata.num = 0;
        [charts addObject:chatdata];
    }
    [self refreshChartView:charts];
    self.contentScroll.contentSize = CGSizeMake(SCREEN_WIDTH, self.chartBGView.bottom  + 20);//+ kSafeBottomMargin
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kNetworkConnectedNotify object:nil];
    [self refreshWordListTips];
    [self loadShowImage];//预先加载分享背景图
}

- (void)refreshWordListTips {
    /*
    NSString *tips = [[NSUserDefaults standardUserDefaults] objectForKey:kUnfinishedWordListNameKey];
    if (![tips isEqualToString:kDefaultWordListName]) { //第一次安装
        if (tips.length || !tips) {
            tips = tips ? [NSString stringWithFormat:@"“%@”词单还未学完，快继续学习吧",tips]: @"按单元选择想要学习的单词进行“学习”或“听写”";
            self.selectWordTipsL.text = tips;
            self.selectWordTipsL.hidden = NO;
            self.bubble.hidden = NO;
        }
    }
    */
}

- (void)uploadExericiseResult:(NSNotification *)notify {
    BOOL state = [[notify.userInfo objectForKey:@"uploadState"] boolValue];
    if (state == 1) { //正在上传
        self.synchroIndicatorView = [YXSynchroIndicatorView synchroIndicatorShowToView:self.headerView];
    }else { // 上传结束
        [self.synchroIndicatorView hide];
        [self loadMainData];
    }
}

#pragma mark -- 已完成任务弹窗
- (NSMutableArray *)unshowedTaskAry {
    if (!_unshowedTaskAry) {
        _unshowedTaskAry = [NSMutableArray array];
    }
    return _unshowedTaskAry;
}

- (void)updateUnshowedTaskAry {
    [self.unshowedTaskAry addObjectsFromArray:[YXConfigure shared].confModel.completedTaskModelAry];
    [self showCompletedTaskAlertView];
}
//领取奖励view
- (void)showCompletedTaskAlertView {
    if ([[self currentVisibleViewController] isKindOfClass: [self class]] && self.unshowedTaskAry.count) {
        YXMissionToReceiveView *alertView = [[YXMissionToReceiveView alloc] init];
        _alertView = alertView;
        alertView.completedTaskModelAry = [self.unshowedTaskAry copy];
        [self.unshowedTaskAry removeAllObjects];
        __weak typeof(self) weakself = self;
        alertView.getAllCreditsBlock = ^(NSArray * _Nonnull completedTaskModelAry) {
            [weakself receiveCredits:completedTaskModelAry];
        };
        [[UIApplication sharedApplication].delegate.window addSubview:alertView];
    }
}

- (UIViewController *)currentVisibleViewController {
    UIViewController *selectedViewController = self.tabBarController.selectedViewController;
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)selectedViewController visibleViewController];
    } else {
        return nil;
    }
}

- (void)receiveCredits:(NSArray *)completedTaskModelAry {
    NSInteger lastTaskId = [completedTaskModelAry.lastObject taskId];
    for (YXTaskModel *model in completedTaskModelAry) {
        [YXDataProcessCenter POST:DOMAIN_GETNEWTASK parameters:@{@"taskId":@(model.taskId)} finshedBlock:^(YRHttpResponse *response, BOOL result) {
            if (result) {
                NSDictionary *getNewTask = [response.responseObject objectForKey:@"newTask"];
                NSMutableArray *taskList = [YXConfigure shared].confModel.taskList;
                if (getNewTask) { //有后续任务
                    YXTaskModel *newTaskModel = [YXTaskModel mj_objectWithKeyValues:getNewTask];
                    
                    for (YXTaskModel *temModel in taskList) {
                        if (temModel.taskId == model.taskId) {
                            [taskList removeObject:temModel];
                            break;
                        }
                    }
                    
                    [taskList addObject:newTaskModel];
                    NSLog(@"有后续任务");
                    
                } else { //无后续任务
                    //变成已完成状态
                    for (YXTaskModel *temModel in taskList) {
                        if (temModel.taskId == model.taskId) {
                            temModel.state = 2;
                        }
                    }
                    model.state = 2;
                    if (model.type != 1) {
                        for (YXTaskModel *temModel in taskList) {
                            if (temModel.taskId == model.taskId) {
                                [taskList removeObject:temModel];
                                break;
                            }
                        }
                    }
                    NSLog(@"变成已完成状态,无后续任务");
                    
                }
            }
            if (model.taskId == lastTaskId) {
                [self hideCompletedTaskAlertView];
                self.reportAreaView.taskStatusString = [YXConfigure shared].confModel.taskStatusString;
            }
        }];
    }
}

- (void)dealloc {
    [kNotificationCenter removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    self.textColorType = TextColorWhite;
    [super viewWillAppear:animated];
    [self.headerView animateSwitch:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadConfig];
    
    [self refreshSignStatus];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [YXConfigure shared].confModel.completedTaskAry = @[@(166)];
//    });
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.headerView animateSwitch:NO];
}
- (void)refresh {
//    [self showLoadingView];
    [self pullDownRefreshData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCompletedTaskAlertView];

//    CGRect rect = CGRectMake(90, 130, 230 ,230);
//    YXNinePalaceKeyBoardView *ninePalaceKeyBoardView = [[YXNinePalaceKeyBoardView alloc] initWithFrame:rect allOptions:@"" answer:@""];
//    [self.view addSubview:ninePalaceKeyBoardView];
}
#pragma mark - <action>
- (void)enterMyCareer:(NSInteger)index {
    YXCareerModel *careerModel = [[YXCareerModel alloc] initWithItem:@"learned" bookId:0 sort:1];
    YXCareerViewController *nnc = [[YXCareerViewController alloc] init];
    nnc.selectedIndex = index;
    nnc.careerModel = careerModel;
    //    YXNoteIndex *noteIndex = self.mainModel.noteIndex;
    //    YXBookBrefInfo *bbInfo = [[YXBookBrefInfo alloc] initWithBookId:noteIndex.bookId bookName:noteIndex.bookName wordNum:@""];
    //    nnc.curBookBrefInf = bbInfo;
    [self.navigationController pushViewController:nnc animated:YES];

}

- (void)leftBtnClicked:(id)sender {
    YXPersonalCenterVC *personalVC = [[YXPersonalCenterVC alloc]init];
    [self.navigationController pushViewController:personalVC animated:YES];
}

//搜索
- (void)searchBtnClicked:(id)sender {
    NSLog(@"searchBtnClicked");
    YXSearchVC *VC =  [[YXSearchVC alloc]init];
    [self.navigationController pushViewController:VC animated:NO];
}

- (void)scanBtnClicked:(id)sender {
    NSLog(@"scanBtnClicked");
    
    if ([UIDevice currentDevice].isSimulator) {
        return ;
    }
    
    WBQRCodeVC *scanVC = [[WBQRCodeVC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    //获取正则规则
    NSString *popUpRule = [YXConfigure shared].confModel.baseConfig.popUpRule;
    if (![BSUtils isBlankString:popUpRule]) {
        [YXUserSaveTool setObject:popUpRule forKey:@"popUpRule"];
    }
    else {
        popUpRule = [YXUserSaveTool valueForKey:@"popUpRule"];
    }
    
    scanVC.WBQRCodeVCBlock = ^(NSString *text) {
        
        if ([text hasPrefix:@"http"]) {
            
            YXBaseWebViewController *webVC = [[YXBaseWebViewController alloc] initWithLink:text title:@""];
            [weakSelf.navigationController pushViewController:webVC animated:YES];
            
        } else if ((![BSUtils isBlankString:text]) && (![BSUtils isBlankString:popUpRule])){
            
            NSString *tempStr = [NSString stringWithFormat:@"%@",text];
            
            NSString *result = [weakSelf subStringComponentsSeparatedByStrContent:tempStr strPoint:@"￥" firstFlag:1 secondFlag:2];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", popUpRule];
            
            if ([predicate evaluateWithObject:result]) {
                [weakSelf showWordListView:result];
            }
            else{
                [YXUtils showHUD:weakSelf.view title:@"无效的二维码"];
            }
        }
        else{
            [YXUtils showHUD:weakSelf.view title:@"无效的二维码"];
        }
        
    };
    
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)rightBtnClicked:(id)sender {
    //个人词书
    YXPersonalBookVC *personalVC = [[YXPersonalBookVC alloc]init];
    personalVC.transType = TransationPop;
    [self.navigationController pushViewController:personalVC animated:YES];
}

// 开始答题
- (void)beginReciteBtnClicked:(id)sender {
    
    YXExerciseViewController *exerciseVC = [[YXExerciseViewController alloc] init];
    [self.navigationController pushViewController:exerciseVC animated:YES];
    
    return;
    //有待复习的单词
    if ([self.mainModel.noteIndex.reviewPlan integerValue]) {
        [self beginToStudy:DOMAIN_REVIEWDATA];
    }
    else{
        [self beginToStudy:DOMAIN_STUDYDATA];
    }
}

- (void)checkCalendar {
    YXCalendarViewController *calendarVC = [[YXCalendarViewController alloc] init];
    calendarVC.transType = TransationPop;
}


- (void)modifyPlanBtnClicked:(id)sender {
    if (!self.mainModel) {
        NSLog(@"首页数据加载失败");
        return;
    }
    NSInteger leftWords = [self.mainModel.noteIndex.wordCount integerValue] - [self.mainModel.noteIndex.learned integerValue];
    NSInteger planRemain = [self.mainModel.noteIndex.planRemain integerValue];
    YXBookPlanModel *planModel = [YXBookPlanModel
                                  planModelWith:self.mainModel.noteIndex.bookId
                                  planNum:[self.mainModel.noteIndex.planNum integerValue]
                                  leftWords:leftWords
                                  todayLeftWords:planRemain];
    
    [YXStudyProgressView showProgressInView:self.tabBarController.view
                              withPlanModel:planModel
                               WithDelegate:self];
}

- (void)enterOwnWordBookListClicked:(id)sender {
    NSString *tips = [[NSUserDefaults standardUserDefaults] objectForKey:kUnfinishedWordListNameKey];
    if (!tips) {
        [[NSUserDefaults standardUserDefaults] setObject:kDefaultWordListName forKey:kUnfinishedWordListNameKey];
    }
    self.selectWordTipsL.hidden = YES;
    self.bubble.hidden = YES;
    YXMyWordBookListVC *myWordBookListVC = [[YXMyWordBookListVC alloc] init];
    YXNoteIndex *noteIndex = self.mainModel.noteIndex;
    YXBookBrefInfo *bbInfo = [[YXBookBrefInfo alloc] initWithBookId:noteIndex.bookId bookName:noteIndex.bookName wordNum:@""];
    myWordBookListVC.curBookBrefInf = bbInfo;
    [self.navigationController pushViewController:myWordBookListVC animated:NO];
}

#pragma mark- 开始学习
- (void)beginToStudy:(NSString *)url {
    if (![self checkNetworkStatus]) {
        return;
    }
    if (!self.mainModel.noteIndex) {
        NSLog(@"首页数据获取失败");
        return;
    }
    NSDictionary *param = @{
                            @"bookId" : self.mainModel.noteIndex.bookId
                            };
    [YXUtils showProgress:self.view info:@"正在下载素材包..."];
    [YXDataProcessCenter GET:url parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 待学习单词
            
            [self startExerciseProcess];
            [YXUtils hideHUD:self.view];
//            NSArray *todayWordDics = response.responseObject[@"words"];
//            NSArray *wordIds = [todayWordDics valueForKey:@"wordId"];
//            [YXWordModelManager quardWithWordIds:wordIds completeBlock:^(id obj, BOOL result) {
//                if (result) {
//                    self.todayWords = obj;
//                    [self downLoadWordsMaterials:self.todayWords];
//                }else {
//                    NSLog(@"查询数据失败");
//                    [YXUtils hideHUD:self.view];
//                }
//            }];
        }else {
            [YXUtils hideHUD:self.view];
        }
    }];
}

- (void)downLoadWordsMaterials:(NSMutableArray *)words {
    NSString *bookId = self.mainModel.noteIndex.bookId;
    NSArray *unWords = [self unDowloadWordMaterials:words andBookId:bookId];
    if (unWords.count) {
        [YXWordModelManager downLoadWordMaterials:unWords andBookId:bookId  completeBlock:^(YRHttpResponse *response, BOOL result) {
            [YXUtils hideHUD:self.view];
            if (result) {
                [self startExerciseProcess];
            }
        }];
    }else {
        [YXUtils hideHUD:self.view];
        [self startExerciseProcess];
    }
}

- (void)startExerciseProcess {
    
    //学习单词页面
    YXExerciseVC *exeriseVC = [[YXExerciseVC alloc]init];
    exeriseVC.learningBookId = self.mainModel.noteIndex.bookId;
    //进入单词练习模块
    if ([self.mainModel.noteIndex.reviewPlan intValue]) {
        exeriseVC.exerciseType = YXExerciseReview;
        exeriseVC.disperseCloudView.type = YXExerciseReview;
    }else {
        exeriseVC.exerciseType = YXExerciseNormal;
        exeriseVC.disperseCloudView.type = YXExerciseNormal;
    }
    //传递总学习单词数
    exeriseVC.planRemain = [self.mainModel.noteIndex.planRemain integerValue];
    [self.navigationController pushViewController:exeriseVC animated:YES];
}

- (NSArray *)unDowloadWordMaterials:(NSArray *)words andBookId:(NSString *)bookId{
    NSMutableArray *unWords = [NSMutableArray array];
    // BOOL speech = [YXConfigure shared].confModel.baseConfig.speech;
    for (YXWordDetailModel *word in words) {
        NSString *subpath = [bookId stringByAppendingPathComponent:word.curMaterialSubPath];
        NSString *filepath = [[YXUtils resourcePath] stringByAppendingPathComponent:subpath];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filepath]) {
            [unWords addObject:word];
        }
    }
    return [unWords copy];
}

#pragma mark - <YXStudyProgressViewDelegate>
//- (void)studyProgressViewSetPlan:(YXStudyProgressView *)pView withHttpResponse:(YRHttpResponse *)response {
- (void)setProgressViewSetPlan:(YXSetProgressView *)pView withHttpResponse:(YRHttpResponse *)response {
    if (!response.error) { // 计划设置成功
        [YXUtils showHUD:self.view title:@"学习计划保存成功，将于明天生效"];
        [self loadMainData];
    }else {
        if (response.error.type == kBADREQUEST_TYPE) {
            [self noNetWorkState];
        }
    }
}

#pragma mark - handleData
- (void)loadConfig {
    [self refresh];
}

- (void)pullDownRefreshData {
    if (![self checkNetworkStatus]) {
        [self endRefreshing];
        [self checkPasteboard];
        return;
    }
    __weak typeof(self) weakSelf = self;

    [[YXComHttpService shared] requestConfig:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 成功
            YXConfigModel *configModel = response.responseObject;
            if (!configModel.baseConfig.expandTab) {
                configModel.baseConfig.expandTab = nil;
            }
            if (configModel.baseConfig.bindMobile == 0) { // 显示绑定手机页面
                [weakSelf presentBindViewController];
            } else {
                if (configModel.baseConfig.learning == 0) {
                    [weakSelf presentSelectBookViewController];
                } else {
                    [weakSelf loadMainData];
                }
            }
            self.reportAreaView.taskStatusString = configModel.taskStatusString;
        }else {
            [weakSelf endRefreshing];
            [weakSelf checkPasteboard];
        }
    }];
}

- (void)checkReport {
    [YXDataProcessCenter GET:DOMAIN_LEARNREPORT parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSDictionary *data = [response.responseObject objectForKey:@"learnReport"];
            YXLearnReportModel *reportModel = nil;
            if (data.count) {
                reportModel = [YXLearnReportModel mj_objectWithKeyValues:data];
            }
            self.reportAreaView.reportModel = reportModel;
            //获得url后跳转
            if ([BSUtils isBlankString:reportModel.reportUrl]) {
                [YXUtils showHUD:kWindow title:reportModel.content];
            } else {
                [self enterReportVC];
            }
        }
    }];
}

- (void)endRefreshing {
    [self.mjRefresher endRefreshing];
    [self.loadingView removeFromSuperview];
}

- (void)loadMainData {
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_INDEXINFO
                  modelClass:[YXMainModel class]
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result)
     {
         [weakSelf endRefreshing];
         if (result) {
             YXMainModel *model = response.responseObject;
             weakSelf.mainModel = model;
             [YXConfigure shared].currLearningBookId  = model.noteIndex.bookId;
             [weakSelf refreshContentWith:model];
         }else{
             [weakSelf checkPasteboard];
         }
     }];
}

- (void)loadShowImage {
    [[YXHttpService shared] GET:DEMAIN_STUDYSHAREPICTURE parameters:nil finshedBlock:^(id obj, BOOL result) {
        if (result) {
            NSString *imageUrl = [obj objectForKey:@"imgUrl"];

            [kUserDefault setObject:imageUrl forKey:@"shareBgImage"];
            [kUserDefault synchronize];
        }
    }];
}

#pragma mark - 跳转
- (void)presentBindViewController {
    YXNavigationController *bindVC = [[YXNavigationController alloc] initWithRootViewController:[[YXBindPhoneVC alloc] init]];
    [self presentViewController:bindVC animated:YES completion:^{
        [self endRefreshing];
    }];
}

- (void)presentSelectBookViewController {
    
    /*
    YXArticleSelectVC *vc = [[YXArticleSelectVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    return;
    */

    YXSelectBookVC *selectBookVC = [[YXSelectBookVC alloc]init];
    selectBookVC.hasLeftBarButtonItem = YES;
    __weak typeof(self) weakSelf = self;
    selectBookVC.selectedBookSuccessBlock = ^{
        [weakSelf loadConfig];
    };
    YXNavigationController *selecNaviVC = [[YXNavigationController alloc] initWithRootViewController:selectBookVC];
    [self presentViewController:selecNaviVC animated:NO completion:^{
        [self endRefreshing];
    }];
}

#pragma mark - >>>refresh更新首页数据
- (void)refreshContentWith:(YXMainModel *)model {
    self.headerView.mainModel = model;
    self.naviView.title = model.noteIndex.bookName;

    NSString *title = [NSString stringWithFormat:@"%@ 剩余%@天",kIconFont_pencil, model.noteIndex.remainDay];
    [self.modifyBtn setTitle:title forState:UIControlStateNormal];
    
    self.careerView.haveLearnBtn.number = model.noteRecord.learned;
    self.careerView.collectionbtn.number = model.noteRecord.fav;
    self.careerView.wrongBookbtn.number = model.noteRecord.wrong;
    
    if (![YXFresherGuideView isfresherGuideShowed] && !self.fresherGuideView) { // 是否显新手页
       _fresherGuideView = [YXFresherGuideView showGuideViewToView:self.tabBarController.view
                                       delegate:self];
    } else {
        // MARK: 提醒签到弹窗
        [self remindCheckIn];
    }
    
    [self refreshChartView:model.noteCharts];
    
}

- (void)refreshChartView:(NSArray *)records {
    if (self.chartView) {
        [self.chartView removeFromSuperview];
    }
    // 初始化折线图
    FBYLineGraphView *chartView = [[FBYLineGraphView alloc] initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH - 0, 140)];
    NSArray *array = [[records reverseObjectEnumerator] allObjects];
    [chartView setXMarkTitlesAndValues:array]; // X轴刻度标签及相应的值
    //设置完数据等属性后绘图折线图
    [chartView mapping];
    [self.chartBGView addSubview:chartView];
    _chartView = chartView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    if (point.y > 0) {
        self.scaleBlueView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scaleBlueDefaultHeight);
        if (point.y >=  45) {
            self.naviBGView.alpha = 1.0;
        }else {
            CGFloat alpha = point.y/45.0;
            self.naviBGView.alpha = alpha;
        }
        self.refreshView.alpha = 0;
    } else {
        self.naviBGView.alpha = 0.0;
        if (point.y >= -20) {
            self.refreshView.alpha = 0;//fabs(point.y) / 54
        }else {
            self.refreshView.alpha = (fabs(point.y) - 20) / 44;
        }
        // self.refreshView.alpha = fabs(point.y) / 64;
        CGFloat bleViewY = point.y - self.scaleBlueDefaultHeight;
        self.scaleBlueView.frame = CGRectMake(0, point.y, SCREEN_WIDTH, fabs(bleViewY));
        if (point.y <= -64) {
            //  scrollView.contentOffset = CGPointMake(0, 77);
        }else {
            self.refreshView.currentImageIndex = ((fabs(point.y)-20) / 44) * 10;
        }
    }
}
#pragma mark - actions
//打卡
- (void)showShareOptions:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    if (![NetWorkRechable shared].connected) {
        [YXUtils showHUD:self.view title:@"网络不给力"];
        sender.userInteractionEnabled = YES;
        return;
    }
    [self traceEvent:kTracePunchCardTime descributtion:kTraceCount];
    
    YXShareLodingView *shareLodingView  = [[YXShareLodingView alloc]initWithFrame:self.tabBarController.view.frame];
    
    [self.tabBarController.view addSubview:shareLodingView];
    
    [[YXComHttpService shared] requestPunchShareURL:^(id obj, BOOL result) {
        if (result) {
            NSDictionary *info = [obj objectForKey:@"form"];
            YXPunchModel *punchMode = [YXPunchModel mj_objectWithKeyValues:info];
            [shareLodingView hideLoading];
            [YXPosterShareView showShareInView:self.tabBarController.view punchModel:punchMode block:^(id  _Nonnull obj) {
                
            }];
        }
        sender.userInteractionEnabled = YES;
        [shareLodingView hideLoading];
    }];
}

- (void)rightButtonAction {
    if (self.mainModel.bookFinished) { // 该书已学完
        [self presentSelectBookViewController];
    }else { // oneMoreGroup
        [self beginToStudy:DOMAIN_ONEGROUP];
    }
}
#pragma mark - <YXFresherGuideViewDelegate>
- (CGRect)fresherGuideViewBlankArea:(YXFresherGuideView *)fresherView stepIndex:(NSInteger)step {
    if (step == 3) {
        UIButton *learnedBtn = self.careerView.haveLearnBtn;
        CGRect rect = [learnedBtn convertRect:learnedBtn.bounds toView:nil];
        CGFloat bottom = CGRectGetMaxY(rect);
        if (self.contentScroll.height < bottom) {
            CGFloat offsetY = bottom - self.contentScroll.height + 20;
            [self.contentScroll setContentOffset:CGPointMake(0, offsetY) animated:NO];
        }
        rect = [learnedBtn convertRect:learnedBtn.bounds toView:nil];
        rect.origin.x = 0;
        rect.size.width = SCREEN_WIDTH;
        //  rect.size.height += 10;
        return rect;
    }else if(step == 2) {
        CGRect rect = [self.modifyBtn convertRect:self.modifyBtn.bounds toView:self.view];
        rect.size.width = 100;
        return rect;
    } else if(step == 4) {
        CGRect rect = [self.calendarBtn convertRect:self.calendarBtn.bounds toView:nil];
        CGFloat bottom = CGRectGetMaxY(rect);
        // 如果显示不全则滑动后展示引导图
        if (self.contentScroll.height < bottom) {
            CGFloat offsetY = bottom - self.contentScroll.height + 150.f;
            [self.contentScroll setContentOffset:CGPointMake(0, offsetY) animated:NO];
        }
        rect = [self.reportAreaView.markBtn convertRect:self.reportAreaView.markBtn.bounds toView:nil];
        return rect;
    }
    return CGRectZero;
}

- (void)fresherGuideViewGuideFinished:(YXFresherGuideView *)fresherView {
    [self.contentScroll setContentOffset:CGPointZero animated:YES];
    [self remindCheckIn];
}
#pragma mark - subViews
- (YXComNaviView *)naviView {
    if (!_naviView) {
        YXComNaviView *naviView = [[YXComNaviView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight)];
        naviView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:naviView];
        naviView.leftButton.hidden = YES;
        
        //搜索
        [naviView setRightButtonNormalImage:[UIImage imageNamed:@"Main扫一扫"]
                            hightlightImage:[UIImage imageNamed:@"Main扫一扫"]];
        [naviView.rightButton addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [naviView.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        
        CGFloat top = kStatusBarHeight + 1;
        
        UIButton *bookBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, top, 60, 40)];
        
        [bookBtn setImage:[UIImage imageNamed:@"main_book_btn"] forState:UIControlStateNormal];
        [bookBtn setImage:[UIImage imageNamed:@"main_book_btn_press"] forState:UIControlStateHighlighted];
        [bookBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [naviView addSubview:bookBtn];
        
        
        UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, top, 60, 40)];

        [searchBtn setImage:[UIImage imageNamed:@"Search_main"] forState:UIControlStateNormal];
        [searchBtn setImage:[UIImage imageNamed:@"Search_main"] forState:UIControlStateHighlighted];
        [searchBtn addTarget:self action:@selector(searchBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [naviView addSubview:searchBtn];
        
        naviView.titleLabel.textColor = [UIColor whiteColor];
        naviView.titleLabel.font = [UIFont systemFontOfSize:19];
        naviView.titleLabel.text = @"--";
        [naviView.titleLabel setFrame:CGRectMake(50.0, top, SCREEN_WIDTH-70-10-160.0,40)];
        
        _naviView = naviView;
    }
    return _naviView;
}

- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        UIScrollView *contentScroll = [[UIScrollView alloc] init]; //WithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
        contentScroll.showsVerticalScrollIndicator = NO;
        contentScroll.delegate = self;
        contentScroll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentScroll];
        _contentScroll = contentScroll;
    }
    return _contentScroll;
}

- (UIImageView *)naviBGView {
    if (!_naviBGView) {
        UIImageView *naviBGView = [[UIImageView alloc] init];
        naviBGView.image = [UIImage imageNamed:@"scaleBgImage"];
        naviBGView.alpha = 0;
        [self.naviView insertSubview:naviBGView atIndex:0];
        _naviBGView = naviBGView;
    }
    return _naviBGView;
}

- (UIImageView *)scaleBlueView {
    if (!_scaleBlueView) {
        UIImageView *scaleBlueView = [[UIImageView alloc] init];
        scaleBlueView.image = [UIImage imageNamed:@"scaleBgImage"];
        [self.contentScroll addSubview:scaleBlueView];
        _scaleBlueView = scaleBlueView;
    }
    return _scaleBlueView;
}

- (YXSpringAnimateButton *)myWordBookBtn {
    if (!_myWordBookBtn) {
        YXSpringAnimateButton *myWordBookBtn = [[YXSpringAnimateButton alloc] init];
        [myWordBookBtn addTarget:self action:@selector(enterOwnWordBookListClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myWordBookBtn setBackgroundImage:[UIImage imageNamed:@"myWordBookIcon"] forState:UIControlStateNormal];
        [self.headerView addSubview:myWordBookBtn];
        _myWordBookBtn = myWordBookBtn;
        [_myWordBookBtn setHidden:YES];
    }
    return _myWordBookBtn;
}

- (UILabel *)selectWordTipsL {
    if (!_selectWordTipsL) {
        UIImageView *bubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tipsBubble"]];
        
        [self.headerView addSubview:bubble];
        bubble.hidden = YES;
        _bubble = bubble;
        UILabel *selectWordTipsL = [[UILabel alloc] init];
        selectWordTipsL.hidden = YES;
        selectWordTipsL.text = @"按单元选择想要学习的单词进行“学习”或“听写”";
        selectWordTipsL.numberOfLines = 0;
        selectWordTipsL.preferredMaxLayoutWidth = AdaptSize(135);
        selectWordTipsL.textColor = UIColorOfHex(0x59B2F3);
        selectWordTipsL.font = [UIFont pfSCRegularFontWithSize:AdaptSize(12)];
        selectWordTipsL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTips)];
        [selectWordTipsL addGestureRecognizer:tap];
        [self.headerView addSubview:selectWordTipsL];
        _selectWordTipsL = selectWordTipsL;
        
        CGFloat tbMargin = AdaptSize(5);
        
        [bubble mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(selectWordTipsL).insets(UIEdgeInsetsMake(-tbMargin, -AdaptSize(13), -tbMargin, -tbMargin));
        }];
    }
    return _selectWordTipsL;
}

- (void)tapTips {
    NSString *tips = [[NSUserDefaults standardUserDefaults] objectForKey:kUnfinishedWordListNameKey];
    if (!tips) {
        [[NSUserDefaults standardUserDefaults] setObject:kDefaultWordListName forKey:kUnfinishedWordListNameKey];
    }
    self.selectWordTipsL.hidden = YES;
    self.bubble.hidden = YES;
}


- (UIButton *)modifyBtn {
    if (!_modifyBtn) {
        UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [modifyBtn addTarget:self action:@selector(modifyPlanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        modifyBtn.titleLabel.font = [UIFont iconFontWithSize:12];
        [modifyBtn setBackgroundImage:[UIImage imageNamed:@"main_modify_btn"] forState:UIControlStateNormal];
        [self.headerView addSubview:modifyBtn];
        _modifyBtn = modifyBtn;
    }
    return _modifyBtn;
}

- (YXMainBGView *)headerView {
    if (!_headerView) {
        YXMainBGView *headerView = [[YXMainBGView alloc] init];
        [headerView.beginReciteBtn addTarget:self action:@selector(beginReciteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.shareBtn addTarget:self action:@selector(showShareOptions:) forControlEvents:UIControlEventTouchUpInside];
        [headerView.rightBtn addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentScroll addSubview:headerView];
        _headerView = headerView;
    }
    return _headerView;
}

- (UIView *)chartBGView {
    if (!_chartBGView) {
        UIView *chartBGView = [[UIView alloc] init];
        [self.contentScroll addSubview:chartBGView];
        _chartBGView = chartBGView;
    }
    return _chartBGView;
}

- (YXRefreshView *)refreshView {
    if (!_refreshView) {
        YXRefreshView *refreshView = [[YXRefreshView alloc] initWithFrame:CGRectMake(0, 4, SCREEN_WIDTH, 60)];
        refreshView.alpha = 0;
        [self.headerView addSubview:refreshView];
        _refreshView = refreshView;
    }
    return _refreshView;
}

- (YXRefreshNormalHeader *)mjRefresher {
    if (!_mjRefresher) {
        YXRefreshNormalHeader *header = [YXRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefreshData)];
        self.contentScroll.mj_header = header;
        header.delegate = self.refreshView;
        // [self.contentScroll bringSubviewToFront:self.contentScroll.mj_header];
        _mjRefresher = header;
    }
    return _mjRefresher;
}

- (void)showLoadingView {
    if (_loadingView) {
        [self.loadingView removeFromSuperview];
    }
    YXLoadingView *loadingView = [[YXLoadingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:loadingView];
    _loadingView  = loadingView;
}

//任务中心、学习报告
- (YXMainItemsView *)reportAreaView {
    if (!_reportAreaView) {
        YXMainItemsView *reportAreaView = [[YXMainItemsView alloc] init];
        __weak typeof(self) weakSelf = self;
        
        reportAreaView.checkReportBlock = ^(NSInteger index) {
            NSLog(@"%ld",index);
            //任务中心
            if (0 == index){
                [weakSelf enterTaskVC];
            }
            //学习报告
            else if (1 == index){
                [self checkReport];// 检测报告
            }
            //课文读背
            else if (2 == index){
                [weakSelf enterArticleSelectVC];
            }
            //打卡日历
            else if (3 == index){
                [weakSelf enterCalendarVC];
            }
            //自选单词
            else if (4 == index){
                [weakSelf enterOwnWordBookListClicked:nil];
            }

        };
        
        [self.contentScroll addSubview:reportAreaView];
        _reportAreaView = reportAreaView;
    }
    return _reportAreaView;
}


-(void)enterArticleSelectVC{
    YXArticleSelectVC *vc = [[YXArticleSelectVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterReportVC {
    YXBaseWebViewController *webVC = [[YXBaseWebViewController alloc] initWithLink:self.reportAreaView.reportModel.reportUrl title:@"学习报告"];
    [self.navigationController pushViewController:webVC animated:YES];
//    替换成了Web页
//    YXReportViewController *reportVC = [[YXReportViewController alloc] init];
//    [self.navigationController pushViewController:reportVC animated:YES];
}

- (void)enterTaskVC {
    [self.reportAreaView layoutIfNeeded];
    YXMissionViewController *missionViewController = [[YXMissionViewController alloc] init];
    [self.navigationController pushViewController:missionViewController animated:YES];
}
- (void)enterCalendarVC {
    YXCalendarViewController *calendarVC = [[YXCalendarViewController alloc] init];
    calendarVC.transType = TransationPop;
    [self.navigationController pushViewController:calendarVC animated:YES];
}

- (YXNNCareerView *)careerView {
    if (!_careerView) {
        _careerView = [[YXNNCareerView alloc] init];
        __weak typeof(self) weakSelf = self;
        _careerView.careerViewClickedBlock = ^(NSInteger index) {
            [weakSelf enterMyCareer:index];
        };
        [self.contentScroll addSubview:_careerView];
    }
    return _careerView;
}

#pragma mark - 签到

- (void)remindCheckIn {
    //判断Key是不是今天
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dailyCheckIn = [defaults objectForKey:kDailyCheckInNotify];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"YYYY-MM-dd";
    NSDate *today = [NSDate date];
    NSString *todayStampStr = [format stringFromDate:today];
    
    if (![dailyCheckIn isEqualToString:todayStampStr]) {
        //网络请求
        [YXDataProcessCenter GET:DOMAIN_SIGNININFO parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
            if (result) {
                NSDictionary *userSignInInfo = [response.responseObject objectForKey:@"userSignInInfo"];
                YXMissionSignModel *model = [YXMissionSignModel mj_objectWithKeyValues:userSignInInfo];
                NSString *checkDays = [self convert10ToStrAry:[self toBinarySystemWithDecimalSystem:model.userSignIn.integerValue]];
                NSInteger weekday = [self getWeekDayFordate];
                NSArray *ary = model.baseScore;
                switch (weekday) {
                    case 0:weekday = [ary[weekday] integerValue];break;
                    case 1:weekday = [ary[weekday] integerValue];break;
                    case 2:weekday = [ary[weekday] integerValue];break;
                    case 3:weekday = [ary[weekday] integerValue];break;
                    case 4:weekday = [ary[weekday] integerValue];break;
                    case 5:weekday = [ary[weekday] integerValue];break;
                    case 6:weekday = [ary[weekday] integerValue] + model.multiplierScore.integerValue * checkDays.length;break;
                    default:break;
                }
                
                if (!model.isTodayCheck){
                    [self showToCheckAlertViewWith:checkDays.length credits:weekday todayStr:todayStampStr];
                    NSLog(@"去存入今日时间到本地");
                }
                else{
                    //判断复制分享码
                    [self checkPasteboard];
                }
                
            } else {
                NSLog(@"请求失败");
                //判断复制分享码
                [self checkPasteboard];
            }
        }];
    } else {
        NSLog(@"今日时间已经存在本地了");
        //判断复制分享码
        [self checkPasteboard];
    }
}

- (void)showToCheckAlertViewWith:(NSInteger)days credits:(NSInteger)credits todayStr:(NSString *)todayStampStr {
    if ([[self currentVisibleViewController] isKindOfClass: [self class]]) {
        
        YXMissionToCheckinView *alertView = [[YXMissionToCheckinView alloc] init];
        __weak typeof(self) weakself = self;
        __weak typeof(alertView) weakAlert = alertView;
        alertView.checkSuccessBlock = ^{
            __strong typeof(weakAlert) strongAlert = weakAlert;
            weakself.reportAreaView.isTodayCheckin = YES;
            [weakself hideCheckView:strongAlert];
            [weakself checkPasteboard];
        };
        alertView.credits = credits;
        alertView.days = days;
        [self.tabBarController.view addSubview:alertView];
        // 存今天时间到本地
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:todayStampStr forKey:kDailyCheckInNotify];
        [defaults synchronize];
    }
}

//十进制转二进制
- (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal {
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;//余数
    NSInteger divisor = 0;//除数
    NSString * prepare = @"";
    while (true){
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",(long)remainder];
        if (divisor == 0) {
            break;
        }
    }
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --) {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    return result;
}

- (NSString *)convert10ToStrAry:(NSString *)str {
    NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:@[@0,@0,@0,@0,@0,@0,@0]];
    for (NSInteger i = 0; i < str.length; i++) {
        if ([[str substringWithRange:NSMakeRange(i, 1)]  isEqual: @"1"]) {
            ary[6 - (i + 7 - str.length)] = @"1";
        }
    }
    NSMutableString *temStr = [[NSMutableString alloc] initWithString:@""];
    for (NSInteger i = 0; i < ary.count; i++) {
        if ([ary[i]  isEqual: @"1"]) {
            [temStr appendString: [NSMutableString stringWithFormat:@"%zd",i + 1] ];
        }
    }
    return temStr;
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
    
- (void)enterReportViewController {
    YXReportViewController *reportVC = [[YXReportViewController alloc] init];
    [self.navigationController pushViewController:reportVC animated:YES];
}

#pragma mark -- 签到信息
- (void)refreshSignStatus {
    [YXTaskViewModel getSigninInfofinshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            YXMissionSignModel *model = response.responseObject;
            self.reportAreaView.isTodayCheckin = model.isTodayCheck;
        }
    }];
}

#pragma mark - 飞豆子动画
- (void)hideCompletedTaskAlertView {
    if (self.beansAnimateView) {
        [self.beansAnimateView removeFromSuperview];
    }
    UITabBar *tabbar = self.tabBarController.tabBar;
    CGPoint targetPoint = [tabbar convertPoint:CGPointMake(SCREEN_WIDTH / 6 * 5, tabbar.height * 0.5) toView:nil];
    CGSize size = _alertView.douzi.size;
    CGPoint startPoint = [_alertView.douzi convertPoint:CGPointMake(size.height * 0.5, size.width * 0.5) toView:nil];
    __weak typeof(self) weakSelf = self;
    self.beansAnimateView = [YXBeansAnimateView showBeansAnimateViewWithBeanCount:_alertView.completedTaskModelAry.count
                                                                        fromPoint:startPoint
                                                                          toPoint:targetPoint
                                                                      finishBlock:^{
                                                                          __strong typeof(weakSelf) strongSelf = weakSelf;
                                                                          [strongSelf.alertView removeFromSuperview];
                                                                        }];
}

// 每日打卡隐藏动画
- (void)hideCheckView:(YXMissionToCheckinView *)checkView {
    if (self.beansAnimateView) {
        [self.beansAnimateView removeFromSuperview];
    }
    UITabBar *tabbar = self.tabBarController.tabBar;
    CGPoint targetPoint = [tabbar convertPoint:CGPointMake(SCREEN_WIDTH / 6 * 5, tabbar.height * 0.5) toView:nil];
    CGSize size = checkView.douzi.size;//
    CGPoint startPoint = [checkView.douzi convertPoint:CGPointMake(size.height * 0.5, size.width * 0.5) toView:nil];
    self.beansAnimateView = [YXBeansAnimateView showBeansAnimateViewWithBeanCount:1
                                                                        fromPoint:startPoint
                                                                          toPoint:targetPoint
                                                                      finishBlock:^{
                                                                          [checkView removeFromSuperview];
                                                                      }];
}


-(void)checkShareCode:(NSString *)code;
{
    //获取内容
    NSString *string = code;
    
    //获取正则规则
    NSString *popUpRule = [YXConfigure shared].confModel.baseConfig.popUpRule;
    if (![BSUtils isBlankString:popUpRule]) {
        [YXUserSaveTool setObject:popUpRule forKey:@"popUpRule"];
    }
    else {
        popUpRule = [YXUserSaveTool valueForKey:@"popUpRule"];
    }
    
    if ([[self currentViewController] isKindOfClass:[YXExerciseVC class]] || [[self currentViewController] isKindOfClass:[YXStudyResultVC class]]){
        return ;
    }
    
    if ((![BSUtils isBlankString:string]) && (![BSUtils isBlankString:popUpRule])){
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",string];
        NSString *result = [self subStringComponentsSeparatedByStrContent:tempStr strPoint:@"￥" firstFlag:1 secondFlag:2];
        NSLog(@"result %@",result);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", popUpRule];
        
        if ([predicate evaluateWithObject:result]) {
            [self showWordListView:result];
        }
    }
    
}


-(void)checkPasteboard
{
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    
    //获取正则规则
    NSString *popUpRule = [YXConfigure shared].confModel.baseConfig.popUpRule;
    if (![BSUtils isBlankString:popUpRule]) {
        [YXUserSaveTool setObject:popUpRule forKey:@"popUpRule"];
    }
    else {
        popUpRule = [YXUserSaveTool valueForKey:@"popUpRule"];
    }
    
    if ([[self currentViewController] isKindOfClass:[YXExerciseVC class]] || [[self currentViewController] isKindOfClass:[YXStudyResultVC class]]){
        return ;
    }
    
    if ((![BSUtils isBlankString:string]) && (![BSUtils isBlankString:popUpRule])){
        
        NSString *tempStr = [NSString stringWithFormat:@"%@",string];
        NSString *result = [self subStringComponentsSeparatedByStrContent:tempStr strPoint:@"￥" firstFlag:1 secondFlag:2];
        NSLog(@"result %@",result);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", popUpRule];
        
        if ([predicate evaluateWithObject:result]) {
            [self showWordListView:result];
        }
    }

}


//查询复制码 对应的词单

-(void)showWordListView:(NSString *)code{
    
    if (code.length) {
        NSDictionary *param = @{@"shareCode" : code};
        [YXDataProcessCenter GET:DOMAIN_SHARECODEWORDLIST
                      parameters:param
                    finshedBlock:^(YRHttpResponse *response, BOOL result)
         {
             if (result) {
                 
                 NSDictionary *details = [response.responseObject objectForKey:@"wordListSimplifiedDetails"];
                 NSLog(@"details %@",details);
                 
                 YXMyWordListDetailModel *detailModel = [YXMyWordListDetailModel mj_objectWithKeyValues:details];
                 
                 //移除 YXWordDetailShareView
                 for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
                     if ([view isKindOfClass:[YXWordDetailShareView class]]) {
                         [view removeFromSuperview];
                     }
                 }
                 
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
                 
             }else {
                 
                 YXMyWordListDetailModel *detailModel =  [YXMyWordListDetailModel alloc];
                 detailModel.code = response.error.code;
                 [YXWordDetailShareView showShareInView:[UIApplication sharedApplication].keyWindow delegate:self detailModel:detailModel];
                 //                 [YXUtils showHUD:nil title:response.error.desc];
             }
         }];
    }
}


#pragma mark - 封装一个截取字符串中同一个字符之间的字符串
/**
 参数说明：
 1.strContent:传入的目标字符串
 2.strPoint:标记位的字符
 3.firstFlag:从第几个目标字符开始截取
 4.secondFlag:从第几个目标字符结束截取
 */
- (NSString *)subStringComponentsSeparatedByStrContent:(NSString *)strContent strPoint:(NSString *)strPoint firstFlag:(int)firstFlag secondFlag:(int)secondFlag
{
    // 初始化一个起始位置和结束位置
    NSRange startRange = NSMakeRange(0, 1);
    NSRange endRange = NSMakeRange(0, 1);
    
    // 获取传入的字符串的长度
    NSInteger strLength = [strContent length];
    // 初始化一个临时字符串变量
    NSString *temp = nil;
    // 标记一下找到的同一个字符的次数
    int count = 0;
    // 开始循环遍历传入的字符串，找寻和传入的 strPoint 一样的字符
    for(int i = 0; i < strLength; i++)
    {
        // 截取字符串中的每一个字符,赋值给临时变量字符串
        temp = [strContent substringWithRange:NSMakeRange(i, 1)];
        // 判断临时字符串和传入的参数字符串是否一样
        if ([temp isEqualToString:strPoint]) {
            // 遍历到的相同字符引用计数+1
            count++;
            if (firstFlag == count)
            {
                // 遍历字符串，第一次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第一次遍历到的相同字符的位置，赋值给起始截取的位置
                startRange = NSMakeRange(i, 1);
            }
            else if (secondFlag == count)
            {
                // 遍历字符串，第二次遍历到和传入的字符一样的字符
                NSLog(@"第%d个字是:%@", i, temp);
                // 将第二次遍历到的相同字符的位置，赋值给结束截取的位置
                endRange = NSMakeRange(i, i);
            }
        }
    }
    // 根据起始位置和结束位置，截取相同字符之间的字符串的范围
    //异常处理、未找到开始结束的位置、或者只找到开头
    if ((startRange.location == endRange.location)||(startRange.location > endRange.location)) {
        return @"";
    }
    NSRange rangeMessage = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    // 根据得到的截取范围，截取想要的字符串，赋值给结果字符串
    NSString *result = [strContent substringWithRange:rangeMessage];
    // 打印一下截取到的字符串，看看是否是想要的结果
    NSLog(@"截取到的 strResult = %@", result);
    // 最后将结果返回出去
    return result;
}


#pragma mark - YXWordDetailShareViewDelegate
- (void)YXWordDetailShareViewSureDetailModel:(YXMyWordListDetailModel *)detailModel{
    YXMyWordBookDetailVC *detailVC = [[YXMyWordBookDetailVC alloc] initWithMyWordBookModel:detailModel];
    detailVC.isOwnWordList = detailModel.isSelf;
    
    for (UIView *view in [[UIApplication sharedApplication].keyWindow subviews]) {
        
        if ([view isKindOfClass:[YXStudyProgressView class]] || [view isKindOfClass:[YXComAlertView class]] || [view isKindOfClass:[YXPosterShareView class]] || [view isKindOfClass:[YXTipsBaseView class]] )
            [view removeFromSuperview];
    }
    
    if ([self isKindOfClass:[YXMainVC class]]) {
        for (UIView *view in [self.tabBarController.view subviews]) {
            if ([view isKindOfClass:[YXStudyProgressView class]])
                [view removeFromSuperview];
        }
    }
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)YXWordDetailShareViewSureDetailReload{
    //获取复制内容
    NSString *string = [UIPasteboard generalPasteboard].string;
    if (![BSUtils isBlankString:string]){
        [self showWordListView:string];
    }
}


//拿到当前的控制器
- (UIViewController *)currentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result = nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    } else {
        result = nextResponder;
    }
    return result;
}

@end



/*
 
 
 
 @property (nonatomic, strong) NSMutableArray *beans;
 
 - (NSMutableArray *)beans {
 if (!_beans) {
 _beans = [NSMutableArray array];
 }
 return _beans;
 }
 
 - (void)hideCompletedTaskAlertView {
 for (UIImageView  *bean in self.beans) {
 [bean removeFromSuperview];
 }
 [self.beans removeAllObjects];
 
 UITabBar *tabbar = self.tabBarController.tabBar;
 CGPoint targetPoint = [tabbar convertPoint:CGPointMake(SCREEN_WIDTH / 6 * 5, tabbar.height * 0.5) toView:nil];
 CGSize size = _alertView.douzi.size;
 CGPoint startPoint = [_alertView.douzi convertPoint:CGPointMake(size.height * 0.5, size.width * 0.5) toView:nil];
CGFloat midXStartEndPoint = (startPoint.x + targetPoint.x) * 0.5;
CGFloat maxHeightReferStartPoint = 100;
CGFloat controlPointMargin = (targetPoint.x - startPoint.x) * 0.25;
CGPoint controlPoint1 = CGPointMake(midXStartEndPoint - controlPointMargin, startPoint.y - maxHeightReferStartPoint);
CGPoint controlPoint2 = CGPointMake(midXStartEndPoint + controlPointMargin, startPoint.y - maxHeightReferStartPoint);
UIBezierPath *path = [UIBezierPath bezierPath];
[path moveToPoint:startPoint];
[path addCurveToPoint:targetPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
pathAnimation.path = path.CGPath;

CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
rotateAnimation.removedOnCompletion = YES;
rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
rotateAnimation.toValue = [NSNumber numberWithFloat:4 * M_PI];
rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];

CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
scaleAnimation.removedOnCompletion = NO;
scaleAnimation.values = @[@1,@1.2,@0.2];

CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
alphaAnimation.removedOnCompletion = NO;
alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
alphaAnimation.toValue = [NSNumber numberWithFloat:0.1];


CAAnimationGroup *groups = [CAAnimationGroup animation];
groups.animations = @[pathAnimation,rotateAnimation, scaleAnimation, alphaAnimation];
groups.duration = 0.6;
groups.removedOnCompletion=NO;
groups.fillMode=kCAFillModeForwards;
groups.delegate = self;

CFTimeInterval now = CACurrentMediaTime();
for (NSInteger i = 0; i < _alertView.completedTaskModelAry.count; i++) {
    UIImageView *bean = [[UIImageView alloc] init];
    bean.image = [UIImage imageNamed:@"goldBeanImage"];
    bean.frame = CGRectMake(0, 0, 30, 20);
    bean.center = startPoint;
    groups.beginTime = now + 0.1 * i;
    [[UIApplication sharedApplication].delegate.window addSubview:bean];
    [bean.layer addAnimation:groups forKey:@"group"];
    [self.beans addObject:bean];
}

//    [UIView animateWithDuration:0.25 animations:^{
//        bean.center = targetPoint;
//    } completion:^(BOOL finished) {
//        [bean removeFromSuperview];
//        [_alertView removeFromSuperview];
//    }];
}

#pragma mark - <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    for (UIImageView *bean in self.beans) {
        if ([[bean.layer animationForKey:@"group"] isEqual:anim]) {
            [bean removeFromSuperview];
            [self.beans removeObject:bean];
            break;
        }
    }
    
    if (self.beans.count == 0) {
        [_alertView removeFromSuperview];
    }
}

*/











/** before 1.3.1
 #pragma mark - >>>>>>>>>>>>>>>>>
 - (void)reloadChatView {
 for (UIView *view in self.contentScroll.subviews) {
 if ([view isKindOfClass:[XLineChart class]]) {
 [view removeFromSuperview];
 }
 }
 
 NSMutableArray *itemArray = [[NSMutableArray alloc] init];
 NSMutableArray *numberArray = [NSMutableArray array];
 NSMutableArray *dataDiscribeArray = [NSMutableArray array];
 
 NSInteger maxNum = 0;
 for (ChartsData *data in self.mainModel.note_charts.data) {
 if (data.num.intValue > maxNum) {
 maxNum = data.num.intValue;
 }
 [numberArray addObject:[NSNumber numberWithInt:data.num.intValue]];
 [dataDiscribeArray addObject:[YXUtils formatDateStr:data.date]];
 }
 
 XLineChartItem* item =
 [[XLineChartItem alloc] initWithDataNumberArray:numberArray
 color:XJYWhite];
 [itemArray addObject:item];
 
 XAreaLineChartConfiguration* configuration =
 [[XAreaLineChartConfiguration alloc] init];
 configuration.isShowPoint = YES;
 configuration.lineMode = Straight;
 configuration.ordinateDenominator = 6;
 configuration.isEnableNumberLabel = YES;
 XLineChart* lineChart =
 [[XLineChart alloc] initWithFrame:CGRectMake(0, 662-kNavHeight, SCREEN_WIDTH, 137)
 dataItemArray:itemArray
 dataDiscribeArray:dataDiscribeArray
 topNumber:[NSNumber numberWithInteger:maxNum]
 bottomNumber:@0
 graphMode:AreaLineGraph
 chartConfiguration:configuration];
 [self.contentScroll addSubview:lineChart];
 }
 
 - (void)showSelectedBookVc {
 YXSelectBookVC *selectBookVC = [[YXSelectBookVC alloc]init];
 [self.navigationController presentViewController:selectBookVC animated:NO completion:nil];
 }
 
 - (void)showSelectBookView {
 if (![YXConfigure shared].loginModel.learning.bookid.length) {
 YXSelectBookVC *versionVC = [[YXSelectBookVC alloc]init];
 versionVC.transType = TransationPresent;
 YXNavigationController *nav = [[YXNavigationController alloc]initWithRootViewController:versionVC];
 AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
 [app.window.rootViewController presentViewController:nav animated:NO completion:nil];
 }
 }
 */
//- (void)popBadges {
//    if (_curIndex < self.bages.count) {
//        YXBadgeModel *badgeModel = [self.bages objectAtIndex:_curIndex];
//        //         = [[YXConfigure shared] badgeModelWith:currentBadgeId];
//        __weak typeof(self) weakSelf = self;
//        [YXBadgeView showBadgeViewWithModel:badgeModel finishBlock:^{
//            _curIndex ++;
//            [weakSelf popBadges];
//        }];
//    }
//}
//
//if (self.bages) {
//    return;
//}
//YXBadgeListModel *blm = [YXConfigure shared].confModel.badgeList.firstObject;
//self.bages = blm.options;
//[self popBadges];

/**
 self.titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,45 , SCREEN_WIDTH, 17)];
 self.titleLab.textAlignment = NSTextAlignmentCenter;
 self.titleLab.textColor = UIColorOfHex(0xffffff);
 self.titleLab.text = @"今日待学习";
 self.titleLab.font = [UIFont systemFontOfSize:16];
 [self.studyCardView addSubview:self.titleLab];
 
 self.wordNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.titleLab.bottom + 15, SCREEN_WIDTH, 45)];
 self.wordNumLab.textAlignment = NSTextAlignmentCenter;
 self.wordNumLab.textColor = UIColorOfHex(0xffffff);
 self.wordNumLab.text = @"--";
 self.wordNumLab.font = [UIFont systemFontOfSize:59];
 [self.studyCardView addSubview:self.wordNumLab];
 
 self.totalStudyTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.wordNumLab.bottom + 40, SCREEN_WIDTH/2.0, 17)];
 self.totalStudyTitleLab.textAlignment = NSTextAlignmentCenter;
 self.totalStudyTitleLab.textColor = UIColorOfHex(0xffffff);
 self.totalStudyTitleLab.text = @"学习进度";
 self.totalStudyTitleLab.font = [UIFont systemFontOfSize:15];
 [self.studyCardView addSubview:self.totalStudyTitleLab];
 
 self.totalStudyLab = [[UILabel alloc]initWithFrame:CGRectMake(0, self.totalStudyTitleLab.bottom + 15, SCREEN_WIDTH/2.0, 17)];
 self.totalStudyLab.textAlignment = NSTextAlignmentCenter;
 self.totalStudyLab.textColor = UIColorOfHex(0xffffff);
 self.totalStudyLab.text = @"--/--";
 self.totalStudyLab.font = [UIFont systemFontOfSize:20];
 [self.studyCardView addSubview:self.totalStudyLab];
 
 self.dayLeftTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, self.totalStudyTitleLab.top, SCREEN_WIDTH/2.0, 17)];
 self.dayLeftTitleLab.textAlignment = NSTextAlignmentCenter;
 self.dayLeftTitleLab.textColor = UIColorOfHex(0xffffff);
 self.dayLeftTitleLab.text = @"剩余天数";
 self.dayLeftTitleLab.font = [UIFont systemFontOfSize:15];
 [self.studyCardView addSubview:self.dayLeftTitleLab];
 
 self.dayLeftLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, self.dayLeftTitleLab.bottom + 15, SCREEN_WIDTH/2.0, 17)];
 self.dayLeftLab.textAlignment = NSTextAlignmentCenter;
 self.dayLeftLab.textColor = UIColorOfHex(0xffffff);
 self.dayLeftLab.text = @"--";
 self.dayLeftLab.font = [UIFont systemFontOfSize:20];
 [self.studyCardView addSubview:self.dayLeftLab];
 
 self.centerLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2.0, self.dayLeftTitleLab.top, 0.5, 47.0)];
 self.centerLine.backgroundColor = UIColorOfHex(0xB2D2FF);
 self.centerLine.alpha = 1;
 [self.studyCardView addSubview:self.centerLine];
 
 self.reciteTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0,300 , SCREEN_WIDTH, 15)];//
 self.reciteTitleLab.textAlignment = NSTextAlignmentCenter;
 self.reciteTitleLab.textColor = UIColorOfHex(0xC1D3FE);
 self.reciteTitleLab.text = @"有40个单词待复习";
 self.reciteTitleLab.hidden = YES;
 self.reciteTitleLab.font = [UIFont systemFontOfSize:15];
 [self.studyCardView addSubview:self.reciteTitleLab];
 */

//- (UIView *)studyCardView {
//    if (!_studyCardView) {
//        UIView *studyCardView = [[UIView alloc] init];
//        studyCardView.backgroundColor = [UIColor clearColor];
//        [self.contentScroll addSubview:studyCardView];
//        _studyCardView = studyCardView;
//    }
//    return _studyCardView;
//}
