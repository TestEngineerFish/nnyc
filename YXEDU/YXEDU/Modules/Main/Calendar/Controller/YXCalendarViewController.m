//
//  YXCalendarViewController.m
//  YXEDU
//
//  Created by 沙庭宇 on 2019/4/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCalendarViewController.h"
#import "YXCalendarHeaderView.h"
#import "YXCalendarBookCell.h"
#import "YXCalendarWordCell.h"
#import "YXCalendarStudyMonthData.h"
#import "YXCalendarStudydayData.h"
#import "YXWordDetailModel.h"
#import "NSDate+Extension.h"
#import "YXBasePickverView.h"
#import "YXCalendarShareView.h"
#import "YXCalendarFresherGuideView.h"
#import "YXCalendarMonthSummaryView.h"
#import "YXCalendarMonthDataView.h"
#import "YXNoNetworkView.h"
#import "Reachability.h"
#import "YXCareerNoteWordInfoModel.h"
#import "YXCareerWordInfo.h"
#import "YXWordDetailViewController.h"

static NSString *const kYXCalendarCellID = @"YXCalendarCellID";
static NSString *const kYXCalendarHeaderViewID = @"YXCalendarHeaderViewID";
static NSString *const kRemoveDatePickView = @"RemovePickerView";

static CGFloat const kHeaderHeight = 44.f;
static CGFloat const kCellHeight = 40.f;
static CGFloat const kPickViewHeight = 272.f;

@interface YXCalendarViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, YXBasePickverViewDelegate, YXCalendarFresherGuideViewDelegate, YXCalendarUpdateData, CalendarShareViewDelegate>
@property (nonatomic, copy) NSDate *currentSelectedDate;//选中的具体日期
@property (nonatomic, copy) NSDate *currentTitleDate;//标题显示的月份

//navigation view
@property (nonatomic, strong) YXComNaviView *naview;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIButton *calendarBtn;
@property (nonatomic, strong) UIButton *chartBtn;
//fresher guide view
@property (nonatomic, weak) YXCalendarFresherGuideView *fresherGuideView;
//calendar and chart view
@property (nonatomic, strong) UIScrollView *contentScroll;
@property (nonatomic, strong) YXCalendarMonthDataView *monthDataView;
//result view
@property (nonatomic, strong) YXCalendarMonthSummaryView *monthSummaryView;
@property (nonatomic, strong) UILabel *studyDaysLabel;
@property (nonatomic, strong) UILabel *studyWordsLabel;
@property (nonatomic, strong) UILabel *studyTimesLabel;
@property (nonatomic, strong) UIView  *noResultsView;
@property (nonatomic, strong) UIView  *noNetworkViewWithCalendar;
//table view
@property (nonatomic, strong) UILabel *tableTitleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *word;
//pickView
@property (nonatomic, strong) YXBasePickverView *datePickView;
@property (nonatomic, strong) UIView *datePickBackgroundView;
// data
@property (nonatomic, strong) YXCalendarStudyMonthData *monthData;
@property (nonatomic, strong) YXCalendarStudyDayData *dayData;
@property (nonatomic, strong) NSDictionary<NSString *, UIImage *> *studiedDate;//显示已学习状态
@property (nonatomic, strong) NSTimer *timer;
// share
@property (nonatomic, strong) UIImageView *shareImageIcon;
@property (nonatomic, strong) YXCalendarShareView *shareView;

@end

@implementation YXCalendarViewController
@synthesize currentTitleDate = _currentTitleDate;

- (void)setCurrentSelectedDate:(NSDate *)currentDate {
    _currentSelectedDate = currentDate;
    [self getDailyData:currentDate];
    if (currentDate.year == [NSDate new].year) {
        self.tableTitleLabel.text = [NSString stringWithFormat:@"%lu月%lu日的学习数据", (unsigned long)currentDate.month, (unsigned long)currentDate.day];
    } else {
        self.tableTitleLabel.text = [NSString stringWithFormat:@"%lu年%lu月%lu日的学习数据", (unsigned long)currentDate.year, (unsigned long)currentDate.month, (unsigned long)currentDate.day];
    }
}

- (NSDate *)currentTitleDate {
    if (!_currentTitleDate) {
        _currentTitleDate = [NSDate new];
    }
    return _currentTitleDate;
}

