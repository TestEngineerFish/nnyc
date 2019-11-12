//
//  YXSearchVC.m
//  YXEDU
//
//  Created by jukai on 2019/4/12.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXSearchVC.h"
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
#import "YXWordDetailViewControllerOld.h"
#import "YXLoadingView.h"

static NSString *const kYXSelectMyWordCellID = @"YXSelectMyWordCellID";
static NSString *const kYXSelectMyWordHeaderViewID = @"YXSelectMyWordHeaderViewID";
static NSString *const kYXSearchresultBookID = @"YXSearchresultBookID";

@interface YXSearchVC ()<UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UITableView *wordListTableView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, weak) UIButton *rightBarItemBtn;
@property (nonatomic, strong) NSMutableArray *bookCategorys;
@property (nonatomic, copy) NSArray *bookIds;
@property (nonatomic, strong) YXBookContentModel *currentShowBook;
@property (nonatomic, strong) NSMutableArray *wordlistUsedWords;
@property (nonatomic, strong) NSMutableArray *wordlistUsedWordIds;
@property (nonatomic, strong) YXCurrentSeletBookInfo *currentSeletBookInfo;
@property (nonatomic, weak) YXSelectedWordsMiniView *miniView;
@property (nonatomic, strong) YXBookContentModel *currentSearchResultBook;
@property(nonatomic, weak) YXLoadingView *loadingAnimaterView;

@property (nonatomic, strong) NSMutableArray *wordIDs;

@property (nonatomic, weak) UIView *blakView;
@property (nonatomic, strong) __block NSThread *searchThead;
@end

@implementation YXSearchVC


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

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor hexStringToColor:@"FFFFFF"];
//    UIImageView *navView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"com_top_nav_ipx"]];
    [navView setFrame:CGRectMake(0, 0, SCREEN_WIDTH,kNavHeight + 10)];
    [self.view addSubview:navView];
    
    [self bgView];
    [self wordListTableView];
    [self searchTF];
    [self rightBarItemBtn];
    [self.wordListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AdaptSize(kNavHeight+15));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.wordListTableView);
    }];
    
    [self handleUsedWords];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        _bgView = bgView;
    }
    return _bgView;
}


- (UITableView *)wordListTableView {
    if (!_wordListTableView) {
        UITableView *wordListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [wordListTableView registerClass:[YXSelectMyWordCell class]
                  forCellReuseIdentifier:@"YXSelectMyWordCell"];
        wordListTableView.delegate = self;
        wordListTableView.dataSource = self;
        wordListTableView.backgroundColor = [UIColor whiteColor];//UIColorOfHex(0xF3F8FB);
        wordListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        wordListTableView.rowHeight = AdaptSize(49);
        wordListTableView.sectionHeaderHeight = AdaptSize(50);
        
        //        wordListTableView.layer.cornerRadius = AdaptSize(8);
        wordListTableView.showsVerticalScrollIndicator = NO;
        //        wordListTableView.contentInset = UIEdgeInsetsMake(0, 0, AdaptSize(8), 0);
        [self.view addSubview:wordListTableView];
        _wordListTableView = wordListTableView;
    }
    return _wordListTableView;
}

- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(15, kStatusBarHeight+10, kSCREEN_WIDTH-30-50, 32)];
        _searchTF.font = [UIFont systemFontOfSize:15];
        _searchTF.placeholder = @"请输入要查询的单词或中文";
        _searchTF.delegate = self;
        _searchTF.layer.cornerRadius = 16;
        _searchTF.returnKeyType = UIReturnKeyDone;
        _searchTF.inputAccessoryView = [[UIView alloc] init];
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
//        [_searchTF setValue:UIColorOfHex(0x434a5d) forKeyPath:@"_placeholderLabel.textColor"];
        _searchTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 1)];
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
//        _searchTF.tintColor = UIColorOfHex(0x434a5d);
        _searchTF.backgroundColor = [UIColor hexStringToColor:@"F4F4F4"];
        [_searchTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:_searchTF];
        
    }
    return _searchTF;
}

