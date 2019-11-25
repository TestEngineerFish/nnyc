//
//  YXPersonlCenterVC.m
//  YXEDU
//
//  Created by shiji on 2018/4/1.
//  Copyright © 2018年 shiji. All rights reserved.
//
#import "YXComHttpService.h"
#import "NSObject+YR.h"

#import "YXPersonalCenterVC.h"
#import "YXPersonalViewModel.h"
#import "YXCalendarViewController.h"

#import "YXBindPhoneVC.h"
#import "BSCommon.h"
#import "YXComAlertView.h"
#import "YXConfigure.h"
#import "UIImageView+YR.h"
#import "YXMediator.h"
#import "YXLogoutModel.h"
#import "YXUtils.h"
#import "YXAPI.h"
#import "WXApiManager.h"
#import "QQApiManager.h"
#import "NetWorkRechable.h"
#import "YXStudyRecordCenter.h"
#import "LEEAlert.h"

#import "YXPersonalBadgeModel.h"
#import "YXPersonalInformationVC.h"
#import "YXPersonalMyBadgesVC.h"
#import "YXPersonalReminderVC.h"
#import "YXPersonalAboutVC.h"
#import "YXPersonalFeedBackVC.h"
#import "YXPersonalMaterialManageVC.h"

#import "YXBookMaterialManager.h"
#import "YXBookMaterialModel.h"

#import "YXPersonalCenterCellModel.h"
#import "YXPersonalCenterCell.h"

#import "GroupShadowTableView.h"

#import "YXNoNetworkView.h"

#import "AFNetworking.h"
#import "NetWorkRechable.h"
#import <YYKit/YYKit.h>

#import "NSArray+Safe.h"
#import "YXComAlertView.h"
#import "UIButton+WebCache.h"
#import "YXBaseWebViewController.h"
@interface YXPersonalCenterVC () <GroupShadowTableViewDelegate, GroupShadowTableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) GroupShadowTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *allRightDetails;

@property (nonatomic, weak) UIImageView  *backgroundImageView;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *badgeCountLabel;
@property (nonatomic, strong) UICollectionView *badgeCollectionView;
@property (nonatomic, strong) NSArray *badges;
@property (nonatomic, strong) NSArray *books;

@property (nonatomic, strong) YXNoNetworkView *noNetworkView;

@property (nonatomic, strong) YXUserModel_Old *userModel;

@property (nonatomic, strong) YXPersonalViewModel *model;
@property (nonatomic, assign)BOOL isWechatBind;
@property (nonatomic, assign)BOOL isQQBind;

@property (nonatomic, assign) BOOL isHasDLEntrance;
@property (nonatomic, strong) UIView *scoreView;
@property (nonatomic, strong) UILabel *creditsLabel;
@end

@implementation YXPersonalCenterVC

// MARK: - Lazy Load

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        NSMutableArray *dataSource = [NSMutableArray array];
        
        NSArray *allImageNames = @[@[@"",@"日历", @""],
                                   @[@"手机号",@"微信",@"qq"],
                                   @[@"默认音标和发音",@"素材包管理",@"每日提醒"],
                                   @[@"关于我们",@"意见反馈"]];
        NSArray *allTitles = @[@[@"", @"本月已打卡--天", @""],
                               @[@"手机号",@"微信",@"QQ"],
                               @[@"默认音标和发音",@"素材包管理",@"每日提醒"],
                               @[@"关于我们",@"意见反馈"]];
        NSArray *isShowAccseeories = @[@[@"1", @"1", @"0"],
                                       @[@"0",@"0",@"0"],
                                       @[@"1",@"1",@"1"],
                                       @[@"0",@"0"]];
        NSArray *isShowBottomLines = @[@[@"0", @"1", @"0"],
                                       @[@"1",@"1",@"0"],
                                       @[@"1",@"1",@"0"],
                                       @[@"1",@"0"]];
        
        for (NSInteger i = 0; i < allImageNames.count; i++) {
            
            NSArray *imageNamesOfOneSection = allImageNames[i];
            NSArray *titlesOfOneSection = allTitles[i];
            NSArray *rightDetailsOfOneSection = self.allRightDetails[i];
            NSArray *isShowAccessoriesOfOneSection = isShowAccseeories[i];
            NSArray *isShowBottomLineOfOneSection = isShowBottomLines[i];
            
            NSMutableArray *itemsOfOneSection = [NSMutableArray array];
            
            for ( NSInteger j = 0; j < titlesOfOneSection.count; j++ ) {
                YXPersonalCenterCellModel *model = [[YXPersonalCenterCellModel alloc] init];
                
                model.imageName = imageNamesOfOneSection[j];
                model.title = titlesOfOneSection[j];
                model.rightDetail = rightDetailsOfOneSection[j];
                model.isShowAccessory = [isShowAccessoriesOfOneSection[j] boolValue];
                model.isShowBottomLine = [isShowBottomLineOfOneSection[j] boolValue];
                
                [itemsOfOneSection addObject:model];
            }
            
            [dataSource addObject:itemsOfOneSection];
        }
        _dataSource = dataSource;
    }
    return _dataSource;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        CGFloat height = SCREEN_WIDTH * (254.0 / 375);
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        bgImageView.image = [UIImage imageNamed:@"personalBGImage"];
        [self.view addSubview:bgImageView];
        _backgroundImageView = bgImageView;
    }
    return _backgroundImageView;
}

