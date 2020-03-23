//
//  YXCreateWordBookVC.m
//  YXEDU
//
//  Created by yao on 2019/2/20.
//  Copyright © 2019年 shiji. All rights reserved.
//

#import "YXCreateWordBookVC.h"
#import "YXSelectMyWordCell.h"
#import "YXSelectMyWordHeaderView.h"
#import "YXMyBookFooterView.h"
#import "YXLeftTitleButton.h"
#import "YXSwitchBookView.h"
#import "YXBookCategoryModel.h"
#import "YXWordModelManager.h"
#import "YXWordListUsedWordModel.h"
#import "YXSelectedWordsMiniView.h"

#import "YXWordListGuideView.h"
#import "YXLoadingView.h"

static CGFloat const LeftTitleContentMargin = 5;
static NSString *const kYXSelectMyWordCellID = @"YXSelectMyWordCellID";
static NSString *const kYXSelectMyWordHeaderViewID = @"YXSelectMyWordHeaderViewID";

static NSString *const kYXSearchresultBookID = @"YXSearchresultBookID";
//static CGFloat const kWordListMaxWordLimited = 10;

@interface YXCreateWordBookVC ()<YXSelectMyWordCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,YXSwitchBookViewDelegate,YXSelectedWordsMiniViewDelegate>
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) YXLeftTitleButton *titleView;
@property (nonatomic, assign) BOOL replaceClearIcon;
@property (nonatomic, weak) YXSwitchBookView *sourceNameView;
@property (nonatomic, weak) YXSpringAnimateButton *saveBtn;

@property (nonatomic, weak) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint preLoc;
@property (nonatomic, strong) NSMutableArray *selectedWords;
@property (nonatomic, strong) NSIndexPath *lastPassByIndexPath;


@property (nonatomic, strong) NSMutableArray *bookCategorys;
@property (nonatomic, copy) NSArray *bookIds;
@property (nonatomic, strong) YXBookContentModel *currentShowBook;

@property (nonatomic, strong) NSMutableArray *wordlistUsedWords;
@property (nonatomic, strong) NSMutableArray *wordlistUsedWordIds;

@property (nonatomic, strong) YXCurrentSeletBookInfo *currentSeletBookInfo;
@property (nonatomic, weak) YXSelectedWordsMiniView *miniView;

@property (nonatomic, strong) YXBookContentModel *currentSearchResultBook;
@property (nonatomic, weak) YXWordListGuideView *guideView;
@property (nonatomic, weak) UIView *blakView;
@property(nonatomic, weak) YXLoadingView *loadingAnimaterView;

@property (nonatomic, strong) NSMutableArray *wordIDs;


@end

@implementation YXCreateWordBookVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.wordIDs = [NSMutableArray array];
        self.currentSeletBookInfo = [[YXCurrentSeletBookInfo alloc] init];
        [self currentSearchResultBook];
    }
    return self;
}

- (YXBookContentModel *)currentSearchResultBook {
    if (!_currentSearchResultBook) {
        _currentSearchResultBook = [[YXBookContentModel alloc] init];
        _currentSearchResultBook.ID = kYXSearchresultBookID;
        _currentSearchResultBook.hasQuaryWordInfo = YES;
        YXBookUnitContentModel *searchResultUnit = [[YXBookUnitContentModel alloc] init];
        _currentSearchResultBook.content = [NSMutableArray arrayWithObject:searchResultUnit];
    }
    return _currentSearchResultBook;
}

- (NSArray *)rightBarItemImages {
    return @[@"magnifier_normal"];
}

- (NSDictionary *)registerCellInfo {
    return @{
             ReuseIdentifierKey : kYXSelectMyWordCellID,
             ReuseClassKey : [YXSelectMyWordCell class]
             };
}

- (NSMutableArray *)selectedWords {
    if (!_selectedWords) {
        _selectedWords = [NSMutableArray array];
    }
    return _selectedWords;
}

