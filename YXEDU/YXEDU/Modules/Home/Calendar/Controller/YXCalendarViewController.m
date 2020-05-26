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
#import "NSDate+Extension.h"
#import "YXBasePickverView.h"
#import "YXCalendarMonthSummaryView.h"
#import "YXCalendarMonthDataView.h"
#import "Reachability.h"
#import "YXComNaviView.h"

static NSString *const kYXCalendarCellID       = @"YXCalendarCellID";
static NSString *const kYXCalendarHeaderViewID = @"YXCalendarHeaderViewID";
static NSString *const kRemoveDatePickView     = @"RemovePickerView";

static CGFloat const kHeaderHeight   = 44.f;
static CGFloat const kCellHeight     = 25.f;
static CGFloat const kPickViewHeight = 272.f;

@interface YXCalendarViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, YXBasePickverViewDelegate, YXCalendarUpdateData>
@property (nonatomic, copy) NSDate *currentSelectedDate;//选中的具体日期
@property (nonatomic, copy) NSDate *currentTitleDate;//标题显示的月份

//navigation view
@property (nonatomic, strong) YXComNaviView *naview;
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
@property (nonatomic, strong) UIView *tableContainerView;
@property (nonatomic, strong) UIImageView *fruitIcon;
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
@property (nonatomic, assign) BOOL showReportButotn;

@end

@implementation YXCalendarViewController
@synthesize currentTitleDate = _currentTitleDate;

- (YXCalendarStudyMonthData *)monthData {
    if (!_monthData) {
        _monthData = [[YXCalendarStudyMonthData alloc] init];
    }
    return _monthData;
}

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
    YXLog(@"更新了currentTitleDate,当前的日期是: %@", self.naview.titleLabel.text);
    _currentTitleDate = currentTitleDate;
    [self getMonthlyData:currentTitleDate];
}

- (void)setDayData:(YXCalendarStudyDayData *)dayData {
    _dayData = dayData;
    if (dayData == nil) {
        [self showNoNetWorkView];
    } else if (dayData.review_item.count > 0 || dayData.study_item.count > 0) {
        [self showTableView];
        [self.tableView reloadData];
    } else {
        [self showNoResultsView];
    }
}

#pragma mark - SubViews
- (YXComNaviView *)naview {
    if (!_naview) {
        _naview = [YXComNaviView comNaviViewWithLeftButtonType:YXNaviviewLeftButtonWhite];
        _naview.backgroundColor = [UIColor gradientColorWith:CGSizeMake(kSCREEN_WIDTH, kNavHeight) colors:@[UIColorOfHex(0xFFC671), UIColorOfHex(0xFFA83E)] direction:GradientDirectionTypeLeftTop];
        [_naview.leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
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
        [contentScroll setScrollEnabled:YES];
        _contentScroll = contentScroll;
    }
    return _contentScroll;
}

- (YXCalendarMonthDataView *)monthDataView {
    if (!_monthDataView) {
        YXCalendarMonthDataView *view = [YXCalendarMonthDataView showDataView];
        view.chartView.delegate      = self;
        view.calendarView.delegate   = self;
        view.calendarView.dataSource = self;
        _monthDataView = view;
    }
    return _monthDataView;
}

- (YXCalendarMonthSummaryView *)monthSummaryView {
    if (!_monthSummaryView) {
        YXCalendarMonthSummaryView *monthSummaryView = [[YXCalendarMonthSummaryView alloc] init];
        monthSummaryView.backgroundColor     = UIColor.whiteColor;
        monthSummaryView.layer.cornerRadius  = AdaptSize(6);
        monthSummaryView.layer.shadowColor   = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:0.5].CGColor;
        monthSummaryView.layer.shadowOffset  = CGSizeMake(0,0);
        monthSummaryView.layer.shadowOpacity = 1;
        monthSummaryView.layer.shadowRadius  = 10;
        _monthSummaryView                    = monthSummaryView;

    }
    return _monthSummaryView;
}

- (UIImageView *)fruitIcon {
    if (!_fruitIcon) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fruit_icon"]];
        _fruitIcon = imageView;
    }
    return _fruitIcon;
}