- (NSArray *)badges {
    if (!_badges) {
        NSMutableArray *badges = [NSMutableArray array];
        
        NSMutableArray *badgeList = [YXConfigure shared].confModel.badgeList;
        if (!badgeList) {
            _badges = badges;
            return _badges;
        }
        
        NSArray *bageStatusIds = [self.allBadgesDetails valueForKey:@"badgeId"];        
        // Data form api: /v2/api/getconfig
        NSMutableArray *badgeStatus = [NSMutableArray array];
        for (YXBadgeListModelOld *badgeListModel in badgeList) {
            NSMutableArray *groupbadgeStatus = [NSMutableArray array];
            for (YXBadgeModelOld *badgeModel in badgeListModel.options) {
                NSString *badgeId = badgeModel.badgeId;
                NSInteger index = [bageStatusIds indexOfObject:@([badgeId integerValue])];
                YXPersonalBadgeModel *badge = [[YXPersonalBadgeModel alloc] init];
                
                badge.badgeID = badgeId;//IDsOfOneSection[i];
                badge.completedBadgeImageUrl = badgeModel.realize;// completedImageUrlsOfOneSection[j];
                badge.incompleteBadgeImageUrl = badgeModel.unRealized;//incompleteImageUrlsOfOneSection[j];
                badge.badgeName = badgeModel.badgeName;//namesOfOneSection[j];
                badge.desc = badgeModel.desc;//descriptionsOfOneSection[j];
                NSDictionary *badgeStatusDic = [self.allBadgesDetails objectAtIndex:index];
                id finishTime = [badgeStatusDic objectForKey:@"finishTime"];//finishTime
                if (!finishTime) {
                    badge.finishDate = @"";
                }else {
//                    NSString *finishTimeStr = [NSString stringWithFormat:@"%@",finishTime];
                    double timeInterval = [finishTime doubleValue];
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *finishDateString = [formatter stringFromDate:date];
                    badge.finishDate =  finishDateString;
                }
                badge.total = [NSString stringWithFormat:@"%@",badgeStatusDic[@"total"]];
                badge.done = [NSString stringWithFormat:@"%@",badgeStatusDic[@"done"]];//badgeStatusDic[@"done"];
                
                [groupbadgeStatus addObject:badge];
            }
            [badgeStatus addObject:groupbadgeStatus];;
        }
        _badges = badgeStatus;
    }
    
    return _badges;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model = [[YXPersonalViewModel alloc]init];

        __weak YXPersonalCenterVC *weakSelf = self;
        [[WXApiManager shared]setFinishBlock:^(id obj, BOOL result) {
            if (((NSString *)obj).length) {
                YXPersonalBindModel *sendModel = [[YXPersonalBindModel alloc]init];
                sendModel.bind_pf = @"wechat";
                sendModel.code = obj;
                sendModel.openid = @"";
                [weakSelf bind:sendModel];
            }
        }];

        [[QQApiManager shared]setFinishBlock:^(id obj1, id obj2, BOOL result) {
            if (((NSString *)obj1).length) {
                YXPersonalBindModel *sendModel = [[YXPersonalBindModel alloc]init];
                sendModel.bind_pf = @"qq";
                sendModel.code = obj1;
                sendModel.openid = obj2;
                [weakSelf bind:sendModel];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHasDLEntrance = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postBindSeting:) name:@"CompletedBind" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAvatar:) name:@"AvatarChanged" object:nil];

    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self backgroundImageView];
    
//    self.tableView = [[GroupShadowTableView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight) style:UITableViewStyleGrouped];
    self.tableView = [[GroupShadowTableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusBarHeight) style:UITableViewStyleGrouped];
//    self.tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0);
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.showSeparator = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    

    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[YXPersonalCenterCell class] forCellReuseIdentifier:@"YXPersonalCenterCell"];
    [self showLoadingView];
    [self judgeNetworkStatus];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScoreView];
}

//
- (void)setupScoreView {
    UIImageView *icon = [[UIImageView alloc] init];
    icon.image = [UIImage imageNamed:@"Mission_douzi"];
    
    UILabel *lbl = [[UILabel alloc] init];
    //lbl.frame = CGRectMake(AdaptSize(30), AdaptSize(3), AdaptSize(40), AdaptSize(24));
    lbl.text = @"0";
    lbl.font = [UIFont fontWithName:@"Helvetica" size:AdaptSize(14)];
    lbl.textColor = UIColorOfHex(0x485461);
    lbl.textAlignment = NSTextAlignmentCenter;
    _creditsLabel = lbl;
    
    _scoreView = [[UIView alloc] init];
    _scoreView.layer.cornerRadius = 15;
    _scoreView.backgroundColor = [UIColor whiteColor];

    [self.tableView addSubview:_scoreView];
    [_scoreView addSubview:icon];
    [_scoreView addSubview:lbl];
    
    [_scoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(25);
        make.right.equalTo(self.view).offset(15);
        make.height.mas_equalTo(30);
        make.left.equalTo(icon).offset(-10);
    }];
    
    [_creditsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).mas_equalTo(-10);
        make.centerY.equalTo(_scoreView);
    }];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_scoreView);
        make.right.equalTo(_creditsLabel.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(36, 25));
    }];
}