- (void)setCurrentTitleDate:(NSDate *)currentTitleDate {

    if (currentTitleDate.year == [NSDate new].year) {
        [self.naview.titleLabel setText:[NSString stringWithFormat:@"%zu月",currentTitleDate.month]];
    } else {
        NSString *title = [NSString stringWithFormat:@"%zu年%zu月",currentTitleDate.year, currentTitleDate.month];
        [self.naview.titleLabel setText:title];
    }
    NSLog(@"更新了currentTitleDate,当前的日期是: %@", self.naview.titleLabel.text);
    _currentTitleDate = currentTitleDate;
    [self getMonthlyData:currentTitleDate];
}

- (void)setDayData:(YXCalendarStudyDayData *)dayData {
    _dayData = dayData;
    if (dayData == nil) {
        [self showNoNetWorkView];
    } else if ([dayData.learningData.studyTimes isEqualToString:@"0"]) {
        [self showNoResultsView];
    } else {
        [self showTableView];
        [self.tableView reloadData];
    }
}

#pragma mark - SubViews
- (YXComNaviView *)naview {
    if (!_naview) {
        _naview = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonWhite];
        _naview.backgroundColor = UIColor.clearColor;
        UIImage *bgImage = [UIImage imageNamed:@"calendar_bg"];
        UIImageView *naviBGImageView = [[UIImageView alloc] initWithImage:bgImage];
        naviBGImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight);
        naviBGImageView.contentMode = UIViewContentModeTop;
        [_naview insertSubview:naviBGImageView atIndex:0];
        [_naview.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [_naview setRightButtonView:self.rightView];
        _naview.titleLabel.textColor = UIColor.whiteColor;
        _naview.arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down_white"]];
        __weak typeof(self) weakSelf = self;
        _naview.clickBlock = ^{
            [weakSelf showPickView];
        };
    }
    return _naview;
}

- (UIScrollView *)contentScroll {
    if (!_contentScroll) {
        UIScrollView *contentScroll = [[UIScrollView alloc] init];
        contentScroll.showsVerticalScrollIndicator = NO;
        contentScroll.delegate = self;
        contentScroll.backgroundColor = UIColor.whiteColor;
        contentScroll.translatesAutoresizingMaskIntoConstraints = NO;
        _contentScroll = contentScroll;
    }
    return _contentScroll;
}

- (UIView *)rightView {
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.frame = CGRectMake(SCREEN_WIDTH - 95, kStatusBarHeight + 1, 80, 30);
        _rightView.backgroundColor = UIColor.clearColor;
        _rightView.layer.cornerRadius = _rightView.height/2.f;
        _rightView.layer.borderWidth = 1.0f;
        _rightView.layer.borderColor = UIColor.whiteColor.CGColor;
        [_rightView setClipsToBounds:YES];
        
        [_rightView addSubview:self.calendarBtn];
        [_rightView addSubview:self.chartBtn];
    }
    return _rightView;
}