- (UIView *)tableContainerView {
    if (!_tableContainerView) {
        UIView * view = [[UIView alloc] init];
        view.backgroundColor = UIColor.whiteColor;
        [view.layer setDefaultShadowWithCornerRadius:10.0 shadowRadius:10.0];
        _tableContainerView = view;
    }
    return _tableContainerView;
}

- (UILabel *)tableTitleLabel {
    if (!_tableTitleLabel) {
        UILabel *tableTitleLabel  = [[UILabel alloc] init];
        tableTitleLabel.font      = [UIFont regularFontOfSize:AdaptSize(12)];
        tableTitleLabel.textColor = UIColorOfHex(0x888888);
        tableTitleLabel.text      = @"--月--号学习数据";
        _tableTitleLabel          = tableTitleLabel;
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
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [defaultResultView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(defaultResultView);
            make.top.equalTo(defaultResultView).with.offset(-20);
            make.width.mas_equalTo(AdaptSize(178.f));
            make.height.mas_equalTo(AdaptSize(109.f));
        }];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"当天没有学习数据哦~";
        label.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        label.textColor = UIColorOfHex(0x888888);
        [defaultResultView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(defaultResultView);
            make.top.equalTo(imageView.mas_bottom).with.offset(5.f);
        }];
        [defaultResultView setHidden:YES];
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
        noNetworkImageView.image = [UIImage imageNamed:@"noNetwork"];
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
        aboveNoNetworkLabel.textColor = UIColorOfHex(0x888888);
        aboveNoNetworkLabel.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
        [aboveNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noNetworkImageView.mas_bottom).offset(20);
            make.centerX.equalTo(view);
        }];

        belowNoNetworkLabel.text = @"点击屏幕重试";
        belowNoNetworkLabel.textColor = UIColorOfHex(0x888888);
        belowNoNetworkLabel.font = [UIFont systemFontOfSize:AdaptSize(13.f)];
        aboveNoNetworkLabel.textAlignment = NSTextAlignmentCenter;
        [belowNoNetworkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(aboveNoNetworkLabel.mas_bottom).offset(8);
            make.centerX.equalTo(view);
        }];
        [view setHidden:YES];
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
        tableView.sectionHeaderHeight = AdaptSize(kHeaderHeight);
        tableView.sectionFooterHeight = 1.f;
        tableView.rowHeight = AdaptSize(kCellHeight);
        tableView.showsVerticalScrollIndicator = NO;
        tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, AdaptSize(8.f), 0.f);
        tableView.backgroundColor = UIColor.clearColor;
        tableView.scrollEnabled = NO;
        [tableView setHidden:YES];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePickerView:) name:kRemoveDatePickView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged) name:kReachabilityChangedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.contentScroll.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.tableContainerView.frame) + kSafeBottomMargin + AdaptSize(15));
}