- (NSDictionary *)registerSectionHeaderInfo {
    return @{
             ReuseIdentifierKey : kYXSelectMyWordHeaderViewID,
             ReuseClassKey : [YXSelectMyWordHeaderView class]
             };
}

- (void)dealloc {
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIButton *back = (UIButton *)self.leftBarButtonItem.customView;
    [back removeTarget:self.navigationController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    if (self.searchTF.isFirstResponder) {
        [self.searchTF resignFirstResponder];
    }
    UIButton *back = (UIButton *)self.leftBarButtonItem.customView;
    
    [back removeTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    
    [back addTarget:self.navigationController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [kNotificationCenter addObserver:self selector:@selector(loginOutNotify) name:kLogoutNotify object:nil];
    [self.wordListTableView registerClass:[YXMyBookFooterView class]
       forHeaderFooterViewReuseIdentifier:kYXMyBookFooterViewID];
    self.wordListTableView.rowHeight = AdaptSize(56);
    [self.wordListTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AdaptSize(12));
    }];
    
    [self.rightBarItemBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
    [self.rightBarItemBtn setTitle:@"取消" forState:UIControlStateSelected];
    self.rightBarItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.leftBarButtonItem = self.navigationItem.leftBarButtonItem;// 记录返回按钮
    
    self.navigationItem.titleView = self.titleView;
    
    CGFloat blrMarign = AdaptSize(15);
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(-blrMarign);
        make.top.equalTo(self.bottomView).offset(kIsIPhoneXSerious ? AdaptSize(8) : AdaptSize(4));
        make.size.mas_equalTo(MakeAdaptCGSize(140, 40));
    }];
    
    [self.bottomView addSubview:self.changeNameBtn];
    self.changeNameBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.changeNameBtn setImage:[UIImage imageNamed:@"chageNameIcon_bottom"] forState:UIControlStateNormal];
    [self.changeNameBtn setTitleColor:UIColor.blueTextColor forState:UIControlStateNormal];
    self.changeNameBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
    NSString *name = [NSString stringWithFormat:@"我的词单%zd",_numOfNextList];
    [self.changeNameBtn setTitle:name forState:UIControlStateNormal];
    [self.changeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(blrMarign);
        make.height.centerY.equalTo(self.saveBtn);
        make.right.equalTo(self.saveBtn.mas_left).offset(- blrMarign);
    }];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollDownGes:)];
    pan.delegate = self;
    _pan = pan;
    [self.wordListTableView addGestureRecognizer:pan];
    [self.wordListTableView.panGestureRecognizer requireGestureRecognizerToFail:pan];
    
    [self.miniView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-AdaptSize(15));
        make.right.equalTo(self.view).offset(-AdaptSize(10));
        make.size.mas_equalTo(MakeAdaptCGSize(200, kMiniViewCloseHeight));
    }];
    [self handleUsedWords];
}

- (void)setCurBookBrefInf:(YXBookBrefInfo *)curBookBrefInf {
    _curBookBrefInf = curBookBrefInf;
    self.currentSeletBookInfo.bookId = curBookBrefInf.bookId;
    self.currentSeletBookInfo.bookName = curBookBrefInf.bookName;
    [self setTitleWith:curBookBrefInf.bookName];
}

- (void)loginOutNotify {
    [self.guideView maskViewWasTapped];
}