- (UIButton *)calendarBtn {
    if (!_calendarBtn) {
        _calendarBtn = [[UIButton alloc] init];
        _calendarBtn.frame = CGRectMake(0, 0, _rightView.width/2.f, _rightView.height);
        [_calendarBtn setImage:[UIImage imageNamed:@"calendar_icon_selected"] forState:UIControlStateSelected];
        [_calendarBtn setImage:[UIImage imageNamed:@"calendar_icon_unselect"] forState:UIControlStateNormal];
        _calendarBtn.backgroundColor = UIColor.whiteColor;
        [_calendarBtn setSelected:YES];
        [_calendarBtn addTarget:self action:@selector(showCalendarView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _calendarBtn;
}

- (UIButton *)chartBtn {
    if (!_chartBtn) {
        _chartBtn = [[UIButton alloc] init];
        _chartBtn.frame = CGRectMake(self.calendarBtn.width, 0, _rightView.width/2.f, _rightView.height);
        [_chartBtn setImage:[UIImage imageNamed:@"chart_icon_selected"] forState:UIControlStateSelected];
        [_chartBtn setImage:[UIImage imageNamed:@"chart_icon_unselect"] forState:UIControlStateNormal];
        _chartBtn.backgroundColor = UIColor.clearColor;
        [_chartBtn setSelected: NO];
        [_chartBtn addTarget:self action:@selector(showChartView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chartBtn;
}

- (YXCalendarMonthDataView *)monthDataView {
    if (!_monthDataView) {
        YXCalendarMonthDataView *view = [YXCalendarMonthDataView showDataView];
        view.chartView.delegate = self;
        view.calendarView.delegate = self;
        view.calendarView.dataSource = self;
        _monthDataView = view;
    }
    return _monthDataView;
}

- (YXCalendarMonthSummaryView *)monthSummaryView {
    if (!_monthSummaryView) {
        YXCalendarMonthSummaryView *monthSummaryView = [[YXCalendarMonthSummaryView alloc] init];
        monthSummaryView.backgroundColor = UIColor.clearColor;
        _monthSummaryView = monthSummaryView;
    }
    return _monthSummaryView;
}

- (UILabel *)tableTitleLabel {
    if (!_tableTitleLabel) {
        UILabel *tableTitleLabel = [[UILabel alloc] init];
        tableTitleLabel.font = [UIFont systemFontOfSize:16.f];
        tableTitleLabel.textColor = [UIColor colorWithRed:67/255.0 green:74/255.0 blue:93/255.0 alpha:1.0];
        tableTitleLabel.text = @"--月--号学习数据";
        _tableTitleLabel = tableTitleLabel;
    }
    return _tableTitleLabel;
}

//没有结果的默认页面
- (UIView *)noResultsView {
    if (!_noResultsView) {
        UIView *defaultResultView = [[UIView alloc] init];
        defaultResultView.backgroundColor = UIColor.clearColor;
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"no_data_icon"];
        [defaultResultView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(defaultResultView);
            make.top.equalTo(defaultResultView).with.offset(-20);
            make.width.and.height.mas_equalTo(AdaptSize(60.f));
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"当天没有学习数据哦~";
        label.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        label.textColor = UIColorOfHex(0x8095AB);
        [defaultResultView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(defaultResultView);
            make.top.equalTo(imageView.mas_bottom).with.offset(5.f);
        }];
        _noResultsView = defaultResultView;
    }
    return _noResultsView;
}

- (UIView *)noNetworkViewWithCalendar {
    if (!_noNetworkViewWithCalendar) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColor.clearColor;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToReload)];
        [view addGestureRecognizer:tap];

        UIImageView *noNetworkImageView = [[UIImageView alloc] init];
        noNetworkImageView.image = [UIImage imageNamed:@"no_network_icon"];
        noNetworkImageView.contentMode = UIViewContentModeScaleAspectFit;

        UILabel *aboveNoNetworkLabel = [[UILabel alloc] init];
        UILabel *belowNoNetworkLabel = [[UILabel alloc] init];

        [view addSubview:noNetworkImageView];
        [view addSubview:aboveNoNetworkLabel];
        [view addSubview:belowNoNetworkLabel];

        [noNetworkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view);
            make.top.equalTo(view);
            make.width.and.height.mas_equalTo(AdaptSize(60.f));
        }];

        aboveNoNetworkLabel.text = @"网络有些问题";
        aboveNoNetworkLabel.textColor = UIColorOfHex(0x849EC5);
        aboveNoNetworkLabel.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
        [aboveNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noNetworkImageView.mas_bottom).offset(20);
            make.centerX.equalTo(view);
        }];

        belowNoNetworkLabel.text = @"点击屏幕重试";
        belowNoNetworkLabel.textColor = UIColorOfHex(0x849EC5);
        belowNoNetworkLabel.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
        [belowNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aboveNoNetworkLabel.mas_bottom).offset(8);
            make.centerX.equalTo(view);
        }];
        _noNetworkViewWithCalendar = view;
    }
    return _noNetworkViewWithCalendar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        [tableView registerClass:[YXCalendarHeaderView class] forHeaderFooterViewReuseIdentifier:kYXCalendarHeaderViewID];
        [tableView registerClass:[YXCalendarWordCell class] forCellReuseIdentifier:kYXCalendarCellID];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.clearColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.sectionHeaderHeight = kHeaderHeight;
        tableView.sectionFooterHeight = 1.f;
        tableView.rowHeight = kCellHeight;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, AdaptSize(8.f), 0.f);
        tableView.backgroundColor = UIColor.clearColor;
        tableView.scrollEnabled = NO;
        _tableView = tableView;
    }
    return _tableView;
}

