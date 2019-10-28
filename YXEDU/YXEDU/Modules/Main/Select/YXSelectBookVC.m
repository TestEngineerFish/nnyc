//
//  YXSelectBookVC.m
//  YXEDU
//
//  Created by shiji on 2018/5/31.
//  Copyright © 2018年 shiji. All rights reserved.
//

#import "YXSelectBookVC.h"
#import "BSCommon.h"
#import "YXBookListViewModel.h"
#import "YXUtils.h"
#import "YXSelectBookContentVC.h"
#import "YXConfigure.h"
#import "YXSelectBookSegment.h"
#import "YXSelectBookView.h"
#import "YXStudyProgressView.h"
#import "YXConfigModel.h"
#import "YXBookInfoModel.h"
// #import "AppDelegate.h"
#import "YXSelectBookVC.h"

#import "YXBookCollectionViewCell.h"
#import "YXBookCollectionHeader.h"
#import "YXBookCollectionFooter.h"
#import "YXBookSettingViewController.h"
#import "YXBookCateModel.h"
static NSString * const kYXBookCollectionViewCellID = @"YXBookCollectionViewCellID";
static NSString * const kYXBookCollectionHeaderID = @"YXBookCollectionHeaderID";
static NSString * const kYXBookCollectionFooterID = @"YXBookCollectionFooterID";
@interface YXSelectBookVC () <UICollectionViewDataSource,UICollectionViewDelegate,YXSelectBookSegmentDelegate,UIScrollViewDelegate,YXSelectBookViewDelegate,YXSetProgressViewDelegate> //VTMagicViewDataSource, VTMagicViewDelegate,
@property (nonatomic, strong) YXBookListViewModel *bookListViewModel;
@property (nonatomic, strong) VTMagicController *magicController;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, weak)YXSelectBookSegment *segmentControl;
@property (nonatomic, weak)UIImageView *segBGImageView;
@property (nonatomic, weak)UIScrollView *bookListScroll;
@property (nonatomic, strong)NSMutableArray *bookLists;
@property (nonatomic, weak)YXStudyProgressView *progressView;
@property (nonatomic, weak)YXSelectBookView *selectedBookView;
@property (nonatomic, strong)YXConfigBookModel *selBookModel;

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataSource;
@property (nonatomic, strong)NSString *setSuccessBookId;
@property (nonatomic, strong)NSMutableArray *books;
@end

@implementation YXSelectBookVC
+ (YXSelectBookVC *)selectBookVCSelectedSuccessBlock:(SelectedBookSuccessBlock)selectedBookSuccessBlock
{
    YXSelectBookVC *sbvc = [[YXSelectBookVC alloc] init];
    sbvc.selectedBookSuccessBlock = [selectedBookSuccessBlock copy];
    return sbvc;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bookListViewModel = [[YXBookListViewModel alloc]init];
    }
    return self;
}

- (NSMutableArray *)bookLists {
    if (!_bookLists) {
        _bookLists = [NSMutableArray array];
    }
    return _bookLists;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"选择词书";
    self.navigationItem.title = @"选择词书";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    self.view.backgroundColor = UIColorOfHex(0xffffff);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self checkNetwork];
    
    
    if (self.hasLeftBarButtonItem && self.presentingViewController) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"  " forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"comNaviBack_white_normal"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"comNaviBack_white_press"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 50, 44);// CGSizeMake(80, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(switchViewController) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self checkNetwork];
}

- (void)checkNetwork {
    __weak typeof(self) weakSelf = self;
    if (![NetWorkRechable shared].connected) {
        [self showNoNetWorkView:^{
            [weakSelf checkNetwork];
        }];
        return;
    }
    
    [self getBooks];
    [self hideNoNetWorkView];
}

- (void)getBooks {
    [self showLoadingView];
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_BOOKLIST parameters:@{} finshedBlock:^(YRHttpResponse *response, BOOL result) {
        [self hideLoadingView];
        if (result) {//
            NSArray *bookDics = [response.responseObject objectForKey:@"bookList"];
            weakSelf.books = [YXBookCateModel mj_objectArrayWithKeyValuesArray:bookDics];
            [weakSelf.collectionView reloadData];
        }
    }];
}