- (void)navBack {
    if (self.selectedWords.count) {
        __weak typeof(self) weakSelf = self;
        [YXComAlertView showAlert:YXAlertCommon
                           inView:[UIApplication sharedApplication].keyWindow
                             info:@""
                          content:@"是否放弃本次选择的单词并退出？"
                       firstBlock:^(id obj) {
                           [weakSelf.navigationController popViewControllerAnimated:YES];
                       } secondBlock:^(id obj) {
                      }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 改名字
- (void)changeWordListName {
    [self showChangeNameViewWithDefaultName:self.changeNameBtn.currentTitle];
}

- (void)wordBookBaseManageView:(YXWordBookBaseManageView *)wordBookBaseManageView clickedButonAtIndex:(NSInteger)idnex {
    if (idnex == 1) {
        NSString *name = wordBookBaseManageView.currentText;
        if (name.length) {
            [self.changeNameBtn setTitle:name forState:UIControlStateNormal];
        }
    }
}
#pragma mark - handle data
- (void)handleUsedWords {
    __weak typeof(self) weakSelf = self;
    [self showTVLoadingView];
    [YXDataProcessCenter GET:DOMAIN_WORDLISTGETUSEDWORD
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    if (result) {
                        NSArray *infos = [response.responseObject objectForKey:@"usedWords"];
                        weakSelf.wordlistUsedWords = [YXWordListUsedWordModel mj_objectArrayWithKeyValuesArray:infos];
                        weakSelf.wordlistUsedWordIds = [self.wordlistUsedWords valueForKeyPath:@"wordId"];
                        [weakSelf handleBookWordsData];
                        [weakSelf hideNoNetWorkView];
                    }else {
                        if (response.error.type == kBADREQUEST_TYPE) {
                            [weakSelf showNoNetWorkView:^{ // tapAction
                                [weakSelf handleUsedWords];
                            }];
                        }
                    }
                }];
    
}

- (void)handleBookWordsData {
    /** 获取词单单词列表数据 */
    [YXDataProcessCenter GET:DOMAIN_WORDLISTBOOKWORDS
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    if (result) {
                        NSArray *bookWordDics = [response.responseObject objectForKey:@"bookWords"];
                        self.bookCategorys = [YXBookCategoryModel mj_objectArrayWithKeyValuesArray:bookWordDics];
                        [self updatecurrentSeletBookInfo];
                        [self findCurrentShowBook];
                        
                        [self checkGuideState];
                    }
                }];
}

- (void)checkGuideState {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kWordListGuideViewShowedKey]) {
        if (!self.guideView) {
            self.guideView = [YXWordListGuideView WordListGuideViewShowToView:self.navigationController.view];
        }
    }
}

- (void)updatecurrentSeletBookInfo {
    self.currentSeletBookInfo.bookCategoryType = YXBookCategoryNormalBook;
    YXBookCategoryModel *books = self.bookCategorys.firstObject;

    self.bookIds = books.bookIds;
    NSInteger index = [self.bookIds indexOfObject:self.currentSeletBookInfo.bookId];
    if (index == NSNotFound && self.bookIds.count) {
        index = 0;
    }
    self.currentSeletBookInfo.categoryBookIndex = index;
}

- (void)findCurrentShowBook {
    YXBookCategoryModel *bookCategory = [self.bookCategorys objectAtIndex:self.currentSeletBookInfo.bookCategoryType];
    self.currentShowBook = [bookCategory.content objectAtIndex:self.currentSeletBookInfo.categoryBookIndex];
    [self handleCurrentShowBookAllWordsDetail];
}

- (void)handleCurrentShowBookAllWordsDetail {
    if (!self.currentShowBook.hasQuaryWordInfo) {
        for (YXBookUnitContentModel *unitModel in self.currentShowBook.content) {
            
            for (YXSelectWordCellModel *selectWordCellModel in unitModel.words) {
                if (!selectWordCellModel.wordDetail) {
                    [YXWordModelManager quardWithWordId:selectWordCellModel.wordId
                                          completeBlock:^(id obj, BOOL result) {
                                              if (result) {
                                                  selectWordCellModel.wordDetail = obj;
                                              }
                                          }];
                }
                
            }
//            NSArray *wordIds = [unitModel valueForKeyPath:@"words.wordId"];
//            [YXWordModelManager quardWithWordIds:wordIds completeBlock:^(id obj, BOOL result) {
//                if (result) {
//                    NSArray *wordDetails = (NSArray *)obj;
//                    for (YXMyWordCellBaseModel *model in unitModel.words) {
//                        NSInteger i = [unitModel.words indexOfObject:model];
//                        model.wordDetail = [wordDetails objectAtIndex:i];
//                    }
//                }
//            }];
        }
        self.currentShowBook.hasQuaryWordInfo = YES;
    }
    [self hideTVLoadingView];
    [self.wordListTableView reloadData];
}