- (YXBasePickverView *)datePickView {
    if (!_datePickView) {
        YXBasePickverView *datePickView = [YXBasePickverView showCalendarPickerViewOn:[NSString stringWithFormat:@"%zu,%zu", self.currentSelectedDate.year, self.currentSelectedDate.month] withDelegate:self];
        datePickView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kPickViewHeight);
        datePickView.backgroundColor = UIColor.clearColor;
        [kWindow addSubview:datePickView];
        _datePickView = datePickView;
    }
    return _datePickView;
}

- (UIView *)datePickBackgroundView {
    if (!_datePickBackgroundView) {
        UIView *datePickBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        datePickBackgroundView.backgroundColor = UIColor.blackColor;
        [datePickBackgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePickerView:)]];
        datePickBackgroundView.alpha = 0.5f;
        [kWindow addSubview:datePickBackgroundView];
        _datePickBackgroundView = datePickBackgroundView;
    }
    return _datePickBackgroundView;
}

- (UIImageView *)shareImageIcon {
    if (!_shareImageIcon) {
        _shareImageIcon = [[UIImageView alloc] init];
        _shareImageIcon.frame = CGRectMake(SCREEN_WIDTH - 70.f, SCREEN_HEIGHT - 70.f - kSafeBottomMargin, 50.f, 50.f);
        _shareImageIcon.layer.cornerRadius = 25.f;
        _shareImageIcon.image = [UIImage imageNamed:@"share_calendar_icon"];
        [_shareImageIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShareView:)];
        [_shareImageIcon addGestureRecognizer:tap];
    }
    return _shareImageIcon;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickerView:) name:kRemoveDatePickView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged) name:kReachabilityChangedNotification object:nil];
    if (![YXCalendarFresherGuideView isFresherGuideShowed]) {
        _fresherGuideView = [YXCalendarFresherGuideView showGuideViewToView:self.tabBarController.view delegate:self];
    }
    [UIView animateWithDuration:1 animations:^{
        self.shareImageIcon.transform = CGAffineTransformTranslate(self.shareImageIcon.transform, 45, 0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)_initUI {

    self.currentSelectedDate = [NSDate new];
    self.currentTitleDate    = [NSDate new];

    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.naview];
    [self.view addSubview:self.contentScroll];
    [self.contentScroll addSubview:self.monthDataView];
    [self.contentScroll addSubview:self.monthSummaryView];
    [self.contentScroll addSubview:self.tableTitleLabel];
    [self.view addSubview:self.shareImageIcon];
    [self.view bringSubviewToFront:self.shareImageIcon];
    
    [self.naview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kNavHeight);
    }];
    
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.bottom.equalTo(self.view).with.offset(-kSafeBottomMargin);
    }];

    [self.monthDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll);
        make.left.right.equalTo(self.contentScroll);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(1.15f);
    }];

    [self.monthSummaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthDataView.mas_bottom).with.offset(-110.f);
        make.left.equalTo(self.monthDataView).with.offset(15.f);
        make.right.equalTo(self.monthDataView).with.offset(-15.f);
        make.height.mas_equalTo(150.f);
    }];
    
    [self.tableTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthSummaryView.mas_bottom).with.offset(20.f);
        make.left.right.equalTo(self.monthDataView);
        make.height.mas_equalTo(16.f);
    }];
}

- (NSArray *)setupChartData {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSUInteger days = [self.currentTitleDate daysInMonth];
    NSMutableArray<NSMutableDictionary *> *dataArray = [NSMutableArray arrayWithCapacity:days];
    NSDate *firstDate = [self.currentTitleDate begindayOfMonth];
    //生成本月数据列表
    for (int i = 0; i < days; ++i) {
        NSDate *nextDay = [firstDate offsetDays:i];
        NSDictionary *dict = @{@"date":nextDay,
                               @"numWord":@1,//默认显示1,不然XJYkChart控件为空时比较丑
                               @"costTime":@0,
                               @"status":@0
                               };
        [dataArray addObject: [NSMutableDictionary dictionaryWithDictionary:dict]];
    }
    //根据后台返回数据,修改有数据天的值
    for (YXNodeModel *node in self.monthData.studyDetail) {
        NSDate *date = [dateFormatter dateFromString:node.date];
        int index = (int)[date day] - 1;
        dataArray[index][@"numWord"] = [node.num isEqualToNumber:@0] ? @1 : node.num;
        dataArray[index][@"costTime"] = node.costTime;
        dataArray[index][@"status"] = node.status;
    }
    return dataArray;
}