#pragma mark - <UICollectionViewDataSource,UICollectionViewDelegate> v1.4.0
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.books.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    YXBookCateModel *cateModel = self.books[section];
    return cateModel.options.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kYXBookCollectionViewCellID forIndexPath:indexPath];
    YXBookCateModel *cateModel = self.books[indexPath.section];
    YXBookInfoModel *bookModel = cateModel.options[indexPath.row];
    cell.bookModel = bookModel;
    [cell selectedSuccessed:[bookModel.bookId isEqualToString:self.setSuccessBookId]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YXBookCollectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:kYXBookCollectionHeaderID
                                                                                   forIndexPath:indexPath];
        YXBookCateModel *cateModel = self.books[indexPath.section];
        header.sectionLabel.text = cateModel.title;
        return header;
    }

    YXBookCollectionFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                        withReuseIdentifier:kYXBookCollectionFooterID
                                                                               forIndexPath:indexPath];
    footer.isLastSectionFooter = (indexPath.section == self.books.count - 1);
    return footer;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    YXBookCollectionViewCell *cell = (YXBookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    YXBookInfoModel *bookModel = cell.bookModel;
    if (bookModel.learnedStatus) {// 已有学习计划
        [self setStudyBookWithBookId:bookModel.bookId];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    YXBookSettingViewController *settingVC = [[YXBookSettingViewController alloc] initWith:bookModel setPlanSuccessBlock:^(NSString *bookId) {
        [weakSelf setStudyBookWithBookId:bookId];
    }];
    settingVC.isFirstLogin = self.isFirstLogin;
    
    YXBookTransModel *tranMode = [[YXBookTransModel alloc] init];
    tranMode.imageUrl = bookModel.cover;
    tranMode.originRect = [cell.bookIcon convertRect:cell.bookIcon.frame toView:nil]; //self.view
    self.bookTransHelper.transModel = tranMode;
    [self presentViewController:settingVC animated:YES completion:nil];
}

// 设置要学习的书籍
- (void)setStudyBookWithBookId:(NSString *)bookId {
    NSDictionary *param = @{ @"bookId" : bookId };
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter POST:DOMAIN_SETLEARNING parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 设置成功
            
            weakSelf.setSuccessBookId = bookId;
            [weakSelf.collectionView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf switchViewController]; // 退出方式
//                if (strongSelf.selectedBookSuccessBlock) {
//                    strongSelf.selectedBookSuccessBlock();
//                }
            });
        }
    }];
}

- (void)switchViewController {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:NO completion:^{
            if (self.selectedBookSuccessBlock) {
                self.selectedBookSuccessBlock();
            }
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.selectedBookSuccessBlock) {
            self.selectedBookSuccessBlock();
        }
    }
}
//    settingVC.bookModel = bookModel;
//    settingVC.transitioningDelegate = self.bookTransHelper;
//    self.bookTransHelper.transModel = tranMode;

#pragma mark - subviews

/** 重构
 * @return 词书列表
 * @since v1.4.0
 */
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWith = (SCREEN_WIDTH - 4 * kYXBookCellMargin) / 3.0; // 3列
        CGFloat itemHeight = itemWith * kYXBookIconHWScale + kYXBookDescribHeiht;
        layout.itemSize = CGSizeMake(itemWith, itemHeight);
//        layout.sectionHeadersPinToVisibleBounds = YES;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, kYXBookSectionHeaderHeight);
        layout.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, kYXBookSectionFooterHeight);
        layout.minimumInteritemSpacing = kYXBookCellMargin;
        layout.minimumLineSpacing = kYXBookCellMargin;
        layout.sectionInset = UIEdgeInsetsMake(1, kYXBookCellMargin, 0, kYXBookCellMargin);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSafeBottomMargin, 0);
        [collectionView registerClass:[YXBookCollectionViewCell class]
           forCellWithReuseIdentifier:kYXBookCollectionViewCellID];
        
        [collectionView registerClass:[YXBookCollectionHeader class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:kYXBookCollectionHeaderID];
        
        [collectionView registerClass:[YXBookCollectionFooter class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                  withReuseIdentifier:kYXBookCollectionFooterID];
        
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}


- (UIImageView *)segBGImageView {
    if (!_segBGImageView) {
        UIImageView *segBGImageView = [[UIImageView alloc] init];
        segBGImageView.userInteractionEnabled = YES;
        segBGImageView.hidden = YES;
        segBGImageView.image = [UIImage imageNamed:@"segmentImage"];
        [self.view addSubview:segBGImageView];
        _segBGImageView = segBGImageView;
    }
    return _segBGImageView;
}

- (YXSelectBookSegment *)segmentControl {
    if (!_segmentControl) {
        YXSelectBookSegment *segmentControl = [[YXSelectBookSegment alloc] init];
        segmentControl.delegate = self;
        [self.segBGImageView addSubview:segmentControl];
        _segmentControl = segmentControl;
    }
    return _segmentControl;
}

- (UIScrollView *)bookListScroll {
    if (!_bookListScroll) {
        UIScrollView * bookListScroll = [[UIScrollView alloc] init];
        bookListScroll.delegate = self;
        bookListScroll.pagingEnabled = YES;
        bookListScroll.backgroundColor = UIColorOfHex(0xF3F8FB);
        bookListScroll.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:bookListScroll];
        _bookListScroll = bookListScroll;
    }
    return _bookListScroll;
}