#pragma mark - gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.pan]) {
        CGPoint point = [gestureRecognizer locationInView:self.wordListTableView];
        if (point.x <= 50) {
            return YES;
        }else {
            return NO;
        }
    }
    return YES;
}

- (void)scrollDownGes:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.lastPassByIndexPath = nil;
        
        self.preLoc = [pan locationInView:pan.view];
    }else if (pan.state == UIGestureRecognizerStateChanged ) {//&& [pan isEqual:self.pan]
        CGPoint newLoc = [pan locationInView:pan.view];
        [self commitNewLocation:newLoc];
        self.preLoc = newLoc;
    }
}

- (void)commitNewLocation:(CGPoint)newLoc {
    CGFloat absX = fabs(newLoc.x - self.preLoc.x);
    CGFloat delta = newLoc.y - self.preLoc.y;
    CGFloat absY = fabs(delta);
    if (absY > absX) { // 上下滑动
        CGPoint actualPoint = CGPointMake(newLoc.x, newLoc.y);// + offsetY
        NSIndexPath *indexPath = [self.wordListTableView indexPathForRowAtPoint:actualPoint];
        if (![self.lastPassByIndexPath isEqual:indexPath]) {
            [self handleWordIndexPath:indexPath];
            self.lastPassByIndexPath = indexPath;
        }
    }
}


#pragma mark - handle selectWords
/** 该单词是当前展示书籍 */
- (void)handleWordIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        
        NSInteger selectedWordsCount = self.selectedWords.count;
        
        YXSelectMyWordCell *cell = [self.wordListTableView cellForRowAtIndexPath:indexPath];
        YXSelectWordCellModel *wordModel = (YXSelectWordCellModel *)cell.wordModel;
        
        NSArray *selWordIds = [self.selectedWords valueForKeyPath:@"wordId"];
        if ([selWordIds containsObject:wordModel.wordId]) {
            NSInteger sameSeletWordIdModel = [selWordIds indexOfObject:wordModel.wordId];
            [self.selectedWords removeObjectAtIndex:sameSeletWordIdModel];
        }else {
            if (self.selectedWords.count >= self.wordListMaxWordLimited) {
                [self showMaxLimitToast];
                return;
            }
            if(wordModel){
                [self.selectedWords addObject:wordModel];
            }
            
        }
        
//        if ([self.selectedWords containsObject:wordModel]) {
//            [self.selectedWords removeObject:wordModel];
//        }else {
//            [self.selectedWords addObject:wordModel];
//        }
        
        NSInteger delta = self.selectedWords.count - selectedWordsCount;
        
        //        [self.currentShowBook updateBookSelectedWordCountAtUnit:indexPath.section withDeltaNum:delta];
        [self updateAllBookAndWordListWordStateWith:wordModel.wordId selectedState:(delta > 0)];
        
        YXSelectMyWordHeaderView *curSectionHeader = (YXSelectMyWordHeaderView *)[self.wordListTableView headerViewForSection:indexPath.section];
        [curSectionHeader updateInfo];
        [cell refreshContent];
        //        cell.selectState = (delta > 0);
        //        [self.wordListTableView beginUpdates];
        //        [self.wordListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //        [self.wordListTableView endUpdates];
        
        self.miniView.selectedWords = self.selectedWords;
        [self updateMiniWordCell];
    }
}

- (void)showMaxLimitToast {
    if (![YXUtils currentHUDForView:self.view]) {
        [YXUtils showHUD:self.view title:@"所选单词已超过100个上限"];
    }
}
- (void)updateAllBookAndWordListWordStateWith:(NSString *)wordId selectedState:(BOOL)isselected {
    for (YXBookCategoryModel *bookCategoryModel in self.bookCategorys) {
        for (YXBookContentModel *bookContentModel in bookCategoryModel.content) {
            if ([bookContentModel.bookWordIds containsObject:wordId]) {
                [bookContentModel updateBookWordStateOf:wordId selectedState:isselected];
            }
        }
    }
}