- (void)getCredits {
    [YXDataProcessCenter GET:DOMAIN_CREDITS parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            NSDictionary *credits = response.responseObject;
            NSInteger credit = [[credits objectForKey:@"userCredits"] integerValue];
            if (credit < 0) { credit = 0; }
            NSString *str = [NSString stringWithFormat:@"%zd",credit];
            _creditsLabel.text = str;
            [_scoreView layoutIfNeeded];
        }
    }];
}


- (UIView *)footerView{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 108 + kSafeBottomMargin)];
    
    UIButton *logOutButton = [[YXNoHightButton alloc] initWithFrame:CGRectMake(16, 22, SCREEN_WIDTH - 32, 44)];
    logOutButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [logOutButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [logOutButton setImage:[UIImage imageNamed:@"退出登录"] forState:UIControlStateNormal];    
    [footerView addSubview:logOutButton];
    
    return footerView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self getCredits];
    [self getBadgesInfo];
    [self checkMaterialMemory];
}

- (void)judgeNetworkStatus {
    NetWorkStatus networkStatus = [[NetWorkRechable shared] netWorkStatus];    
    if ( networkStatus == NetWorkStatusReachableViaWWAN || networkStatus == NetWorkStatusReachableViaWiFi ) {
        NSLog(@"有网");
        [self reloadAllRightDetails];
    }else{
        NSLog(@"没网");
        self.tableView.groupShadowDelegate = nil;
        self.tableView.groupShadowDataSource = nil;
        
        self.noNetworkView = [YXNoNetworkView createWith:^{
            [self reloadAllRightDetails];
        }];
        
        self.noNetworkView.frame = self.view.frame;
        [self.view addSubview:self.noNetworkView];
    }
}

- (void)reloadAllRightDetails {
//    [self showLoadingView];

    [[YXComHttpService shared] requestUserInfo:^(id obj, BOOL result) {
        if (result) {
            self.tableView.groupShadowDelegate = self;
            self.tableView.groupShadowDataSource = self;
            
            [[YXBookMaterialManager shareManager] quaryMaterialOfAllBooksCompleteBlock:^(id obj, BOOL result) {
                if (result) {
                    self.books = obj;
                }else{
                    self.books = @[];
                }
            }];
            
            YXLoginModel *loginModel = obj;
            self.userModel = loginModel.user;
            
            [YXConfigure shared].loginModel = loginModel;
            
            NSString *phoneNumber = self.userModel.mobile;
            NSString *userBind = self.userModel.userBind;
            NSArray *binds = [userBind componentsSeparatedByString:@","];
            
            BOOL isQQBind = NO;
            BOOL isWechatBind = NO;
            for (NSString *binStr in binds) {
                if ([binStr isEqualToString:@"1"]) {
                    isQQBind = YES;
                }else if([binStr isEqualToString:@"2"]) {
                    isWechatBind = YES;
                }
            }
            self.isQQBind = isQQBind;
            self.isWechatBind = isWechatBind;
            if (userBind == nil) {
                userBind = @"0";
            }
            
            NSString *pronounce = @"英式";
            if ([self.userModel.speech isEqualToString:@"0"]) {
                pronounce = @"英式";
            } else if ([self.userModel.speech isEqualToString:@"1"]) {
                pronounce = @"美式";
            }
            
            NSString *remindDateString = @"已关闭";
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *StoreRemindDateString = [userDefaults objectForKey:kRemindDatekey];
            if (StoreRemindDateString) {
                remindDateString = StoreRemindDateString;
            }
            
            NSString *booksSizeString = @"";
            float booksSize = 0;
            for (YXBookMaterialModel *book in self.books) {
                booksSize = booksSize + [book.materialSize floatValue];
            }
            
            booksSizeString = [NSString stringWithFormat:@"%.2lfM",booksSize];
            
            NSArray *rightModels = @[@[@"", @"查看打卡日历", @""],
                                     @[phoneNumber, userBind, userBind],
                                     @[pronounce, booksSizeString, remindDateString],
                                     @[@"",@""]];
            self.allRightDetails = [[NSMutableArray alloc] initWithArray:rightModels];//[[NSMutableArray alloc] initWithArray:rightModels];
            
            self.dataSource = nil;
//            [self.noNetworkView removeFromSuperview];
//            [self.tableView reloadData];
            [self getBadgesInfo]; // 获取徽章信息
            self.tableView.tableFooterView = [self footerView];
        }else {
            [self hideLoadingView];
        }
    }];
}

