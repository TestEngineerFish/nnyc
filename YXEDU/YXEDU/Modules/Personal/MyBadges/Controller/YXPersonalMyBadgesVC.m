//
//  YXPersonalMyBadgeVC.m
//  YXEDU
//
//  Created by Jake To on 10/19/18.
//  Copyright © 2018 shiji. All rights reserved.
//
#import "YXComHttpService.h"
#import "NSObject+YR.h"
#import "BSCommon.h"
#import "YXPersonalMyBadgesVC.h"

#import "YXPersonalSectionModel.h"
#import "YXPersonalSectionCell.h"

#import "YXPersonalBadgeModel.h"
#import "YXPersonalBadgeCell.h"
#import "YXConfigure.h"

#import "YXBadgeIncompleteView.h"
#import "YXBadgeCompletedView.h"
#import "YXBadgeView.h"

@interface YXPersonalMyBadgesVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sections;

@property (nonatomic, strong) UIView *badgeDetailView;
@property (nonatomic, strong) UIView *badgeDetailBackgroundView;
@property (nonatomic, strong) UIButton *closeButton;


@end

@implementation YXPersonalMyBadgesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem.leftBarButtonItem setTarget: self];
    [self.navigationItem.leftBarButtonItem setAction: @selector(back)];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 210;
    [self.view addSubview:self.tableView];
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSafeBottomMargin)];
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerClass:[YXPersonalSectionCell class] forCellReuseIdentifier:@"YXPersonalSectionCell"];
    self.tableView.backgroundColor = UIColorOfHex(0xF6F8FA);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [YXBadgeView showBadgeViewWithModel:nil
//                             shareModel:nil
//                            finishBlock:^{
////                                _curShowBadgeIndex ++;
////                                [weakSelf getShareInfo];
//                            }];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


// MARK: - Lazy Load
- (NSArray *)sections {
    if (!_sections) {
        NSMutableArray *sections = [NSMutableArray array];

        NSArray *allColor = @[UIColorOfHex(0xFDB329), UIColorOfHex(0x7FE763), UIColorOfHex(0x56CEFB), UIColorOfHex(0xB198F9)];
        NSMutableArray *allName = [NSMutableArray array];

        NSArray *badgeList = [YXConfigure shared].confModel.badgeList;
        for (YXBadgeListModelOld *badgeListModel in badgeList) {
            [allName addObject:badgeListModel.title];
        }

        for (NSInteger i = 0; i < allColor.count; i++) {
            YXPersonalSectionModel *sectionModel = [[YXPersonalSectionModel alloc] init];
            
            sectionModel.color = allColor[i];
            sectionModel.name = allName[i];
            sectionModel.badges = self.badges[i];
                        
            [sections addObject:sectionModel];
        }

        _sections = sections;
        
    }
    
    return _sections;
}

// MARK: TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sections.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(YXPersonalSectionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.collectionView.delegate = self;
    cell.collectionView.dataSource = self;
    cell.collectionView.tag = indexPath.row;
    
    [cell.collectionView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXPersonalSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalSectionCell" forIndexPath:indexPath];
    YXPersonalSectionModel *section = self.sections[indexPath.row];
    
    cell.colorView.backgroundColor = section.color;
    cell.sectionNameLabel.text = section.name;
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

// MARK: Collection Delegate & DataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YXPersonalSectionModel *sectionModel = self.sections[collectionView.tag];
    return sectionModel.badges.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXPersonalBadgeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXPersonalBadgeCell" forIndexPath:indexPath];
    YXPersonalBadgeModel *badge = self.badges[collectionView.tag][indexPath.row];
    
    cell.badgeNameLabel.text = badge.badgeName;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *finishDate = [formatter dateFromString: [NSDate dateWithTimeIntervalSince1970: [badge.finishDate doubleValue]]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *finishDateString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970: [badge.finishDate doubleValue]]];

    
    if ([badge.finishDate isEqualToString:@"0"]) {
        [cell.badgeImageView sd_setImageWithURL:[NSURL URLWithString:badge.incompleteBadgeImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.dateLabel.text = @"";

    } else {
        [cell.badgeImageView sd_setImageWithURL:[NSURL URLWithString:badge.completedBadgeImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cell.dateLabel.text = finishDateString;

    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView reloadData];

    YXPersonalBadgeModel *badge = self.badges[collectionView.tag][indexPath.row];

    if ([badge.finishDate isEqualToString:@"0"]) {
        self.badgeDetailView = [YXBadgeIncompleteView showIncompletedViewWithBadge:badge];
    } else {
        self.badgeDetailView = [YXBadgeCompletedView showCompletedViewWithBadge:badge];
    }

    self.badgeDetailBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetail)];
    [self.badgeDetailBackgroundView addGestureRecognizer:tap];
    self.badgeDetailBackgroundView.backgroundColor = UIColor.blackColor;

    self.closeButton = [[UIButton alloc] init];
    [self.closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeDetail) forControlEvents:UIControlEventTouchUpInside];

    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:self.badgeDetailBackgroundView];
    [currentWindow addSubview:self.badgeDetailView];
    [currentWindow addSubview: self.closeButton];

    [self.badgeDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(280);
        make.height.mas_equalTo([badge.finishDate isEqualToString:@""] ? 346 : 324);//346 : 386
        make.center.equalTo(currentWindow);
    }];

    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(36);
        make.top.equalTo(self.badgeDetailView.mas_bottom).offset([badge.finishDate isEqualToString:@""] ? 20 : 28);
        make.centerX.equalTo(currentWindow);
    }];

    self.closeButton.alpha = 0;
    self.badgeDetailBackgroundView.alpha = 0;
    self.badgeDetailView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.closeButton.alpha = 1;
        self.badgeDetailBackgroundView.alpha = 0.5;
        self.badgeDetailView.alpha = 1;
    }];
    
    [self traceEvent:kTraceBadgeWatchTime descributtion:badge.badgeID];
}

- (void)closeDetail {
    [UIView animateWithDuration:0.2 animations:^{
        self.closeButton.alpha = 0;
        self.badgeDetailBackgroundView.alpha = 0;
        self.badgeDetailView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.closeButton removeFromSuperview];
        [self.badgeDetailBackgroundView removeFromSuperview];
        [self.badgeDetailView removeFromSuperview];
    }];
}


@end