#pragma mark - datas
- (void)getMonthlyData:(NSDate *)date {
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"year" : @(date.year), @"month" : @(date.month)};
    [YXDataProcessCenter GET:DOMAIN_CALENDARMONTHLYDATA parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        [YXUtils hideHUD:self.view];
        if (result) {
            YXCalendarStudyMonthData *monthdata = [YXCalendarStudyMonthData mj_objectWithKeyValues:response.responseObject];
            weakSelf.monthData = monthdata;
            //更新日历组件,(因为用户可能通过PickView选择月份)
            if (weakSelf.monthDataView.calendarView.currentPage.year != date.year || weakSelf.monthDataView.calendarView.currentPage.month != date.month) {
                [weakSelf.monthDataView.calendarView setCurrentPage:date animated:YES];
            }
            [weakSelf.monthDataView.calendarView reloadData];
            //更新月统计结果
            [weakSelf.monthSummaryView updateView:monthdata.summary];
            //更新图表组件
            [weakSelf.monthDataView.chartView setDataArray:[weakSelf setupChartData] selected:[NSNumber numberWithUnsignedInteger:weakSelf.currentSelectedDate.day - 1]];
            [self.monthDataView.calendarView selectDate:self.currentSelectedDate scrollToDate:NO];
            if (self.currentSelectedDate.day == self.monthDataView.calendarView.today.day) {
                self.monthDataView.calendarView.appearance.borderSelectionColor = UIColorOfHex(0x2FC7FF);
                self.monthDataView.calendarView.appearance.selectionColor = UIColor.whiteColor;
                self.monthDataView.calendarView.appearance.titleSelectionColor = UIColorOfHex(0x59C6F3);
            } else {
                self.monthDataView.calendarView.appearance.borderSelectionColor = UIColor.whiteColor;
                self.monthDataView.calendarView.appearance.selectionColor = UIColor.clearColor;
                self.monthDataView.calendarView.appearance.titleSelectionColor = UIColor.whiteColor;
            }
        }
    }];
}

- (void)getDailyData: (NSDate *)date {
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    NSNumber *year = [NSNumber numberWithUnsignedInteger:date.year];
    NSNumber *month = [NSNumber numberWithUnsignedInteger:date.month];
    NSNumber *day = [NSNumber numberWithUnsignedInteger:date.day];
    NSDictionary *param = @{@"year" : year, @"month" : month, @"day" : day};
    [YXDataProcessCenter GET:DOMAIN_CALENDARDAILYDATA parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        [YXUtils hideHUD:self.view];
        if (result) {
            YXCalendarStudyDayData *dailyData = [YXCalendarStudyDayData mj_objectWithKeyValues:response.responseObject];
            self.dayData = dailyData;
        }else {
            self.dayData = nil;
        }
    }];
}

# pragma mark - Event

- (void)showCalendarView:(UIButton *)btn {
    if (!btn.isSelected) {
        [btn setSelected:YES];
        btn.backgroundColor = UIColor.whiteColor;
        [self.chartBtn setSelected:NO];
        self.chartBtn.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:0.5 animations:^{
            self.monthDataView.screenShowView.transform = CGAffineTransformTranslate(self.monthDataView.screenShowView.transform, self.monthDataView.calendarView.width, 0);
        }];
    }
}

- (void)showChartView:(UIButton *)btn {
    if (!btn.isSelected) {
        //设置选中的cell与日历同步,如果不是本月则不显示选中状态
        if (self.currentTitleDate.year == self.currentSelectedDate.year && self.currentTitleDate.month == self.currentSelectedDate.month) {

            [self.monthDataView.chartView setDataArray:[self setupChartData] selected:[NSNumber numberWithUnsignedInteger:self.currentSelectedDate.day - 1]];
        } else {
            [self.monthDataView.chartView setDataArray:[self setupChartData] selected:nil];
        }
        [btn setSelected:YES];
        btn.backgroundColor = UIColor.whiteColor;
        [self.calendarBtn setSelected:NO];
        self.calendarBtn.backgroundColor = UIColor.clearColor;
        [UIView animateWithDuration:0.5 animations:^{
            self.monthDataView.screenShowView.transform = CGAffineTransformTranslate(self.monthDataView.screenShowView.transform, -self.monthDataView.calendarView.width, 0);
        }];
    }
}