- (void)checkMaterialMemory {
    if (self.userModel) {
        [[YXBookMaterialManager shareManager] quaryMaterialOfAllBooksCompleteBlock:^(id obj, BOOL result) {
            if (result) {
                self.books = obj;
            }else{
                self.books = @[];
            }
        }];
        
        NSString *booksSizeString = @"";
        float booksSize = 0;
        for (YXBookMaterialModel *book in self.books) {
            booksSize = booksSize + [book.materialSize floatValue];
        }
        
        booksSizeString = [NSString stringWithFormat:@"%.2lfM",booksSize];
        NSArray *section2 = [self.dataSource objectAtIndex:2];
        YXPersonalCenterCellModel *bookSizeModel = [section2 objectAtIndex:1];
        bookSizeModel.rightDetail = booksSizeString;
        [self.tableView reloadData];
    }

}

- (void)getBadgesInfo {
    if (self.userModel) {
        [[YXComHttpService shared] requestBadgesInfo:^(id obj, BOOL result) {
            if (result) {
                self.allBadgesDetails = [obj valueForKey:@"badgesInfo"];
                [self.noNetworkView removeFromSuperview];
                [self.tableView reloadData];
            }
            [self hideLoadingView];
        }];
    }
}

- (void)setAllBadgesDetails:(NSArray *)allBadgesDetails {
    _allBadgesDetails = [allBadgesDetails copy];
    self.badges = nil;
}

// MARK: - GroupShadowTableView Delegate & DataSource
//DL测评入口

- (nullable UIView *)groupShadowTableView:(GroupShadowTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1 && self.isHasDLEntrance) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 70)];
        NSURL *imageUrl = [NSURL URLWithString:[YXConfigure shared].loginModel.dl.imgUrl];
        if (imageUrl == nil) {
            return nil;
        }
        [sectionBtn addTarget:sectionBtn action:@selector(enterDL) forControlEvents:UIControlEventTouchUpInside];
        [sectionBtn sd_setBackgroundImageWithURL:imageUrl forState:UIControlStateNormal];
        sectionBtn.layer.cornerRadius = 10;
        [view addSubview:sectionBtn];
        return view;
    } else {
        return nil;
    }
}

- (void)enterDL {
    NSString *link = [YXConfigure shared].loginModel.dl.h5Url;
    YXBaseWebViewController *dlVC = [[YXBaseWebViewController alloc] initWithLink:link title:@""];
    [self.navigationController pushViewController:dlVC animated:YES];
}


- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    } else if (section == 1 && self.isHasDLEntrance) {
        NSURL *imageUrl = [NSURL URLWithString:[YXConfigure shared].loginModel.dl.imgUrl];
        if (imageUrl == nil) {
            return 20;
        }
        return 100;
    } else {
        return 20;
    }
}
//- (nullable UIView *)groupShadowTableView:(GroupShadowTableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 1 && self.isHasDLEntrance) {
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        return view;
//    } else {
//        return nil;
//    }
//}
//
//- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0 && self.isHasDLEntrance) {
//        return 80;
//    } else {
//        return 20;
//    }
//}

- (NSInteger)numberOfSectionsInGroupShadowTableView:(GroupShadowTableView *)tableView {
    return self.dataSource.count;//
}

- (NSInteger)groupShadowTableView:(GroupShadowTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *eachSection = self.dataSource[section];
    return eachSection.count;
}

- (UITableViewCell *)groupShadowTableView:(GroupShadowTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXPersonalCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalCenterCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSArray *itemsOfOneSection = self.dataSource[indexPath.section];
    YXPersonalCenterCellModel *cellModel = itemsOfOneSection[indexPath.row];
    cell.model = cellModel;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self setUpPersonalInformation:cell];
        } else if (indexPath.row == 1) {
            [self setUpCalendarInfomation:cell];
        }else {
            [self setUpBadges:cell];
        }
        
    } else if (indexPath.section == 1) {
        
        cell.rightDetailLabel.textColor = UIColor.clearColor;
        
        if (indexPath.row == 0) {
            [self addPhotoNumber:cell with:cellModel.rightDetail];
        } else if (indexPath.row == 1){
            if (self.isWechatBind) { //[cellModel.rightDetail isEqualToString:@",2"] || [cellModel.rightDetail isEqualToString:@",1,2"]
                [self addUnBindImageButton:cell with:@"Wechat"];
            } else {
                [self addToBindImageButton:cell with:@"Wechat"];
            }
        } else {
            if (self.isQQBind) {//[cellModel.rightDetail isEqualToString:@",1"] || [cellModel.rightDetail isEqualToString:@",1,2"]
                [self addUnBindImageButton:cell with:@"QQ"];
            } else {
                [self addToBindImageButton:cell with:@"QQ"];
            }
        }
    }
    
    return cell;
    
}

- (CGFloat)groupShadowTableView:(GroupShadowTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 76;
        } else if (indexPath.row == 1) {
            return 44;
        } else {
            return 112;
        }
    } else {
        return 50;
    }
}