-(void)dealloc {
    
}

#pragma mark ->>>>>>>> v1.4.0以前
- (void)refreshContent {
    YXConfigModel *confModel = [YXConfigure shared].confModel;
    if (!confModel) {
        return;
    }
    
    NSArray *titles = [self.bookListViewModel titleArr];
    if (self.bookLists.count) {
        [self.bookLists makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    self.bookListScroll.contentSize = CGSizeMake(SCREEN_WIDTH * titles.count, 0);
    for (NSInteger i = 0; i < titles.count; i++) {
        YXSelectBookView *sBookView = [YXSelectBookView selectedBookViewWith:confModel.bookList[i]
                                                                 andDeletate:self];
        sBookView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight);
        [self.bookListScroll addSubview:sBookView];
        [self.bookLists addObject:sBookView];
    }
    
    self.segmentControl.titles = titles;
    self.segBGImageView.hidden = !titles.count;
    
    self.dataSource = [confModel.bookList copy];
    //    [self scrollViewDidEndDecelerating:self.bookListScroll];
    //    [nativeVC insertGradeModel:[YXConfigure shared].conf3Model.config[pageIndex]];
}

#pragma mark - handleData
- (void)requestConfigure {
    //    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    //    __weak YXSelectBookVC *weakSelf = self;
    //    [self.bookListViewModel requestConfigure:^(id obj, BOOL result) {
    //        [YXUtils hideHUD:[UIApplication sharedApplication].keyWindow];
    //        [_magicController.magicView reloadData];
    //        [weakSelf refreshContent];
    //    }];
}
#pragma mark - <YXSelectBookViewDelegate>
- (void)selectBookView:(YXSelectBookView *)selBookView didSelectedBook:(YXConfigBookModel *)bModel {
    NSDictionary *param = @{ @"bookId" : bModel.bookId };
    __weak typeof(self) weakSelf = self;
    self.selectedBookView = selBookView;
    self.selBookModel = bModel;
    //    [YXUtils showHUD:[UIApplication sharedApplication].keyWindow];
    // 获取书籍信息,是否存在学习计划
    [YXDataProcessCenter GET:DOMAIN_BOOKINFO parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            id data = response.responseObject;
            YXBookInfoModel *bookModel = [YXBookInfoModel mj_objectWithKeyValues:[data objectForKey:@"bookInfo"]];
            if (bookModel.learnedStatus) { // 已有学习计划
                [weakSelf setBookLearning:bModel.bookId];
            }else {
                [weakSelf popStudyProgressViewWith:bModel];
            }
        }
    }];
}

// 设置要学习的书籍
- (void)setBookLearning:(NSString *)bookId {
    NSDictionary *param = @{ @"bookId" : bookId };
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter POST:DOMAIN_SETLEARNING parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 设置成功
            [weakSelf.progressView hide];
            [weakSelf.selectedBookView refreshTableWithCurrentBookId:bookId];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                [strongSelf switchViewController]; // 退出方式
                if (strongSelf.selectedBookSuccessBlock) {
                    strongSelf.selectedBookSuccessBlock();
                }
                
            });
        }
    }];
}

/**
 *弹出设置计划的界面
 *@param bModel 计划初始模型
 *1、所选书设置过学习计划，直接将该本书设置成正在学习
 *2、所学术为设置过学习计划则为新书，无需显示次日生效提示
 */