- (void)showReviewWordsList: (UITapGestureRecognizer *)sender {
    self.dayData.showReviewList = !self.dayData.showReviewList;
    NSUInteger amountCell = self.dayData.reviewBooksList.count;
    CGFloat amountCellHeight = amountCell * kCellHeight;
    if (self.dayData.showReviewList) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(20.f);
            make.left.equalTo(self.monthDataView).offset(20.f);
            make.right.equalTo(self.monthDataView).offset(-20.f);
            make.height.mas_equalTo(self.tableView.height + amountCellHeight);
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(20.f);
            make.left.equalTo(self.monthDataView).offset(20.f);
            make.right.equalTo(self.monthDataView).offset(-20.f);
            make.height.mas_equalTo(self.tableView.height - amountCellHeight);
        }];
    }
    [self.tableView reloadData];
}

- (void)showStudyWordsList: (UITapGestureRecognizer *)sender {
    self.dayData.showStudiedList = !self.dayData.showStudiedList;
    NSUInteger amountCell = self.dayData.studiedBooksList.count;
    CGFloat amountCellHeight = amountCell * kCellHeight;
    if (self.dayData.showStudiedList) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(20.f);
            make.left.equalTo(self.monthDataView).offset(20.f);
            make.right.equalTo(self.monthDataView).offset(-20.f);
            make.height.mas_equalTo(self.tableView.height + amountCellHeight);
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(20.f);
            make.left.equalTo(self.monthDataView).offset(20.f);
            make.right.equalTo(self.monthDataView).offset(-20.f);
            make.height.mas_equalTo(self.tableView.height - amountCellHeight);
        }];
    }
    [self.contentScroll layoutIfNeeded];
    [self.tableView reloadData];
}

- (void)showPickView {
    [self datePickBackgroundView];
    [self datePickView];
    [self.datePickView.customPicker selectRow:self.currentTitleDate.year - 1970 inComponent:0 animated:YES];
    [self.datePickView.customPicker reloadComponent:1];
    [self.datePickView.customPicker selectRow:self.currentTitleDate.month - 1 inComponent:1 animated:YES];
    self.naview.arrowIcon.image = [UIImage imageNamed:@"arrow_up_white"];
    self.view.userInteractionEnabled = YES;
    self.datePickBackgroundView.userInteractionEnabled = NO;
    self.datePickBackgroundView.alpha = 0.5f;
    [UIView animateWithDuration:0.25 animations:^{
        self.datePickView.frame = CGRectMake(0, SCREEN_HEIGHT - kPickViewHeight,SCREEN_WIDTH, kPickViewHeight);
    } completion:^(BOOL finished) {
        self.view.userInteractionEnabled = YES;
        self.datePickBackgroundView.userInteractionEnabled = YES;
    }];
}

- (void)removePickerView:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        self.datePickView.transform = CGAffineTransformTranslate(self.datePickView.transform, 0, kPickViewHeight);
        self.datePickBackgroundView.alpha = 0;
        self.naview.arrowIcon.image = [UIImage imageNamed:@"arrow_down_white"];
    } completion:^(BOOL finished) {
        [self.datePickBackgroundView removeFromSuperview];
        [self.datePickView removeFromSuperview];
        self.datePickBackgroundView = nil;
        self.datePickView = nil;
    }];
}

- (void)networkChanged {
    [self getMonthlyData:self.currentTitleDate];
    [self getDailyData:self.currentSelectedDate];
}

- (void)showShareView:(UITapGestureRecognizer *)sender {
    __weak typeof(self) weakSelf = self;
    if (CGRectGetMaxX(self.shareImageIcon.frame) > SCREEN_WIDTH) {
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.shareImageIcon.transform = CGAffineTransformTranslate(self.shareImageIcon.transform, -45, 0);
        }];
    } else {
        if (!self.monthData) {
            return;
        }
        self.shareView = [YXCalendarShareView showCompletedViewWithMonthDate:self.monthData];
        self.shareView.delegate = self;
        [kWindow addSubview:self.shareView];
        [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        [self.shareView layoutIfNeeded];
    }
}