- (void)groupShadowTableView:(GroupShadowTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSArray *gropuModels = [self.dataSource objectAtIndex:indexPath.section];
//    YXPersonalCenterCellModel *model = [gropuModels objectAtIndex:indexPath.row];
//    __weak typeof(self)weakSelf = self;

    @weakify(self)
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    YXPersonalInformationVC *personalInformation = [[YXPersonalInformationVC alloc] init];
                    __weak typeof(self) weakSelf = self;
                    personalInformation.shouldRefreshInfoBlock = ^{
                        [weakSelf reloadAllRightDetails];
                    };
                    personalInformation.userModel = self.userModel;
                    [self.navigationController pushViewController:personalInformation animated:YES];
                }
                    break;
                case 1:
                {
                    YXCalendarViewController *calendarVC = [[YXCalendarViewController alloc] init];
                    calendarVC.transType = TransationPop;
                    [self.navigationController pushViewController:calendarVC animated:YES];
                }
                    break;
                case 2:
                {
                    YXPersonalMyBadgesVC *personalBadges = [[YXPersonalMyBadgesVC alloc] init];
                    personalBadges.badges = self.badges;
                    [self.navigationController pushViewController:personalBadges animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
            
        case 1:
            break;
        
        case 2:
            switch (indexPath.row) {
                case 0:
                {
                    NSArray *itemsOfOneSection = self.dataSource[indexPath.section];
                    YXPersonalCenterCellModel *model = itemsOfOneSection[indexPath.row];
                    [self showVoiceChooseAlert:model];
//                    [self showVoiceChooseAlert:^(NSString *pronunciation) {
//                        @strongify(self)
//                        NSArray *itemsOfOneSection = self.dataSource[indexPath.section];
//                        YXPersonalCenterCellModel *model = itemsOfOneSection[indexPath.row];
//                        model.rightDetail = pronunciation;
//
//                        [self.tableView reloadData];
//                    }];
                }
                    
                    break;
                    
                case 1:
                {
                    YXPersonalMaterialManageVC *personalMaterialManage = [[YXPersonalMaterialManageVC alloc] init];
                    YXPersonalCenterCellModel *cellModel = self.dataSource[indexPath.section][indexPath.row];

                    personalMaterialManage.refreshBookMaterial = ^(NSString *size) {
                        @strongify(self)
                        cellModel.rightDetail = size;
                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:personalMaterialManage animated:YES];
                }
                    
                    break;
                    
                case 2:
                {
                    YXPersonalReminderVC *personalReminder = [[YXPersonalReminderVC alloc] init];
                    
                    YXPersonalCenterCellModel *cellModel = self.dataSource[indexPath.section][indexPath.row];

                    personalReminder.returnRemindDateStringBlock = ^(NSString *reminderDateString) {
                        
                        @strongify(self)
                        cellModel.rightDetail = reminderDateString;
                        
                        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                        [userDefaults setObject:reminderDateString forKey:kRemindDatekey];
                        
                        [self.tableView reloadData];
                    };
                    
                    personalReminder.remindDate = cellModel.rightDetail;
                    
                    [self.navigationController pushViewController:personalReminder animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 3:
            switch (indexPath.row) {
                case 0:
                {
                    YXPersonalAboutVC *personalAbout = [[YXPersonalAboutVC alloc] init];
                    [self.navigationController pushViewController:personalAbout animated:YES];
                }
                    break;
                    
                case 1:
                {
                    YXPersonalFeedBackVC* personalFeedBack = [[YXPersonalFeedBackVC alloc] init];
                    [self.navigationController pushViewController:personalFeedBack animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
}

// MARK: - Collection Delegate & Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.badges.count == 0) {
        return 0;
    }
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BadgeCell" forIndexPath:indexPath];
    
    NSMutableArray *badgeList = [NSMutableArray array];

    NSMutableArray *showBadges = [NSMutableArray array];
    
    for (NSArray *badgeSection in self.badges) {
        for (YXPersonalBadgeModel *badge in badgeSection) {
            [badgeList addObject:badge];
        }
    }
    
    for (YXPersonalBadgeModel *badge in badgeList) {
        if (![badge.finishDate isEqualToString:@""]) {
            [showBadges addObject:badge];
        }
    }
    
    if (showBadges.count > 1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [showBadges sortUsingComparator:^NSComparisonResult(YXPersonalBadgeModel *badge1, YXPersonalBadgeModel *badge2) {
            
            NSDate *badge1FinishDate = [dateFormatter dateFromString:badge1.finishDate];
            NSDate *badge2FinishDate = [dateFormatter dateFromString:badge2.finishDate];
            
            return badge1FinishDate < badge2FinishDate;
        }];
    }
    
    if (showBadges.count == 0) {
        for (NSInteger i = 0; i < badgeList.count; i ++) {
            YXPersonalBadgeModel *showBadge = badgeList[i];
            
            [showBadges addObject:showBadge];
            
            if (showBadges.count >= 6) {
                break;
            }
        }
    } else if (showBadges.count > 0 && showBadges.count < 6) {
        
        for (YXPersonalBadgeModel *showBadge in showBadges) {
            NSInteger index = [badgeList indexOfObject:showBadge];
            [badgeList removeObjectAtIndex:index];
        }
        
        for (NSInteger i = 0; i < badgeList.count; i ++) {
            YXPersonalBadgeModel *badge = badgeList[i];
            
            [showBadges addObject:badge];
            
            if (showBadges.count >= 6) {
                break;
            }
        }
    }
    
    
    YXPersonalBadgeModel *badge = showBadges[indexPath.row];
    
    UIImageView *badgeImageView = [[UIImageView alloc] init];
    badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:badgeImageView];
    
    [badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    
    if ([badge.finishDate isEqualToString:@""]) {
        [badgeImageView sd_setImageWithURL:[NSURL URLWithString:badge.incompleteBadgeImageUrl]];
    } else {
        [badgeImageView sd_setImageWithURL:[NSURL URLWithString:badge.completedBadgeImageUrl]];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YXPersonalMyBadgesVC *personalBadges = [[YXPersonalMyBadgesVC alloc] init];
    personalBadges.badges = self.badges;
    [self.navigationController pushViewController:personalBadges animated:YES];
}

// MARK: - Bind Methods
- (void)bind:(YXPersonalBindModel *)bindModel {
    __weak YXPersonalCenterVC *weakSelf = self;
    [YXUtils showHUD:self.view];
    [self.model bindSO:bindModel complete:^(id obj, BOOL result) {
        [YXUtils hideHUD:weakSelf.view];
        if (result) {
            [weakSelf reloadAllRightDetails];
        }
    }];
}

- (void) bindQQ {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络不给力!"];
        return;
    }
    [[QQApiManager shared] qqLogin];
}

- (void) bindWechat {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络不给力!"];
        return;
    }
    [[WXApiManager shared] wxLogin];
}

- (void) showUnBindWechatAlert {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络不给力!"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [YXComAlertView showAlert:YXAlertCommon
                       inView:[UIApplication sharedApplication].keyWindow
                         info:@"提示"
                      content:@"解绑后将无法使用微信微信进行登录，是否确认解除绑定？"
                   firstBlock:^(id obj) {
        [weakSelf unBind:@"wechat"];
    } secondBlock:^(id obj) {
        
    }];
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"解绑后将无法使用%@微信进行登录，是否确认解除绑定？", @"微信"] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { NSLog(@"action = %@", action); }];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        [self unBind:@"wechat"];
//    }];
//
//    [alert addAction:defaultAction];
//    [alert addAction:cancelAction];
//    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void) showUnBindQQAlert {
    if ([NetWorkRechable shared].netWorkStatus == NetWorkStatusNotReachable) {
        [YXUtils showHUD:self.view title:@"网络不给力!"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [YXComAlertView showAlert:YXAlertCommon
                       inView:[UIApplication sharedApplication].keyWindow
                         info:@"提示"
                      content:@"解绑后将无法使用QQ微信进行登录，是否确认解除绑定？"
                   firstBlock:^(id obj) {
        [weakSelf unBind:@"qq"];
    } secondBlock:^(id obj) {
        
    }];
    
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"解绑后将无法使用%@微信进行登录，是否确认解除绑定？", @"QQ"] preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) { NSLog(@"action = %@", action); }];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
//        [self unBind:@"qq"];
//    }];
//
//    [alert addAction:defaultAction];
//    [alert addAction:cancelAction];
//    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

- (void)unBind:(NSString *)platform {
    __weak YXPersonalCenterVC *weakSelf = self;
    
    [YXUtils showHUD:self.view];
    
    [self.model unbindSO:platform complete:^(id obj, BOOL result) {
        
        if (result) {
            
            [weakSelf.model requestUserInfo:^(id obj, BOOL result) {
                
                [YXUtils hideHUD:weakSelf.view];
                
                [weakSelf reloadAllRightDetails];
            }];
        } else {
            NSLog(@"_++_++_+____++__+___++_+___++_+_");
            [YXUtils hideHUD:weakSelf.view];
        }
    }];
}

// MARK: - Other Methods

- (void)setUpPersonalInformation:(UITableViewCell *)cell {
    
    self.avatarImageView = [[UIImageView alloc] init]; //WithFrame:CGRectMake(0, 0, 75, 75)

//    r.shadowRadius = 5;
//    continerView.layer.shadowOpacity = 6;
//    continerView.layer.shadowOffset = CGSizeMake(2, 2);
//    continerView.layer.cornerRadius = 6;
    UIView *continer = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, 75, 75)
    continer.backgroundColor = [UIColor whiteColor];
    continer.layer.shadowColor = UIColorOfHex(0xD0E0EF).CGColor;
    continer.layer.shadowRadius = 2;
    continer.layer.shadowOffset = CGSizeMake(0, 2);
    continer.layer.shadowOpacity = 0.6;
    continer.layer.cornerRadius = 8;
//    self.avatarImageView.layer.masksToBounds = YES;
    
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (self.avatarImage != nil) {
        self.avatarImageView.image = self.avatarImage;
    } else {
        NSString *imageURL = self.userModel.avatar;
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    self.avatarImageView.layer.cornerRadius = 8;
    self.avatarImageView.layer.masksToBounds = YES;

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = self.userModel.nick;
    self.nameLabel.textColor = UIColorOfHex(0x485461);
    
    [continer addSubview:self.avatarImageView];
    [cell.contentView addSubview:self.nameLabel];
    [cell.contentView addSubview:continer];
    
    [continer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(75);
        make.left.equalTo(cell.contentView).offset(16);
        make.centerY.equalTo(cell.contentView).offset(-15);
    }];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(continer).insets(UIEdgeInsetsMake(3, 3, 3, 3));
//        make.height.width.mas_equalTo(75);
//        make.left.equalTo(cell.contentView).offset(16);
//        make.centerY.equalTo(cell.contentView).offset(-15);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(16);
        make.right.equalTo(cell.contentView).offset(-16);
        make.centerY.equalTo(cell.contentView);
    }];
}