- (void)popStudyProgressViewWith:(YXConfigBookModel *)bModel {
    YXBookPlanModel *planModel = [YXBookPlanModel
                                  planModelWith:bModel.bookId
                                  planNum:0
                                  leftWords:[bModel.wordCount integerValue]
                                  todayLeftWords:0];
    YXStudyProgressView *progressView = [YXStudyProgressView showProgressInView:self.view withPlanModel:planModel WithDelegate:self];
    //    YXStudyProgressView *progressView = [YXStudyProgressView showProgressInView:self.view withPlanModel:planModel];
    if (self.presentingViewController) {
        [progressView.setProgressView hideTipsLabel];
    }
    self.progressView = progressView;
}
#pragma mark - <YXStudyProgressViewDelegate>
//- (void)studyProgressViewAffirmBtn:(YXStudyProgressView *)pView  { //withParam:(NSDictionary *)param
- (void)setProgressViewAffirmBtn:(YXSetProgressView *)pView {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{
                            @"bookId" : pView.planModel.bookId,
                            @"planNum" : @(pView.planModel.planNum)
                            };
    [YXDataProcessCenter POST:DOMAIN_STUDYPLAN parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { // 设置计划成功
            [weakSelf setBookLearning:[param objectForKey:@"bookId"]];
        }
    }];
}
#pragma mark - <YXSelectBookSegmentDelegate>
- (void)selectBookSegment:(YXSelectBookSegment *)sgm selectTitleIndex:(NSInteger)index {
    CGFloat width = self.bookListScroll.bounds.size.width * index;
    [self.bookListScroll setContentOffset:CGPointMake(width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView != self.bookListScroll) {
        return;
    }
    CGFloat width = scrollView.frame.size.width;
    //    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    NSInteger index = offsetX / width;
    [self.segmentControl selectTitleAtIndex:index];
    //    UITableView *bookList = self.bookLists[index];
    //    bookList.frame = CGRectMake(offsetX, 0, width, height);
    //    [scrollView addSubview:bookList];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView != self.bookListScroll) {
        return;
    }
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

@end

//        [YXUtils showHUD:self];
//        [[YXHttpService shared] POST:DOMAIN_STUDYPLAN parameters:param finshedBlock:^(id obj, BOOL result) {
//            [YXUtils hideHUD:self];
//            if (result) {
//                [self tapAction:nil];
//            }
//        }];


//    return;
//    self.magicController.magicView.itemScale = 1;
//    self.magicController.magicView.sliderExtension = 10.0f;
//    self.magicController.magicView.navigationInset = UIEdgeInsetsMake(10, 15, 10, 10);
//    self.magicController.magicView.itemWidth = 88.0f;
//    self.magicController.magicView.itemSpacing = 10.0f;
//    self.magicController.magicView.bubbleInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    self.magicController.magicView.sliderColor = [UIColor clearColor];
//    self.magicController.magicView.separatorColor = UIColorOfHex(0xe6e6e6);
//    [self.magicController.magicView setHeaderHidden:YES duration:0];
//    self.magicController.view.hidden = YES;
//    [self addChildViewController:self.magicController];
//    [self.view addSubview:_magicController.view];
//    [self.view setNeedsUpdateConstraints];
//
//    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, 1)];
//    self.lineView.backgroundColor = UIColorOfHex(0xe6e6e6);
//    [self.view addSubview:self.lineView];
//
//    [_magicController.magicView reloadData];

//
//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//
//    UIView *magicView = _magicController.view;
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[magicView]-0-|", kNavHeight]
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
//}
//
//- (void)leftBtnClicked:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//
//
//#pragma mark - subviews
//- (UIView *)segmentControl {
//    if (!_segmentControl) {
//        UIView *segmentControl = [[UIView alloc] init];
//        [self.view addSubview:segmentControl];
//        _segmentControl = segmentControl;
//    }
//    return _segmentControl;
//}
//
//#pragma mark - desp
//- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
//    return [self.bookListViewModel titleArr];
//}
//
//- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
//    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:@"title"];
//    if (!menuItem) {
//        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
//        [menuItem setTitleColor:UIColorOfHex(0x535353) forState:UIControlStateNormal];
//        menuItem.titleLabel.font = [UIFont systemFontOfSize:10];
//        [menuItem setBackgroundImage:[UIImage imageNamed:@"select_title_selected"] forState:UIControlStateSelected];
//        [menuItem setBackgroundImage:[UIImage imageNamed:@"select_title_unselected"] forState:UIControlStateNormal];
//    }
//    return menuItem;
//}
//
//- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
//    NSString *identifier = [NSString stringWithFormat:@"%@", @(pageIndex)];
//    YXSelectBookContentVC *nativeVC = [magicView dequeueReusablePageWithIdentifier:identifier];
//    if (!nativeVC) {
//        nativeVC = [[YXSelectBookContentVC alloc] init];
//    }
//    nativeVC.transType = self.transType;
//    YXConfigure3Model *conf3Model = [YXConfigure shared].conf3Model;
//    [nativeVC insertGradeModel:[YXConfigure shared].conf3Model.config[pageIndex]];
//    return nativeVC;
//}
//
//- (void)vtm_prepareForReuse {
//}
//
//#pragma mark - VTMagicViewDelegate
//
//- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//#ifdef DEBUG
//    NSLog(@"index:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
//#endif
//}
//
//- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//#ifdef DEBUG
//    NSLog(@"index:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
//#endif
//
//}
//
//- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
//#ifdef DEBUG
//    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
//#endif
//}
//
//
//- (VTMagicController *)magicController {
//    if (!_magicController) {
//        _magicController = [[VTMagicController alloc] init];
//        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
//        _magicController.magicView.navigationColor = [UIColor whiteColor];
//        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
//        _magicController.magicView.sliderStyle = VTSliderStyleBubble;
//        _magicController.magicView.sliderExtension = 10.f;
//        _magicController.magicView.dataSource = self;
//        _magicController.magicView.delegate = self;
//    }
//    return _magicController;
//}
