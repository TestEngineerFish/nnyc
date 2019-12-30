//
//  YXCareerViewController.m
//  YXEDU
//
//  Created by yixue on 2019/2/19.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerViewController.h"
#import "YXCareerBigNaviView.h"
#import "YXCustomScrollView.h"
#import "YXCareerWordListViewController.h"
#import "YXCareerWordListModel.h"
#import "YXCareerWordListTableViewCell.h"
#import "YXCareerGuideMaskView.h"

static NSString *const kYXCareerWordListTableViewCellID = @"YXCareerWordListTableViewCellID";

@interface YXCareerViewController () <UIScrollViewDelegate,YXCareerBigNaviViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YXCareerBigNaviView *careerBigNaviView;

@property (nonatomic, strong) UIView *careerBookListView;
@property (nonatomic, strong) UITableView *careerBookListTableView;
@property (nonatomic, strong) UIButton *careerBookListViewBackBtn;
@property (nonatomic, strong) NSMutableArray *bookList;
@property (nonatomic, assign) BOOL isWordListHidden;

@property (nonatomic, weak) YXCustomScrollView *contentsScrollView;

@end

@implementation YXCareerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    
}

#pragma mark - set/get
- (void)setCareerModel:(YXCareerModel *)careerModel {
    _careerModel = careerModel;
    
    self.careerBigNaviView.careerModel = careerModel;

    [self setupContentsScrollView];
    [self setUpChildViewControllers];
    
    [_careerBigNaviView.segmentView selectTitleAtIndex:self.selectedIndex];
    
    _isWordListHidden = YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ifShowedCareerGuide = [defaults objectForKey:kCheckIfShowedCareerGuide];
    if (!ifShowedCareerGuide) {
        YXCareerGuideMaskView *guideView = [[YXCareerGuideMaskView alloc] init];
        [self.view addSubview:guideView];
        [defaults setBool:YES forKey:kCheckIfShowedCareerGuide];
        [defaults synchronize];
    }
}

- (void)setIsWordListHidden:(BOOL)isWordListHidden {
    _isWordListHidden = isWordListHidden;
    if (_isWordListHidden) {
        [self hideCareerBookListView];
    } else {
        [self showCareerBookListView];
    }
}

- (void)setBookList:(NSMutableArray *)bookList {
    //filter booklist
//    NSArray *temAry = [NSArray arrayWithArray:bookList];
//    for (YXCareerWordListModel *model in temAry) {
//        if (model.bookId == _careerModel.bookId) {
//            [bookList removeObject:model];
//            [bookList insertObject:model atIndex:0];
//        }
//    }
    _bookList = bookList;
}

#pragma mark - SubViews
- (YXCareerBigNaviView *)careerBigNaviView {
    if (!_careerBigNaviView) {
        _careerBigNaviView = [[YXCareerBigNaviView alloc] initWithPosition:CGPointMake(0, 0)];
        _careerBigNaviView.delegate = self;
        [self.view addSubview:_careerBigNaviView];
    }
    return _careerBigNaviView;
}

- (void)setupCareerBigNaviView {
    _careerBigNaviView = [[YXCareerBigNaviView alloc] initWithPosition:CGPointMake(0, 0)];
    _careerBigNaviView.delegate = self;
    _careerBigNaviView.careerModel = _careerModel;
    [self.view addSubview:_careerBigNaviView];
}

- (void)setupContentsScrollView {
    [self removeScrollViewandChildVC];

    YXCustomScrollView *contentsScrollView = [[YXCustomScrollView alloc] init];
    contentsScrollView.backgroundColor = UIColorOfHex(0xF3F8FB);
    contentsScrollView.delegate = self;
    contentsScrollView.showsVerticalScrollIndicator = NO;
    contentsScrollView.showsHorizontalScrollIndicator = NO;
    contentsScrollView.pagingEnabled = YES;
    contentsScrollView.scrollEnabled = NO;
    contentsScrollView.frame = CGRectMake(0, kNavHeight + 30, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight + 30);
    [self.view addSubview:contentsScrollView];
    _contentsScrollView = contentsScrollView;
}

- (void)setUpChildViewControllers {
    CGRect oriRect = self.contentsScrollView.bounds;
    NSMutableArray *childVC = [NSMutableArray array];

    for (NSInteger i = 0; i < _careerModel.itemTitles.count; i++) {
        YXCareerWordListViewController *wordsListVC = [[YXCareerWordListViewController alloc] init];
        wordsListVC.wordListViewType = i;
        NSInteger sort = _careerModel.sort;
        if (i == 3) { sort = 5; }
        wordsListVC.careerModel = [[YXCareerModel alloc] initWithItem:[self getItemNameWith:wordsListVC.wordListViewType]
                                                               bookId:_careerModel.bookId
                                                                 sort:sort];
        [childVC addObject:wordsListVC];
    }
    //假如4个title 交换第二个和第四个的位置
    if (_careerModel.itemTitles.count == 4) {
        [childVC exchangeObjectAtIndex:1 withObjectAtIndex:3];
        [childVC exchangeObjectAtIndex:2 withObjectAtIndex:3];
    }
    for (YXCareerWordListViewController *wordsListVC in childVC) {
        [self addChildViewController:wordsListVC];
        [self.contentsScrollView addSubview:wordsListVC.view];
    }
    
    self.contentsScrollView.contentSize = CGSizeMake(oriRect.size.width * _careerModel.itemTitles.count, 0);
}

- (NSString *)getItemNameWith:(kYXWordListViewType)type {
    switch (type) {
        case kYXWordListStudied: return @"learned";break;
        case kYXWordListCollection: return @"fav";break;
        case kYXWordListError: return @"wrong";break;
        case kYXWordListNotStudied: return @"new";break;
    }
}