- (void)setUpCalendarInfomation:(YXPersonalCenterCell *)cell {
    NSString *days = [NSString stringWithFormat:@"%zd", self.userModel.punchDays.integerValue];
    NSString *str = [NSString stringWithFormat:@"本月已打卡%@天", days];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: UIColorOfHex(0x485461)}];
    [attrStr addAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15], NSForegroundColorAttributeName: UIColorOfHex(0xFDA751)} range:NSMakeRange(5, days.length)];
    cell.titleLabel.attributedText = attrStr;
}

 - (void)setUpBadges:(UITableViewCell *)cell {
    
    UILabel *myBadgeLabel = [[UILabel alloc] init];
    myBadgeLabel.text = @"我的徽章";
    myBadgeLabel.textColor = UIColorOfHex(0x485461);

    self.badgeCountLabel = [[UILabel alloc] init];
     self.badgeCountLabel.font = [UIFont systemFontOfSize:15];
    int completedCount = 0;
    for (int i = 0; i < self.allBadgesDetails.count; i++) {
        NSString *finishDate = [self.allBadgesDetails[i] valueForKey:@"finishTime"];
        if (finishDate) {
            completedCount = completedCount + 1;
        }
    }
    self.badgeCountLabel.text = [NSString stringWithFormat:@"%d/19", completedCount];
    self.badgeCountLabel.textColor = UIColorOfHex(0x849EC5);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     
    CGFloat size = (SCREEN_WIDTH - 124) / 6 > 44 ? 44 : (SCREEN_WIDTH - 124) / 6;
    layout.itemSize = CGSizeMake(size, size);
    
     
    CGFloat space = (SCREEN_WIDTH - 64 - (size * 6)) / 5 < 12 ? 12 :(SCREEN_WIDTH - 64 - (size * 6)) / 5;
    layout.minimumLineSpacing = space;
    
    self.badgeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.badgeCollectionView.backgroundColor = UIColor.whiteColor;
    self.badgeCollectionView.showsHorizontalScrollIndicator = NO;
    [self.badgeCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"BadgeCell"];
    self.badgeCollectionView.delegate = self;
    self.badgeCollectionView.dataSource = self;
     
     
    UIImageView *accessoryImage = [[UIImageView alloc] init];
    accessoryImage.tintColor = UIColorOfHex(0x849EC5);
    accessoryImage.contentMode = UIViewContentModeScaleAspectFit;
    accessoryImage.image = [UIImage imageNamed:@"圆角矩形"];

    [cell.contentView addSubview:myBadgeLabel];
    [cell.contentView addSubview:self.badgeCountLabel];
    [cell.contentView addSubview:accessoryImage];
    [cell.contentView addSubview:self.badgeCollectionView];
    
    [myBadgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(cell.contentView).offset(16);
    }];
    
    [self.badgeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accessoryImage).offset(-16);
        make.centerY.equalTo(myBadgeLabel);
    }];
    
    [accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(myBadgeLabel);
        make.right.equalTo(cell.contentView).offset(-16);
    }];
    
    [self.badgeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView).offset(16);
        make.right.equalTo(cell.contentView).offset(-16);
        make.top.equalTo(myBadgeLabel.mas_bottom).offset(16);
        make.bottom.equalTo(cell.contentView).offset(-16);

    }];
}