- (void)_initUI {

    self.currentSelectedDate = [NSDate new];
    self.currentTitleDate    = [NSDate new];

    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.naview];
    [self.view addSubview:self.contentScroll];
    [self.contentScroll addSubview:self.monthDataView];
    [self.contentScroll addSubview:self.monthSummaryView];
    [self.contentScroll addSubview:self.tableContainerView];
    [self.tableContainerView addSubview:self.fruitIcon];
    [self.tableContainerView addSubview:self.tableTitleLabel];
    [self.tableContainerView addSubview:self.tableView];
    [self.tableContainerView addSubview:self.noNetworkViewWithCalendar];
    [self.tableContainerView addSubview:self.noResultsView];
    
    [self.naview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(kNavHeight);
    }];
    
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(kNavHeight);
        make.bottom.equalTo(self.tableContainerView).offset(AdaptSize(15));
    }];

    [self.monthDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScroll);
        make.left.right.equalTo(self.contentScroll);
        make.width.equalTo(self.view);
        
        if (isPad()) {
            make.height.equalTo(self.view.mas_width).multipliedBy(0.85f);
            
        } else {
            make.height.equalTo(self.view.mas_width).multipliedBy(1.15f);
        }
    }];

    [self.monthSummaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isPad()) {
            make.top.equalTo(self.monthDataView.mas_bottom).with.offset(AdaptSize(-80.f));

        } else {
            make.top.equalTo(self.monthDataView.mas_bottom).with.offset(AdaptSize(-40.f));
        }
        make.left.equalTo(self.monthDataView).with.offset(AdaptSize(25.f));
        make.right.equalTo(self.monthDataView).with.offset(AdaptSize(-25.f));
        make.height.mas_equalTo(AdaptSize(81.f));
    }];

    CGFloat tableContainerHeight = self.showReportButotn ? AdaptSize(221) : AdaptSize(183);
    [self.tableContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScroll).with.offset(AdaptSize(25));
        make.right.equalTo(self.contentScroll).with.offset(AdaptSize(-25));
        make.top.equalTo(self.monthSummaryView.mas_bottom).with.offset(AdaptSize(15));
        make.height.mas_equalTo(tableContainerHeight);
    }];

    [self.fruitIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableContainerView).with.offset(AdaptSize(13));
        make.left.equalTo(self.tableContainerView).with.offset(AdaptSize(14));
        make.size.mas_equalTo(CGSizeMake(AdaptSize(14.f), AdaptSize(14.f)));
    }];
    
    [self.tableTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fruitIcon);
        make.left.equalTo(self.fruitIcon.mas_right).with.offset(AdaptSize(2.f));
        make.right.equalTo(self.tableContainerView).with.offset(AdaptSize(-15));
        make.height.mas_equalTo(AdaptSize(17));
    }];

    [self.noResultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableContainerView);
        make.size.mas_equalTo(MakeAdaptCGSize(178, 109));
        make.top.equalTo(self.fruitIcon.mas_bottom).with.offset(AdaptSize(13));
    }];

    [self.noNetworkViewWithCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tableContainerView);
        make.size.mas_equalTo(MakeAdaptCGSize(178, 109));
        make.top.equalTo(self.fruitIcon.mas_bottom).with.offset(AdaptSize(13));
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.tableContainerView);
        make.top.equalTo(self.fruitIcon.mas_bottom).with.offset(AdaptSize(10));
        make.height.mas_equalTo(AdaptSize(kHeaderHeight) * 3.f);
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
    for (YXNodeModel *node in self.monthData.study_detail) {
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:node.date.doubleValue];
        int index = (int)[date day] - 1;
        dataArray[index][@"numWord"] = [node.num isEqualToNumber:@0] ? @1 : node.num;
        dataArray[index][@"costTime"] = node.cost_time;
        dataArray[index][@"status"] = node.status;
    }
    return dataArray;
}

#pragma mark - datas
- (void)getMonthlyData:(NSDate *)date {
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    __weak typeof(self) weakSelf = self;
    
    [[YYNetworkService default] ocRequestWithType:YXOCRequestTypeGetMonthlyInfo params:@{@"time": @(date.timeIntervalSince1970)} isUpload:NO success:^(YXOCModel* model) {
        [YXUtils hideHUD:self.view];

        if (model != nil) {
//            YXCalendarStudyMonthData *monthdata = [YXCalendarStudyMonthData mj_objectWithKeyValues:model];
            weakSelf.monthData.summary.study_days = model.summary.days;
            weakSelf.monthData.summary.study_words = model.summary.words;
            weakSelf.monthData.summary.study_duration = model.summary.duration;

//            NSMutableArray *study_details = [NSMutableArray arrayWithCapacity:10];
            
            for (YXSummaryDetialModel *detial in model.detail) {
                YXNodeModel *study_detail = [[YXNodeModel alloc] init];
                study_detail.date = [NSNumber numberWithDouble:detial.date];
                study_detail.status = [NSNumber numberWithInteger:detial.status];
                
                [ weakSelf.monthData.study_detail addObject:study_detail];
            }
            
//            [weakSelf.monthData.study_detail addObjectsFromArray:study_details];
//            weakSelf.monthData.study_detail = study_details;
            
//            weakSelf.monthData = monthdata;
            //更新日历组件,(因为用户可能通过PickView选择月份)
            if (weakSelf.monthDataView.calendarView.currentPage.year != date.year || weakSelf.monthDataView.calendarView.currentPage.month != date.month) {
                [weakSelf.monthDataView.calendarView setCurrentPage:date animated:YES];
            }
            [weakSelf.monthDataView.calendarView reloadData];
            //更新月统计结果
            [weakSelf.monthSummaryView updateView:weakSelf.monthData.summary];
            //更新图表组件
            [weakSelf.monthDataView.chartView setDataArray:[weakSelf setupChartData] selected:[NSNumber numberWithUnsignedInteger:weakSelf.currentSelectedDate.day - 1]];
            [self.monthDataView.calendarView selectDate:self.currentSelectedDate scrollToDate:NO];
            //            if (self.currentSelectedDate.day == self.monthDataView.calendarView.today.day) {
            self.monthDataView.calendarView.appearance.borderSelectionColor = UIColorOfHex(0xFBA217);
            self.monthDataView.calendarView.appearance.selectionColor       = UIColorOfHex(0xFBA217);
            self.monthDataView.calendarView.appearance.titleSelectionColor  = UIColor.whiteColor;
            //            } else {
            //                self.monthDataView.calendarView.appearance.borderSelectionColor = UIColor.whiteColor;
            //                self.monthDataView.calendarView.appearance.selectionColor       = UIColor.clearColor;
            //                self.monthDataView.calendarView.appearance.titleSelectionColor  = UIColor.whiteColor;
            //            }
        }
        
    } fail:^(NSError* error) {
        
    }];
}