- (UIButton *)rightBarItemBtn {
    if (!_rightBarItemBtn) {
        UIButton *rightBarItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH-60, kStatusBarHeight+5, 44, 44)];
//        [rightBarItemBtn setImage:[[UIImage alloc] init] forState:UIControlStateSelected];
        [rightBarItemBtn setTitle:@"取消" forState:UIControlStateNormal];
        [rightBarItemBtn setTintColor:[UIColor hexStringToColor:@"000000"]];
        [rightBarItemBtn setTitleColor:[UIColor hexStringToColor:@"000000"] forState:UIControlStateNormal];
//        rightBarItemBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBarItemBtn addTarget:self
                            action:@selector(rightBarItemClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rightBarItemBtn];
        _rightBarItemBtn = rightBarItemBtn;
    }
    return _rightBarItemBtn;
}

- (void)rightBarItemClick:(UIButton *)btn {
    NSLog(@"rightBarItemClick");
    [self.searchTF resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textFieldChanged:(UITextField *)tf {
    if (tf.markedTextRange == nil) { //搜索条件
        [self searchWordsWith:tf];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self searchWordsWith:textField];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)searchWordsWith:(UITextField *)tf {
    NSString *language = tf.textInputMode.primaryLanguage;
    NSString *text = tf.text;
    if ([language isEqualToString:@"en-US"] || [language isEqualToString:@"zh-Hans"]) {
        if (text) {
            YXWordQuaryFieldType type = ([language isEqualToString:@"en-US"]) ? YXWordQuaryFieldWord : YXWordQuaryFieldparaphrase;
            __weak typeof(self) weakSelf = self;
            [YXWordModelManager quaryWordsWithType:type
                                  fuzzyQueryPrefix:text
                                     completeBlock:^(id obj, BOOL result)
             {
                 if (!weakSelf) {
                     return;
                 }
                 if (result) {
                     if (weakSelf.searchThead) {
                         [weakSelf.searchThead cancel];
                         NSLog(@"clear clear clear clear clear");
                     }
                     NSMutableArray *wordsModels = (NSMutableArray *)obj;
                     if (@available(iOS 10.0, *)) {
                         weakSelf.searchThead = [[NSThread alloc] initWithBlock:^{
                             [weakSelf refreshWithWordDetails:wordsModels];
                         }];
                         [weakSelf.searchThead start];
                     } else {
                         [weakSelf refreshWithWordDetails:wordsModels];
                     }
                     [weakSelf.blakView removeFromSuperview];
                 }else { // 没有搜索到
                     [weakSelf refreshWithWordDetails:[NSMutableArray array]];
                     [weakSelf showSearchBlankView];
                 }
             }];
        }
    }
}

///** 根据词书ID获取本词书下哪些单词已经被选为词单 */
- (void)handleUsedWords {
    [self showTVLoadingView];
    __weak typeof(self) weakSelf = self;
    [YXDataProcessCenter GET:DOMAIN_WORDLISTGETUSEDWORD
                  parameters:@{}
                finshedBlock:^(YRHttpResponse *response, BOOL result) {
                    if (result) {
                        //                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSArray *infos = [response.responseObject objectForKey:@"usedWords"];
                        weakSelf.wordlistUsedWords = [YXWordListUsedWordModel mj_objectArrayWithKeyValuesArray:infos];
                        weakSelf.wordlistUsedWordIds = [self.wordlistUsedWords valueForKeyPath:@"wordId"];
                        [weakSelf handleBookWordsData];
                        //                        });
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf hideNoNetWorkView];
                        });
                        
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
                        //  后台执行：
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            // something
                            NSArray *bookWordDics = [response.responseObject objectForKey:@"bookWords"];
                            self.bookCategorys = [YXBookCategoryModel mj_objectArrayWithKeyValuesArray:bookWordDics];
                            [self updatecurrentSeletBookInfo];
                            [self findCurrentShowBook];
                        });
                    }
                }];
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
    // 主线程执行
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.rightBarItemBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.searchTF becomeFirstResponder];
    });
}