- (void)addPhotoNumber:(UITableViewCell *)cell with:(NSString *)phoneNumber {
    UILabel *phoneNumberLabel = [[UILabel alloc] init];
    NSString *phoneNumberWithStar = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    
    phoneNumberLabel.text = phoneNumberWithStar;
    phoneNumberLabel.textColor = UIColorOfHex(0x849EC5);
    phoneNumberLabel.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:phoneNumberLabel];
    
    [phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-16);
    }];
}

- (void)addToBindImageButton:(UITableViewCell *)cell with:(NSString *)thirdPart {
    UIButton *bindButton = [[UIButton alloc] init];
    [bindButton setImage:[UIImage imageNamed:@"去绑定"] forState:UIControlStateNormal];
    
    if ([thirdPart isEqualToString:@"Wechat"]) {
        [bindButton addTarget:self action:@selector(bindWechat) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [bindButton addTarget:self action:@selector(bindQQ) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell.contentView addSubview:bindButton];
    
    [bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-10);
    }];
}

- (void)addUnBindImageButton:(UITableViewCell *)cell with:(NSString *)thirdPart {
    UIButton *bindButton = [[UIButton alloc] init];
    [bindButton setImage:[UIImage imageNamed:@"解除绑定"] forState:UIControlStateNormal];
    
    if ([thirdPart isEqualToString:@"Wechat"]) {
        [bindButton addTarget:self action:@selector(showUnBindWechatAlert) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [bindButton addTarget:self action:@selector(showUnBindQQAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell.contentView addSubview:bindButton];
    
    [bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.right.equalTo(cell).offset(-16);
    }];
}

- (void)showVoiceChooseAlert:(YXPersonalCenterCellModel *)model { //:(void(^)(NSString *pronunciation))block {
    
    [LEEAlert actionsheet].config
    
    .LeeTitle(@"选择音标和发音")
    
//    .LeeAddTitle(^(UILabel * _Nonnull label) {
//        label.text = @"选择音标和发音";
//
//    })

    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"英式音标和发音";
        action.titleColor = UIColor.blackColor;
        action.font = [UIFont systemFontOfSize:18.0f];

        action.clickBlock = ^{
            [YXConfigure shared].isUSVoice = NO;
            [self postPronounceSetting:@"0" andCellModel:model];
//            block(@"英式");
        };
    })
    
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDefault;
        action.title = @"美式音标和发音";
        action.titleColor = UIColor.blackColor;
        action.font = [UIFont systemFontOfSize:18.0f];
        
        action.clickBlock = ^{
            [YXConfigure shared].isUSVoice = YES;
            [self postPronounceSetting:@"1" andCellModel:model];
//            block(@"美式");
        };
    })
    
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = UIColorOfHex(0x8095AB);
        action.font = [UIFont systemFontOfSize:18.0f];
    })
    
    .LeeActionSheetCancelActionSpaceColor(UIColorOfHex(0xF6F8FA))
    .LeeActionSheetBottomMargin(0.0f)
    .LeeCornerRadius(0.0f)
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    })
    
    .LeeActionSheetBackgroundColor([UIColor whiteColor])
    .LeeShow();
}