- (void)getDailyData: (NSDate *)date {
    [YXUtils showLoadingInfo:kHUDTipsWait toView:self.view];
    
    [[YYNetworkService default] ocRequestWithType:YXOCRequestTypeGetDayInfo params:@{@"time": @(date.timeIntervalSince1970)} isUpload:NO success:^(YXOCModel* model) {
        [YXUtils hideHUD:self.view];
        
        if (model != nil) {
            YXCalendarStudyDayData *dailyData = [YXCalendarStudyDayData mj_objectWithKeyValues:model];
            dailyData.date = [NSNumber numberWithDouble:model.date];
            dailyData.study_duration = model.duration;

            for (YXSummaryItemsModel *item in model.reviewItems) {
                YXCalendarNewBookModel *reviewItem = [[YXCalendarNewBookModel alloc] init];
                reviewItem.name = item.name;
                
                for (YXSummaryItemsWordModel *word in item.wordList) {
                    YXCalendarWordsModel *wordItem = [[YXCalendarWordsModel alloc] init];
                    wordItem.word = word.word;
                    wordItem.word_id = word.wordId;
                    wordItem.paraphrase = word.partOfSpeechAndMeanings;
                    wordItem.voice_us = word.americanPronunciation;
                    wordItem.voice_uk = word.englishPronunciation;
                    
                    NSString *string = [NSString stringWithFormat:@"%ld", (long)word.isComplexWord];
                    wordItem.is_synthesis = string;

                    [reviewItem.word_list addObject:wordItem];
                }
                
                [dailyData.review_item addObject:reviewItem];
            }
            
            for (YXSummaryItemsModel *item in model.studyItems) {
                YXCalendarNewBookModel *studyItem = [[YXCalendarNewBookModel alloc] init];
                studyItem.name = item.name;
                
                for (YXSummaryItemsWordModel *word in item.wordList) {
                    YXCalendarWordsModel *wordItem = [[YXCalendarWordsModel alloc] init];
                    wordItem.word = word.word;
                    wordItem.word_id = word.wordId;
                    wordItem.paraphrase = word.partOfSpeechAndMeanings;
                    wordItem.voice_us = word.americanPronunciation;
                    wordItem.voice_uk = word.englishPronunciation;
                    
                    NSString *string = [NSString stringWithFormat:@"%ld", (long)word.isComplexWord];
                    wordItem.is_synthesis = string;
                    
                    [studyItem.word_list addObject:wordItem];
                }
                
                [dailyData.study_item addObject:studyItem];
            }
            
            self.dayData = dailyData;
            
        } else {
            self.dayData = nil;
        }
        
        self.showReportButotn = self.dayData.study_duration > 0;
        CGFloat tableViewHeight = AdaptSize(kHeaderHeight) * 3.f;
        tableViewHeight = self.showReportButotn ? tableViewHeight + AdaptSize(50) : tableViewHeight;
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableViewHeight);
        }];
        CGFloat tableContainerHeight = self.showReportButotn ? AdaptSize(221) : AdaptSize(183);
        [self.tableContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(tableContainerHeight);
        }];
        self.contentScroll.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.tableContainerView.frame) + kSafeBottomMargin + AdaptSize(15));
        [self.tableView reloadData];
        
    } fail:^(NSError* error) {
        
    }];
}