- (void)updateMiniWordCell {
    CGFloat height = kMiniViewCloseHeight;
    if (self.miniView.isOpen) {
        height += self.miniView.selectedWords.count * kMiniWordCellHeigh;
    }
    
    if (height > kMiniViewMaxHeigh) {
        height = kMiniViewMaxHeigh;
    }
    [self.miniView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.saveBtn.enabled = self.selectedWords.count;
}

#pragma mark - <actions>
- (void)rightBarItemClick:(UIButton *)btn {
    if (self.sourceNameView) {
        [self titleViewClicked:self.titleView];
    }
    
    [self.blakView removeFromSuperview];
    btn.selected = !btn.selected;
    
    if(btn.selected) {
        UIView *blankView = [[UIView alloc] init];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:blankView];
        self.navigationItem.titleView = self.searchTF;
        
        [self.searchTF becomeFirstResponder];
    }else {
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
        self.navigationItem.titleView = self.titleView;
        self.searchTF.text = @"";
        [self findCurrentShowBook];
    }
    [self.navigationController.navigationBar setNeedsLayout];
}

- (void)titleViewClicked:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (self.sourceNameView) {
        [self.sourceNameView hide];
    }else {
        self.sourceNameView = [YXSwitchBookView showSourceNameViewToView:self.view];
        self.sourceNameView.delegate = self;
        self.sourceNameView.currentSeletBookInfo = self.currentSeletBookInfo;
        self.sourceNameView.bookCategorys = self.bookCategorys;
        [self.sourceNameView showAnimate];
    }
}

- (void)saveWordList {
    NSString *wordListName = self.changeNameBtn.currentTitle;
    NSArray *selWordIds = [self.selectedWords valueForKeyPath:@"wordId"];
    NSString *words = [selWordIds componentsJoinedByString:@"|"];
    NSDictionary *param = @{
                            @"words" : words,
                            @"wordListName" : wordListName
                            };
    
    [YXUtils showProgress:self.view];
    [YXDataProcessCenter POST:DOMAIN_CREATEWORDLIST
                   parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
                       [YXUtils hidenProgress:self.view];
                       if (result) { //创建成功
                           if (self.saveWordListSuccessBlock) {
                               self.saveWordListSuccessBlock();
                           }
                           [self.navigationController popViewControllerAnimated:YES];
                       }
                   }];
    
}
#pragma mark - <YXSelectedWordsMiniViewDelegate>
- (void)selectedWordsMiniViewTitleClick:(YXSelectedWordsMiniView *)selectedWordsMiniView {
    [self updateMiniWordCell];
}

- (void)selectedWordsMiniViewDeleteWords:(YXSelectWordCellModel *)selectWordCellModel {
    NSString *wordId = selectWordCellModel.wordId;
    
    [self.selectedWords removeObject:selectWordCellModel];
    [self updateAllBookAndWordListWordStateWith:wordId selectedState:NO];
    
    if ([self.currentShowBook.bookWordIds containsObject:wordId]) {
        NSIndexPath *deleteIndexPath = [self.currentShowBook indexPathOfWordId:wordId];
        YXSelectMyWordHeaderView *curSectionHeader = (YXSelectMyWordHeaderView *)[self.wordListTableView headerViewForSection:deleteIndexPath.section];
        [curSectionHeader updateInfo];
        YXSelectMyWordCell *cell = (YXSelectMyWordCell *)[self.wordListTableView cellForRowAtIndexPath:deleteIndexPath];
        [cell refreshContent];
    }
    
    self.miniView.selectedWords = self.selectedWords;
    [self updateMiniWordCell];
}

#pragma mark - <YXSelectMyWordCellDelegate>
-(void)selectMyWordCellManageBtnClicked:(YXSelectMyWordCell *)selectMyWordCell {
    NSIndexPath *indexPath = [self.wordListTableView indexPathForCell:selectMyWordCell];
    [self handleWordIndexPath:indexPath];
}