- (void)exitPersonalCenter {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logout:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[YXStudyRecordCenter shared]queryRecord:^(id obj, BOOL result) {
        NSString *content = result?@"检测到有未上传的学习记录，退出登录后将会丢失！！！取消后打开网络连接即可自动上传。":nil;
        [YXComAlertView showAlert:YXAlertLogout
                           inView:[UIApplication sharedApplication].keyWindow
                             info:nil
                          content:content
                       firstBlock:^(id obj) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                YXLogoutModel *logoutModel = [[YXLogoutModel alloc]init];
                logoutModel.jp_devices_id = [YXConfigure shared].deviceId;
                logoutModel.jp_registration_id = jgId;
                [YXUtils showHUD:weakSelf.view];
                
//                __weak YXPersonalCenterVC *weakSelf = self;
                [weakSelf.model logout:logoutModel finish:^(id obj, BOOL result) {
                    [YXUtils hideHUD:weakSelf.view];
                    [[YXMediator shared] loginOut];
                    
                    //删除签到的本地记录
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:@"" forKey:kDailyCheckInNotify];
                    [defaults synchronize];
                    
                }];
            });
        } secondBlock:^(id obj) {
        }];
    }];
}

// MARK: - Post Methods

- (void)postPronounceSetting:(NSString *)value andCellModel:(YXPersonalCenterCellModel *)model{
    
//    NSNumber *intValue = [NSNumber numberWithInt:[value intValue]];
    NSDictionary * paramter = @{@"speech":value};
    
    [YXDataProcessCenter POST:DOMAIN_SETUP parameters:paramter finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            model.rightDetail = [value isEqualToString:@"0"] ? @"英式" : @"美式";
            [self.tableView reloadData];
            NSLog(@"++++++++++++++++++++++++++++++");
        }
    }];
}

- (void)postBindSeting:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *token = [userInfo valueForKey:@"token"];
    NSString *openID = [userInfo valueForKey:@"openID"];
    
    NSString *platform = notification.object;
    
    NSDictionary *paramters = @{@"bind_pf":platform, @"code":token, @"openid":openID};
    
    [YXDataProcessCenter POST:DOMAIN_BIND parameters:paramters finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            [self reloadAllRightDetails];
        } else {
            NSLog(@"%@",response.error.desc);
        }
    }];
}

// MARK: - Notification
- (void)changeAvatar:(NSNotification *)notification {
    self.userModel.avatar = notification.object;
    [self.tableView reloadData];
//    self.avatarImage = notification.object;
}

// MARK: - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