- (void)showTableView {
    if (self.noResultsView) {
        [self.noResultsView removeFromSuperview];
        self.noResultsView = nil;
    }
    if (self.noNetworkViewWithCalendar) {
        [self.noNetworkViewWithCalendar removeFromSuperview];
        self.noNetworkViewWithCalendar = nil;
    }
    [self tableView];
    [self.contentScroll addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(20.f);
        make.left.equalTo(self.contentScroll).with.offset(20.f);
        make.right.equalTo(self.contentScroll).with.offset(-20.f);
        make.width.equalTo(self.monthDataView).with.offset(-40.f);
        make.height.mas_equalTo(kHeaderHeight * 3.f);
    }];
    [self.contentScroll mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView);
    }];
}

- (void)showNoResultsView {
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    if (self.noNetworkViewWithCalendar) {
        [self.noNetworkViewWithCalendar removeFromSuperview];
        self.noNetworkViewWithCalendar = nil;
    }
    [self noResultsView];
    [self.contentScroll addSubview:self.noResultsView];
    [self.noResultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(30.f + kSafeBottomMargin);
        make.left.equalTo(self.contentScroll).with.offset(20.f);
        make.right.equalTo(self.contentScroll).with.offset(-20.f);
        make.width.equalTo(self.monthDataView).with.offset(-40.f);
        make.height.mas_equalTo(AdaptSize(80.f));
    }];
    [self.contentScroll mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(kNavHeight, 0, kSafeBottomMargin, 0));
        make.bottom.equalTo(self.noResultsView).with.offset(30.f);
    }];
}

- (void)showNoNetWorkView {
    if (self.tableView) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    if (self.noResultsView) {
        [self.noResultsView removeFromSuperview];
        self.noResultsView = nil;
    }

    [self noNetworkViewWithCalendar];
    [self.contentScroll addSubview:self.noNetworkViewWithCalendar];
    [self.noNetworkViewWithCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableTitleLabel.mas_bottom).with.offset(30.f + kSafeBottomMargin);
        make.left.equalTo(self.contentScroll).with.offset(20.f);
        make.right.equalTo(self.contentScroll).with.offset(-20.f);
        make.width.equalTo(self.monthDataView).with.offset(-40.f);
        make.height.mas_equalTo(AdaptSize(140.f));
    }];
    [self.contentScroll mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.noNetworkViewWithCalendar).with.offset(30.f);
    }];
}

- (void)back {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tapToReload {
    [self getDailyData:self.currentSelectedDate];
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dayData) {
            return self.dayData.showReviewList ? self.dayData.reviewBooksList.count : 0;
        }
        return 0;
    } else if (section == 1) {
        if (self.dayData) {
            return self.dayData.showStudiedList? self.dayData.studiedBooksList.count : 0;
        }
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXCalendarHeaderView *headerView = [[YXCalendarHeaderView alloc] initWithReuseIdentifier:kYXCalendarHeaderViewID];
    [headerView setHeaderViewWithSection:section data:self.dayData];
    if (section == 0) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showReviewWordsList:)];
        [headerView addGestureRecognizer:tap];
    } else if (section == 1) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStudyWordsList:)];
        [headerView addGestureRecognizer:tap];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *foodView = [[UIView alloc] init];
    foodView.backgroundColor = UIColor.clearColor;
    return section == 2 ? [[UIView alloc] init] : foodView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row >= self.dayData.reviewBooksList.count) {
            return [UITableViewCell new];
        }
        YXCalendarBookModel *book = self.dayData.reviewBooksList[indexPath.row];
        if (book.isWork) {
            YXCalendarWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCalendarCellID forIndexPath:indexPath];
            [cell setCell:book];
            return cell;
        } else {
            YXCalendarBookCell *cell = [[YXCalendarBookCell alloc] init];
            [cell setCell:book];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row >= self.dayData.studiedBooksList.count) {
            return [UITableViewCell new];
        }
        YXCalendarBookModel *book = self.dayData.studiedBooksList[indexPath.row];
        if (book.isWork) {
            YXCalendarWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCalendarCellID forIndexPath:indexPath];
            [cell setCell:book];
            return cell;
        } else {
            YXCalendarBookCell *cell = [[YXCalendarBookCell alloc] init];
            [cell setCell:book];
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCalendarBookModel *model;
    if (indexPath.section == 0) {
        model = self.dayData.reviewBooksList[indexPath.row];
    } else if (indexPath.section == 1) {
        model = self.dayData.studiedBooksList[indexPath.row];
    }

    if (!model || !model.wordModel) {
        return;
    }
    YXWordDetailViewController *wdvc = [YXWordDetailViewController wordDetailWith:model.wordModel bookId:model.wordModel.bookId];
    [self.navigationController pushViewController:wdvc animated:YES];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    if (CGRectGetMaxX(self.shareImageIcon.frame) < SCREEN_WIDTH) {
        [UIView animateWithDuration:0.25 animations:^{
            self.shareImageIcon.transform = CGAffineTransformTranslate(self.shareImageIcon.transform, 45, 0);
        }];
    }
}