#pragma mark - <YXSwitchBookViewDelegate>
- (void)switchBookViewTouchedToHide:(YXSwitchBookView *)switxchBookView {
    self.titleView.selected = !self.titleView.selected;
}

- (void)switchBookViewSelectABook:(YXSwitchBookView *)switxchBookView {
    [self setTitleWith:self.currentSeletBookInfo.bookName];
    [self findCurrentShowBook];
    [self.wordListTableView setContentOffset:CGPointZero animated:YES];
}
#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchTF endEditing:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.currentShowBook.content.count == 1) {
        YXBookUnitContentModel *unitModel = self.currentShowBook.content.firstObject;
        unitModel.selected = YES;
    }
    return self.currentShowBook.content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YXBookUnitContentModel *unitModel = [self.currentShowBook.content objectAtIndex:section];
    return unitModel.isSelected ? unitModel.words.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSelectMyWordCell *cell = (YXSelectMyWordCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    YXBookUnitContentModel *unitModel = [self.currentShowBook.content objectAtIndex:indexPath.section];
    YXSelectWordCellModel *wordModel = [unitModel.words objectAtIndex:indexPath.row];
    if (!wordModel.occorDesc) {
        wordModel.occorDesc = [self wordOccorDesc:wordModel.wordId];
    }
    cell.wordModel = wordModel;
    
    cell.delegate = self;
//    cell.selectState = [self.selectedWords containsObject:wordModel];
    return cell;
}

- (NSString *)wordOccorDesc:(NSString *)wordId {
    NSInteger index = [self.wordlistUsedWordIds indexOfObject:wordId];
    
    NSString *occorDesc = @"";
    if (index != NSNotFound && self.wordlistUsedWordIds != nil) {
        YXWordListUsedWordModel *usedWordModel = [self.wordlistUsedWords objectAtIndex:index];
        occorDesc = [NSString stringWithFormat:@"在%@个词单中",usedWordModel.usedNum];
    }
    return occorDesc;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.currentShowBook.content.count == 1) {
        return CGFLOAT_MIN;
    }else {
        return AdaptSize(50);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    YXBookUnitContentModel *unitModel = [self.currentShowBook.content objectAtIndex:section];
    YXSelectMyWordHeaderView *header = (YXSelectMyWordHeaderView *)[super tableView:tableView viewForHeaderInSection:section];
    header.unitModel = unitModel;
    __weak UITableView *weakTable = tableView;
    CGPoint offset = tableView.contentOffset;
    header.headerViewTapedBlock = ^{
        [weakTable beginUpdates];
        [weakTable reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakTable endUpdates];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (unitModel.words.count && unitModel.selected) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
                [weakTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }else {
                [weakTable setContentOffset:offset animated:YES];
            }
        });
    
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((self.currentShowBook.content.count - 1) == section) {
        return CGFLOAT_MIN;
    }else {
        return AdaptSize(4);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {//最后一个footer高度为0
    YXMyBookFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kYXMyBookFooterViewID];
    return footer;
}

#pragma mark - handleTitle
- (void)setTitleWith:(NSString *)title {
    [self.titleView setTitle:title forState:UIControlStateNormal];
    CGFloat titleWidth = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19]}
                                             context:nil].size.width;
    CGFloat iconW = self.titleView.currentImage.size.width;
    CGFloat width = titleWidth + LeftTitleContentMargin + iconW;
    
    CGRect titleViewFrame = self.titleView.frame;
    if (width < 100) {
        width = 100;
    };
    
    //  不用定最大宽度，系统会自动调整
    titleViewFrame.size.width = width;
    titleViewFrame.size.height = 44;
    self.titleView.frame = titleViewFrame;
}
#pragma mark - subviews
- (YXLeftTitleButton *)titleView {
    if (!_titleView) {
        _titleView = [[YXLeftTitleButton alloc] init];
        _titleView.forbidHighLightState = YES;
        _titleView.titleImageMargin = LeftTitleContentMargin;
        [_titleView addTarget:self action:@selector(titleViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        _titleView.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        _titleView.backgroundColor = [UIColor clearColor];
        [_titleView setImage:[UIImage imageNamed:@"titleOpenIcon"] forState:UIControlStateNormal];
        [_titleView setImage:[UIImage imageNamed:@"titleCloseIcon"] forState:UIControlStateSelected];
    }
    return _titleView;
}

- (YXSpringAnimateButton *)saveBtn {
    if (!_saveBtn) {
        YXSpringAnimateButton *saveBtn = [[YXSpringAnimateButton alloc] init];
        saveBtn.enabled = NO;
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"bottomSaveIcon"] forState:UIControlStateNormal];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveWordList) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:saveBtn];
        _saveBtn = saveBtn;
    }
    return _saveBtn;
}