# pragma mark - Event

- (void)showReviewWordsList: (UITapGestureRecognizer *)sender {
    self.dayData.showReviewList       = !self.dayData.showReviewList;
    NSUInteger amountCell             = self.dayData.reviewCellList.count;
    CGFloat amountCellHeight          = amountCell * AdaptSize(kCellHeight);
    CGFloat finalTalbeViewHeight      = self.tableView.contentSize.height;
    CGFloat finalTableContainerHeight = self.tableContainerView.height;
    CGSize size                       = self.contentScroll.contentSize;
    CGFloat finalScrollHeight         = CGRectGetMaxY(self.tableContainerView.frame) + AdaptSize(30.f);

    if (self.dayData.showReviewList) {
        finalTalbeViewHeight      += amountCellHeight;
        finalTableContainerHeight += amountCellHeight;
        finalScrollHeight         += amountCellHeight;
    } else {
        finalTalbeViewHeight      -= amountCellHeight;
        finalTableContainerHeight -= amountCellHeight;
        finalScrollHeight         -= amountCellHeight;
    }

    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(finalTalbeViewHeight);
    }];
    [self.tableContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(finalTableContainerHeight);
    }];
    self.contentScroll.contentSize = CGSizeMake(size.width, finalScrollHeight);
    [self.tableView reloadData];
}

- (void)showStudyWordsList: (UITapGestureRecognizer *)sender {
    self.dayData.showStudiedList      = !self.dayData.showStudiedList;
    NSUInteger amountCell             = self.dayData.studiedCellList.count;
    CGFloat amountCellHeight          = amountCell * AdaptSize(kCellHeight);
    CGFloat finalTalbeViewHeight      = self.tableView.contentSize.height;
    CGFloat finalTableContainerHeight = self.tableContainerView.height;
    CGSize size                       = self.contentScroll.contentSize;
    CGFloat finalScrollHeight         = CGRectGetMaxY(self.tableContainerView.frame) + AdaptSize(30.f);

    if (self.dayData.showStudiedList) {
        finalTalbeViewHeight      += amountCellHeight;
        finalTableContainerHeight += amountCellHeight;
        finalScrollHeight         += amountCellHeight;
    } else {
        finalTalbeViewHeight      -= amountCellHeight;
        finalTableContainerHeight -= amountCellHeight;
        finalScrollHeight         -= amountCellHeight;
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(finalTalbeViewHeight);
    }];
    [self.tableContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(finalTableContainerHeight);
    }];
    self.contentScroll.contentSize = CGSizeMake(size.width, finalScrollHeight);
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

- (void)showTableView {
    [self.tableView setHidden:NO];
    [self.noResultsView setHidden:YES];
    [self.noNetworkViewWithCalendar setHidden:YES];
}

- (void)showNoResultsView {
    [self.tableView setHidden:YES];
    [self.noResultsView setHidden:NO];
    [self.noNetworkViewWithCalendar setHidden:YES];
}