- (void)removeScrollViewandChildVC {
    [self.contentsScrollView removeFromSuperview];
    self.contentsScrollView = nil;
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
}

- (void)showCareerBookListView {
    
    [self hideCareerBookListView];
    
    [YXDataProcessCenter GET:DOMAIN_NOTEBOOKLIST parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
         if (result) {
             NSArray *bookDics = [response.responseObject objectForKey:@"bookList"];
             NSMutableArray *bookList = [YXCareerWordListModel mj_objectArrayWithKeyValuesArray:bookDics];
             self.bookList = bookList;
             //
             _careerBookListView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight + 30, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight - 30)];
             [self.view addSubview:_careerBookListView];
             //
             _careerBookListViewBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight - 30)];
             _careerBookListViewBackBtn.backgroundColor = [UIColor blackColor];
             _careerBookListViewBackBtn.alpha = 0;
             [_careerBookListView addSubview:_careerBookListViewBackBtn];
             [_careerBookListViewBackBtn addTarget:self action:@selector(listViewBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
             //
             _careerBookListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
             [_careerBookListTableView registerClass:[YXCareerWordListTableViewCell class] forCellReuseIdentifier:kYXCareerWordListTableViewCellID];
             _careerBookListTableView.backgroundColor = [UIColor clearColor];
             _careerBookListTableView.bounces = NO;
             _careerBookListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
             _careerBookListTableView.delegate = self;
             _careerBookListTableView.dataSource = self;
             [_careerBookListView addSubview:_careerBookListTableView];
             //
             [UIView animateWithDuration:0.4 animations:^{
                 _careerBookListViewBackBtn.alpha = 0.5;
                 //修复数据过长
                 if ( (55 * _bookList.count) < (SCREEN_HEIGHT - kNavHeight - 30)){
                     _careerBookListTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 55 * _bookList.count);
                 }
                 else{
                     _careerBookListTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight- 30);
                 }
                 
             } completion:^(BOOL finished) {
                 //
             }];
         } else {
             _isWordListHidden = YES;
         }
     }];
}

- (void)listViewBackBtnClicked:(UIButton *)sender {
    self.isWordListHidden = YES;
}

- (void)hideCareerBookListView {
    [UIView animateWithDuration:0.4 animations:^{
        _careerBookListViewBackBtn.alpha = 0;
        _careerBookListTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [_careerBookListView removeFromSuperview];
        _careerBookListView = nil;
        _careerBookListViewBackBtn = nil;
        _careerBookListTableView = nil;
    }];
}

#pragma mark - UITableViewDelegate/DataSouce
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCareerWordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCareerWordListTableViewCellID forIndexPath:indexPath];
    cell.wordListModel = _bookList[indexPath.row];
    if (cell.wordListModel.bookId == _careerModel.bookId) {
        cell.label.textColor = UIColorOfHex(0x55A7FD);
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //切换词书
    self.isWordListHidden = YES;
    YXCareerWordListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.wordListModel.bookId != _careerModel.bookId){
        YXCareerWordListModel *wordListModel = _bookList[indexPath.row];
        YXCareerModel *newCareerModel = [YXCareerModel alloc];
        newCareerModel = [newCareerModel initWithItem:@"learned" bookId:wordListModel.bookId sort:1];
        [self handleIndex:wordListModel.bookId];
        self.careerModel = newCareerModel;
    }
}

- (void)handleIndex:(NSInteger)newBookId {
    if (_careerModel.itemTitles.count == 4 && newBookId == 0) {
        switch (_selectedIndex) {
            case 0:break;
            case 1:_selectedIndex = 0;break;
            case 2:_selectedIndex = 1;break;
            case 3:_selectedIndex = 2;break;
            default:break;
        }
    }
    if (_careerModel.itemTitles.count == 3 && newBookId != 0) {
        switch (_selectedIndex) {
            case 0:break;
            case 1:_selectedIndex = 2;break;
            case 2:_selectedIndex = 3;break;
            default:break;
        }
    }
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
//    [_careerBigNaviView.segmentView fatherVCContentscrollViewDidScrollScale:scale];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (scrollView != self.contentsScrollView) {
//        return;
//    }
//    [self scrollViewDidEndScrollingAnimation:scrollView];
//}
////
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
////    [_careerBigNaviView.segmentView fatherVCContentscrollViewDidScrollScale:scale];
//    [_careerBigNaviView.segmentView fatherVCContentscrollViewDidEndScrollingAnimationIndex:scale];
//}

#pragma mark - LGYsegmentTitleViewDelegate
- (void)segmentView:(LGYSegmentView *)segementView didSelectedTitleIndex:(NSInteger)index {
    YXCareerWordListViewController *baseVC = self.childViewControllers[index];
    CGPoint offset = self.contentsScrollView.contentOffset;
    offset.x = index * self.contentsScrollView.frame.size.width;
    
    CGFloat width = self.contentsScrollView.frame.size.width;
    CGFloat height = self.contentsScrollView.frame.size.height;
    
    [self.contentsScrollView setContentOffset:offset animated:YES];
    baseVC.view.frame = CGRectMake(offset.x, 0, width, height);
    
    self.isWordListHidden = YES;
    [self.contentsScrollView addSubview:baseVC.view];
    
    self.selectedIndex = index;
}

#pragma mark - YXCareerBigNaviViewDelegate
- (void)careerBigNaviViewDidClickedTitle:(YXCareerBigNaviView *)careerBigNaviView {
    self.isWordListHidden = !self.isWordListHidden;
}

- (void)careerBigNaviViewDidClickedBack:(YXCareerBigNaviView *)careerBigNaviView {
    [self.navigationController popViewControllerAnimated:true];
}

@end