- (void)refreshWithWordDetails:(NSMutableArray *)wordModels {
    __weak typeof(self) weakSelf = self;
    //  后台执行：
    if (weakSelf.wordIDs.count>0) {
        [weakSelf.wordIDs removeAllObjects];
    }
    // something
    YXBookUnitContentModel *searchUnitModel = weakSelf.currentSearchResultBook.searchUnitModel;
    searchUnitModel.words = [NSMutableArray array];
    YXBookCategoryModel *normalBookCategory = weakSelf.bookCategorys.firstObject;
    NSArray *normalBooks = [normalBookCategory.content subarrayWithRange:NSMakeRange(0, normalBookCategory.content.count-1)].copy;
    for (YXWordDetailModel *wordDetail in wordModels) { // 只查询常规版本书籍（词单、趣词除外）
        NSString *wordId = wordDetail.wordid;
        if ([NSThread currentThread].isCancelled) {
            return;
        }
        for (YXBookContentModel *bookContentModel in normalBooks) {
            if ([NSThread currentThread].isCancelled) {
                return;
            }
            if ([weakSelf.wordIDs containsObject:wordId]) {
                continue;
            }

            if ([bookContentModel.bookWordIds containsObject:wordId]) {
                YXSelectWordCellModel *selectWordCellModel = [bookContentModel quarySelectWordCellModelWith:wordId];
                if (selectWordCellModel) {

                    if (!selectWordCellModel.wordDetail) {
                        selectWordCellModel.wordDetail = wordDetail;
                    }

                    //[searchUnitModel.words addObject:selectWordCellModel];
                    selectWordCellModel.isSearch = YES;
                    [weakSelf.currentSearchResultBook selectedResultBookAddWord:selectWordCellModel];

                    [weakSelf.wordIDs addObject:wordId];
                }
            }
        }
    }
    
    self.currentShowBook = self.currentSearchResultBook;
    [self handleCurrentShowBookAllWordsDetail];
}

- (void)handleCurrentShowBookAllWordsDetail {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
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
            }
            self.currentShowBook.hasQuaryWordInfo = YES;
        }
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideTVLoadingView];
            [self.wordListTableView reloadData];
        });
    });
    
}

- (void)showTVLoadingView {
    if (!_loadingAnimaterView) {
        YXLoadingView *loadingAnimaterView = [[YXLoadingView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - kNavHeight , self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.wordListTableView addSubview:loadingAnimaterView];
        _loadingAnimaterView = loadingAnimaterView;
    }
}

- (void)hideTVLoadingView {
    if (self.loadingAnimaterView) {
        [self.loadingAnimaterView removeFromSuperview];
    }
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
    if (unitModel.isSelected) {
        return unitModel.words.count > 10 ? 10 : unitModel.words.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >= self.currentShowBook.content.count) {
        return [[UITableViewCell alloc] init];
    }
    YXSelectMyWordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSelectMyWordCell"];
    YXBookUnitContentModel *unitModel = [self.currentShowBook.content objectAtIndex:indexPath.section];
    if (indexPath.row >= unitModel.words.count) {
        return [[UITableViewCell alloc] init];
    }
    YXSelectWordCellModel *wordModel = [unitModel.words objectAtIndex:indexPath.row];
    cell.wordModel = wordModel;
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.currentShowBook.content.count == 1) {
//        return CGFLOAT_MIN;
//    }else {
//        return AdaptSize(50);
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMyWordBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YXMyWordCellBaseModel *wordModel = cell.wordModel;
    YXWordDetailViewControllerOld *detailVC = [YXWordDetailViewControllerOld wordDetailWith:wordModel.wordDetail bookId:wordModel.bookId];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)showSearchBlankView {
    if (!_blakView) {
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight + 10 +15, SCREEN_WIDTH, SCREEN_HEIGHT-kNavHeight-25)];
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

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)dealloc {
    
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