- (YXSelectedWordsMiniView *)miniView {
    if (!_miniView) {
        YXSelectedWordsMiniView *miniView = [[YXSelectedWordsMiniView alloc] init];
        miniView.delegate = self;
        [self.view addSubview:miniView];
        _miniView = miniView;
    }
    return _miniView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 32)];
        _searchTF.font = [UIFont systemFontOfSize:15];
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.placeholder = @"请输入要查询的单词或中文";
        _searchTF.delegate = self;
        _searchTF.layer.cornerRadius = 16;
        _searchTF.returnKeyType = UIReturnKeyDone;
//        _searchTF.enablesReturnKeyAutomatically = YES;
        _searchTF.inputAccessoryView = [[UIView alloc] init];
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_searchTF setValue:UIColorOfHex(0x849EC5) forKeyPath:@"_placeholderLabel.textColor"];
        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 1)];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.tintColor = UIColorOfHex(0x485461);
        _searchTF.backgroundColor = [UIColor whiteColor];
        [_searchTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTF;
}

- (void)textFieldChanged:(UITextField *)tf {
    if (tf.markedTextRange == nil) { //搜索条件
//        YXLog(@"--------%@",tf.textInputMode.primaryLanguage);
        [self searchWordsWith:tf];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!self.replaceClearIcon) {
        self.replaceClearIcon = YES;
        UIButton *cleanBtn = [textField valueForKey:@"_clearButton"];
        [cleanBtn setImage:[UIImage imageNamed:@"clearBtnIcon"] forState:UIControlStateNormal];
        [cleanBtn setImage:[UIImage imageNamed:@"clearBtnIcon"] forState:UIControlStateHighlighted];
    }
    [self searchWordsWith:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
//    [self searchWordsWith:textField];
    return YES;
}

- (void)searchWordsWith:(UITextField *)tf {
    NSString *language = tf.textInputMode.primaryLanguage;
    NSString *text = tf.text;
    if ([language isEqualToString:@"en-US"] || [language isEqualToString:@"zh-Hans"]) {
        if (text) {
//            [self refreshWithWordDetails:[NSMutableArray array]];
//        }else {
            YXWordQuaryFieldType type = ([language isEqualToString:@"en-US"]) ? YXWordQuaryFieldWord : YXWordQuaryFieldparaphrase;
            [YXWordModelManager quaryWordsWithType:type
                                  fuzzyQueryPrefix:text
                                     completeBlock:^(id obj, BOOL result)
             {
                 if (result) {
                     NSMutableArray *wordsModels = (NSMutableArray *)obj;
                     [self refreshWithWordDetails:wordsModels];
                     [self.blakView removeFromSuperview];
                 }else { // 没有搜索到
                     [self refreshWithWordDetails:[NSMutableArray array]];
                     [self showSearchBlankView];
                 }
             }];
        }
    }
}


- (void)refreshWithWordDetails:(NSMutableArray *)wordModels {
    
    if (self.wordIDs.count>0) {
        [self.wordIDs removeAllObjects];
    }
    
    YXBookUnitContentModel *searchUnitModel = self.currentSearchResultBook.searchUnitModel;
    searchUnitModel.words = [NSMutableArray array];
    
    YXBookCategoryModel *normalBookCategory = self.bookCategorys.firstObject;
//    if (normalBookCategory.content.count < 5) {
//        return;
//    }
    NSArray *normalBooks = [normalBookCategory.content subarrayWithRange:NSMakeRange(0, normalBookCategory.content.count-1)];
    
        for (YXWordDetailModel *wordDetail in wordModels) { // 只查询常规版本书籍（词单、趣词除外）
            NSString *wordId = wordDetail.wordid;
            for (YXBookContentModel *bookContentModel in normalBooks) {
                
                if (![self.wordIDs containsObject:wordDetail.wordid]) {
                    
                    if ([bookContentModel.bookWordIds containsObject:wordId]) {
                        YXSelectWordCellModel *selectWordCellModel = [bookContentModel quarySelectWordCellModelWith:wordId];
                        if (selectWordCellModel) {
                            
                            if (!selectWordCellModel.wordDetail) {
                                selectWordCellModel.wordDetail = wordDetail;
                            }
                            
                            //[searchUnitModel.words addObject:selectWordCellModel];
                            selectWordCellModel.isSearch = NO;
                            [self.currentSearchResultBook selectedResultBookAddWord:selectWordCellModel];
                            
                            [self.wordIDs addObject:wordId];
                            
                        }
                    }
                    
                }
                
//                if ([bookContentModel.bookWordIds containsObject:wordId]) {
//                    YXSelectWordCellModel *selectWordCellModel = [bookContentModel quarySelectWordCellModelWith:wordId];
//                    if (selectWordCellModel) {
//                        if (!selectWordCellModel.wordDetail) {
//                            selectWordCellModel.wordDetail = wordDetail;
//                        }
//
//    //                    [searchUnitModel.words addObject:selectWordCellModel];
//                        [self.currentSearchResultBook selectedResultBookAddWord:selectWordCellModel];
//                    }
//                }
            }
        }
    
    
//    for (YXWordDetailModel *wordDetail in wordModels) { // 查询所有的单词、不和书籍绑定
//
//        YXSelectWordCellModel *selectWordCellModel = [[YXSelectWordCellModel alloc]init];
//        if (!selectWordCellModel.wordDetail) {
//            selectWordCellModel.wordDetail = wordDetail;
//        }
//        [self.currentSearchResultBook selectedResultBookAddWord:selectWordCellModel];
//    }
    
    
    self.currentShowBook = self.currentSearchResultBook;
    [self handleCurrentShowBookAllWordsDetail];
}

- (void)showSearchBlankView {
    if (!_blakView) {
        UIView *blankView = [[UIView alloc] initWithFrame:self.view.bounds];
        blankView.backgroundColor = [UIColor whiteColor];
        UIImageView *blankIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBlankIcon"]];
        [blankView addSubview:blankIcon];
        [blankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(blankView);
            make.top.equalTo(blankView).offset(AdaptSize(80));
            make.size.mas_equalTo(MakeAdaptCGSize(203, 156));
        }];
        
        UILabel *tips = [[UILabel alloc] init];
        tips.text = @"未找到相关单词";
        tips.textColor = UIColorOfHex(0x485461);
        tips.font = [UIFont pfSCRegularFontWithSize:AdaptSize(16)];
        [blankView addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(blankIcon);
            make.top.equalTo(blankIcon.mas_bottom);
        }];
        
        [self.view addSubview:blankView];
        _blakView = blankView;
    }
}


- (void)showTVLoadingView {
    if (!_loadingAnimaterView) {
        YXLoadingView *loadingAnimaterView = [[YXLoadingView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x-AdaptSize(15),self.view.frame.origin.y - kNavHeight , self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.wordListTableView addSubview:loadingAnimaterView];
        _loadingAnimaterView = loadingAnimaterView;
    }
}

- (void)hideTVLoadingView {
    if (self.loadingAnimaterView) {
        [self.loadingAnimaterView removeFromSuperview];
    }
}

@end