#pragma mark - FSCalendarDelegate, FSCalendarDataSource

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.currentSelectedDate = date;
    NSDate *today = calendar.today;
    if (date == today) {
        self.monthDataView.calendarView.appearance.borderSelectionColor = UIColorOfHex(0x2FC7FF);
        self.monthDataView.calendarView.appearance.selectionColor = UIColor.whiteColor;
        self.monthDataView.calendarView.appearance.titleSelectionColor = UIColorOfHex(0x59C6F3);
    } else {
        self.monthDataView.calendarView.appearance.borderSelectionColor = UIColor.whiteColor;
        self.monthDataView.calendarView.appearance.selectionColor = UIColor.clearColor;
        self.monthDataView.calendarView.appearance.titleSelectionColor = UIColor.whiteColor;
    }
    //扯淡的滑动
    [calendar selectDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSLog(@"我滑动选择了新的月份: %zu", calendar.currentPage.month);
    self.currentTitleDate = calendar.currentPage;
}

- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return self.monthData.punchedDateDict[dateStr];
}

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    return [dateformatter dateFromString:@"1970-01-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar {
    return [NSDate new];
}

#pragma mark - FSCalendarDelegateAppearance
//已学习或者已打卡的背景色显示为: [UIColor colorWithWhite:1 alpha:0.55];
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateformatter stringFromDate:date];
    // 已学习
    if ([self.monthData.studiedDateDict.allKeys containsObject:key]) {
        return [UIColor colorWithWhite:1 alpha:0.55];
    }
    // 已打卡的肯定学习过了
    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
        return [UIColor colorWithWhite:1 alpha:0.55];
    }
    return nil;
}

// 已学习或者已打卡的字体颜色显示为: UIColorOfHex(0x3AC8FC)
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *key = [dateformatter stringFromDate:date];
    if ([self.monthData.studiedDateDict.allKeys containsObject:key]) {
        return UIColorOfHex(0x3AC8FC);
    }
    // 已打卡的肯定学习过了
    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
        return UIColorOfHex(0x3AC8FC);
    }
    return nil;
}

#pragma mark - YXBasePickverViewDelegate
- (void)basePickverView:(YXBasePickverView *)pickverView withSelectedTitle:(NSString *)title {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:title];
    self.currentTitleDate = date;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveDatePickView object:nil];
}

#pragma mark - <YXCalendarFresherGuideViewDelegate>
- (CGRect)fresherGuideViewBlankArea:(YXCalendarFresherGuideView *)frensherView stepIndex:(NSInteger)step {
    if (step == 1) {
        CGRect rect = [self.rightView convertRect:self.rightView.bounds toView:self.view];
        return rect;
    }
    return CGRectZero;
}

- (void)stepPrecondition:(NSInteger)step {
//    if (step == 2) {
//        [self showChartView:self.chartBtn];
//    }
}

#pragma mark - <YXCalendarUpdateData>

- (void)updateCalendarWithDate:(NSInteger)idx {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";

    NSString *dateStr = [NSString stringWithFormat: @"%zd-%zd-%ld", self.currentTitleDate.year, self.currentTitleDate.month, idx + 1];
    NSDate *selectedDate = [dateFormatter dateFromString:dateStr];
    if ([[NSDate new] compare:selectedDate] == NSOrderedDescending) {
        self.currentSelectedDate = selectedDate;
        [self.monthDataView.calendarView selectDate:selectedDate];
    }
}

#pragma mark - CalendarShareViewDelegate
- (void)closeShareViewBlock {
    [UIView animateWithDuration:1 animations:^{
        self.shareImageIcon.transform = CGAffineTransformTranslate(self.shareImageIcon.transform, 45, 0);
    }];
}

- (void)reloadShareData {

}

@end