- (void)showNoNetWorkView {
    [self.tableView setHidden:YES];
    [self.noResultsView setHidden:YES];
    [self.noNetworkViewWithCalendar setHidden:NO];
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

- (void)checkReport {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Home" bundle: nil];
    YXStudyReportViewController *studyReportViewController = [storyboard instantiateViewControllerWithIdentifier:@"YXStudyReportViewController"];
    studyReportViewController.selectDate = [self.currentSelectedDate timeIntervalSince1970];
    studyReportViewController.canSelectDate = NO;
    [self.navigationController pushViewController:studyReportViewController animated:YES];
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (self.dayData) {
            return self.dayData.showReviewList ? self.dayData.reviewCellList.count : 0;
        }
        return 0;
    } else if (section == 1) {
        if (self.dayData) {
            return self.dayData.showStudiedList? self.dayData.studiedCellList.count : 0;
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
    } else if (section == 2) {
        [headerView.separatorView setHidden:!self.showReportButotn];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *foodView = [[UIView alloc] init];
    foodView.backgroundColor = UIColor.clearColor;
    if (section == 2) {
        UIButton *button = [[UIButton alloc] init];
        [foodView addSubview:button];
        button.backgroundColor = UIColorOfHex(0xFFF4E9);
        [button setTitle:@"查看完整学习报告" forState:UIControlStateNormal];
        [button.titleLabel setFont: [UIFont regularFontOfSize:AdaptSize(14)]];
        [button setTitleColor:UIColorOfHex(0xFBA217) forState:UIControlStateNormal];
        button.layer.cornerRadius  = AdaptSize(13.5);
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(checkReport) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(AdaptSize(148), AdaptSize(27)));
            make.center.equalTo(foodView);
        }];
    }

    return foodView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return AdaptSize(50);
    } else {
        return 0.0;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row >= self.dayData.reviewCellList.count) {
            return [UITableViewCell new];
        }
        YXCalendarCellModel *book = self.dayData.reviewCellList[indexPath.row];
        if (book.isWord) {
            YXCalendarWordCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCalendarCellID forIndexPath:indexPath];
            [cell setCell:book];
            return cell;
        } else {
            YXCalendarBookCell *cell = [[YXCalendarBookCell alloc] init];
            [cell setCell:book];
            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row >= self.dayData.studiedCellList.count) {
            return [UITableViewCell new];
        }
        YXCalendarCellModel *book = self.dayData.studiedCellList[indexPath.row];
        if (book.isWord) {
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
    YXCalendarCellModel *model;
    if (indexPath.section == 0) {
        model = self.dayData.reviewCellList[indexPath.row];
    } else if (indexPath.section == 1) {
        model = self.dayData.studiedCellList[indexPath.row];
    }

    if (!model || model.word_id == 0) {
        return;
    }

    [YRRouter openURL:@"word/detail" query:@{@"word_id" : @(model.word_id), @"is_complex_word" : @(NO)} animated:YES];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - FSCalendarDelegate, FSCalendarDataSource

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    self.currentSelectedDate = date;
    //    NSDate *today = calendar.today;
    //    if (date == today) {
    //        self.monthDataView.calendarView.appearance.borderSelectionColor = UIColorOfHex(0xFBA217);
    //        self.monthDataView.calendarView.appearance.selectionColor       = UIColor.clearColor;
    //        self.monthDataView.calendarView.appearance.titleSelectionColor  = UIColorOfHex(0xFBA217);
    //    } else {
    self.monthDataView.calendarView.appearance.borderSelectionColor = UIColorOfHex(0xFBA217);
    self.monthDataView.calendarView.appearance.selectionColor       = UIColorOfHex(0xFBA217);
    self.monthDataView.calendarView.appearance.titleSelectionColor  = UIColor.whiteColor;
    //    }
    [calendar selectDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    YXLog(@"我滑动选择了新的月份: %zu", calendar.currentPage.month);
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
    return [[NSDate new] offsetYears:1];
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
        return UIColorOfHex(0xFFF4E9);
    }
    // 已打卡的肯定学习过了
    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
        return UIColorOfHex(0xFFF4E9);
    }
    return nil;
}

// 已学习或者已打卡的字体颜色显示为: UIColorOfHex(0x3AC8FC)
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    //    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    //    dateformatter.dateFormat = @"yyyy-MM-dd";
    //    NSString *key = [dateformatter stringFromDate:date];
    //    if ([self.monthData.studiedDateDict.allKeys containsObject:key]) {
    //        return UIColor.whiteColor;
    //    }
    // 已打卡的肯定学习过了
    //    if ([self.monthData.punchedDateDict.allKeys containsObject:key]) {
    //        return UIColor.whiteColor;
    //    }
    return nil;
}

- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
    NSDate *today = calendar.today;
    if (date == today) {
        return UIColorOfHex(0xFBA217);
    } else {
        return UIColor.clearColor;
    }
}

#pragma mark - YXBasePickverViewDelegate
- (void)basePickverView:(YXBasePickverView *)pickverView withSelectedTitle:(NSString *)title {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:title];
    self.currentSelectedDate = date;
    self.currentTitleDate = date;
    [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveDatePickView object:nil];
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


- (void)reloadShareData {

}

@end
