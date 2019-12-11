//
//  YXCareerWordListViewController.m
//  YXEDU
//
//  Created by yixue on 2019/2/20.
//  Copyright © 2019 shiji. All rights reserved.
//

#import "YXCareerWordListViewController.h"
#import "YXCareerCommentButton.h"
#import "YXCareerSortButton.h"
#import "YXCareerSortView.h"
#import "YXCareerNoteWordListModel.h"
#import "YXCareerNoteWordListCell.h"
#import "YXCareerNoteWordInfoModel.h"
#import "YXCareerWordInfo.h"
#import "YXWordDetailViewControllerOld.h"
#import "YXDeleteAnimateView.h"
#import "YXExerciseVC.h"
static NSString *const kYXCareerNoteWordListCellID = @"kYXCareerNoteWordListCellID";

@interface YXCareerWordListViewController () <YXCareerSortViewDelegate,UITableViewDelegate,UITableViewDataSource,YXCareerNoteWordListCellDelegate>

@property (nonatomic, weak) UILabel *numberOfWordsLbl;
@property (nonatomic, weak) YXCareerCommentButton *commentBtn;
@property (nonatomic, weak) YXCareerSortButton *sortBtn;
@property (nonatomic, weak) YXCareerSortView *sortView;
@property (nonatomic, assign) CGFloat sortViewWidth;

@property (nonatomic, weak) UITableView *wordTableView;

@property (nonatomic, weak) YXSpringAnimateButton *randomInspectionBtn;

@property (nonatomic, strong) NSMutableArray *noteWordListModelAry;

@end

@implementation YXCareerWordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorOfHex(0xF3F8FB);
    
    [self wordTableView];
    
    [self numberOfWordsLbl];
    [self commentBtn];
    [self sortBtn];
    [self sortView];
//    if (self.wordListViewType == kYXWordListError && _careerModel.bookId != 0) {
//        [self randomInspectionBtn];
//    }
    if (self.wordListViewType == kYXWordListError) {
        [self randomInspectionBtn];
    }
    [self makeConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self handleDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self checkPasteboard];
}

- (void)handleDataSource {
    //根据当前Modelz请求
    NSDictionary *param = @{@"item"   : _careerModel.item,
                            @"bookId" : @(_careerModel.bookId),
                            @"sort"   : @(_careerModel.sort)};
    __weak typeof (self) weakself = self;
    [YXDataProcessCenter GET:DOMAIN_NOTELISTWORDS parameters:param finshedBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) {
            if (response.responseObject) {
                NSArray *wordList = [response.responseObject objectForKey:@"wordList"];
                _noteWordListModelAry = [[NSMutableArray alloc] init];
                for (NSInteger i = 0; i < wordList.count; i++) {
                    YXCareerNoteWordListModel *model = [YXCareerNoteWordListModel mj_objectWithKeyValues:wordList[i]];
                    [_noteWordListModelAry addObject:model];
                }
                [_wordTableView reloadData];
                //更新单词Lbl
                NSInteger i = 0;
                for (YXCareerNoteWordListModel *model in _noteWordListModelAry) {
                    NSArray *wordIds = model.wordIds;
                    i = i + wordIds.count; }
                _numberOfWordsLbl.text = [NSString stringWithFormat:@"单词：%zd",i];
            }
            [weakself hideNoNetWorkView];
        } else {
            //请求失败
            if (response.error.type == kBADREQUEST_TYPE) {
                [weakself showNoNetWorkView:^{
                    [weakself handleDataSource];
                }];
            }
        }
    }];
}

#pragma mark - Get/Set
- (void)setCareerModel:(YXCareerModel *)careerModel {
    _careerModel = careerModel;
    if ([_careerModel.item  isEqual: @"new"]) {_sortViewWidth = 72;} else {_sortViewWidth = 142;}
    _sortBtn.careerModel = _careerModel;
    _sortView.careerModel = _careerModel;
}

#pragma mark - Constraint
- (void)makeConstraints {
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(12);
        make.size.mas_equalTo(CGSizeMake(85, 25));
    }];
    [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentBtn.mas_left).offset(-15);
        make.top.equalTo(self.view).offset(12);
        make.size.mas_equalTo(CGSizeMake(85, 25));
    }];
    [_sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_sortViewWidth, 0));
        make.centerX.equalTo(_sortBtn);
        make.top.equalTo(_sortBtn.mas_bottom).offset(5);
    }];
}

#pragma mark - SubViews
- (UITableView *)wordTableView {
    if (!_wordTableView) {
        CGRect rect = CGRectZero;
        if (self.wordListViewType == kYXWordListError) {
            rect = CGRectMake(15, 50, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 30 - kNavHeight - 65 - kSafeBottomMargin - 65);
        } else {
            rect = CGRectMake(15, 50, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 30 - kNavHeight - 65 - kSafeBottomMargin);
        }
        UITableView *wordTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        wordTableView.delegate = self;
        wordTableView.dataSource = self;
        [wordTableView registerClass:[YXCareerNoteWordListCell class] forCellReuseIdentifier:kYXCareerNoteWordListCellID];
        wordTableView.backgroundColor = UIColorOfHex(0xEAF4FC);
        wordTableView.layer.cornerRadius = 5;
        wordTableView.bounces = NO;
        wordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *shadowBg = [[UIView alloc] initWithFrame:rect];
        shadowBg.backgroundColor = UIColorOfHex(0xAED7E3);
        shadowBg.layer.cornerRadius = 5;
        shadowBg.layer.shadowColor = UIColorOfHex(0xAED7E3).CGColor;
        shadowBg.layer.shadowOffset = CGSizeMake(0, 0);
        shadowBg.layer.shadowRadius = 3;
        shadowBg.layer.shadowOpacity = 1;
        
        [self.view addSubview:shadowBg];
        [self.view addSubview:wordTableView];
        _wordTableView = wordTableView;
    }
    return _wordTableView;
}

- (YXSpringAnimateButton *)randomInspectionBtn {
    if (!_randomInspectionBtn) {
        YXSpringAnimateButton *randomInspectionBtn = [[YXSpringAnimateButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100, SCREEN_HEIGHT - kNavHeight - 30 - kSafeBottomMargin - 50 - 15, 200, 50)];
        randomInspectionBtn.layer.cornerRadius = 20;
        [randomInspectionBtn setForbidHighLightState:YES];
        [randomInspectionBtn setTitle:@"抽查复习" forState:UIControlStateNormal];
        randomInspectionBtn.titleLabel.font = [UIFont pfSCRegularFontWithSize:18];
        randomInspectionBtn.titleLabel.textColor = [UIColor whiteColor];
        [randomInspectionBtn setBackgroundImage:[UIImage imageNamed:@"randomInsection"] forState:UIControlStateNormal];
        [randomInspectionBtn.button setTitleEdgeInsets:UIEdgeInsetsMake(-2, 0, 2, 0)];
        [self.view addSubview:randomInspectionBtn];
        [randomInspectionBtn addTarget:self action:@selector(inspectionClicked:) forControlEvents:UIControlEventTouchUpInside];
        _randomInspectionBtn = randomInspectionBtn;
    }
    return _randomInspectionBtn;
}

- (void)pickReviewAction {
    YXExerciseVC *exeriseVC = [YXExerciseVC exerciseVCWithType:YXExercisePickError learningBookId:nil];
    exeriseVC.learningBookId = [NSString stringWithFormat:@"%zd",self.careerModel.bookId];
    [self.navigationController pushViewController:exeriseVC animated:YES];
}

- (UILabel *)numberOfWordsLbl {
    if (!_numberOfWordsLbl) {
        UILabel *numberOfWordsLbl = [[UILabel alloc] initWithFrame:CGRectMake(19, 19, 200, 15)];
        numberOfWordsLbl.textColor = UIColorOfHex(0x849EC5);
        numberOfWordsLbl.font = [UIFont pfSCRegularFontWithSize:14];
        numberOfWordsLbl.text = @"单词：";
        [self.view addSubview:numberOfWordsLbl];
        _numberOfWordsLbl = numberOfWordsLbl;
    }
    return _numberOfWordsLbl;
}

- (YXCareerCommentButton *)commentBtn {
    if (!_commentBtn) {
        YXCareerCommentButton *commentBtn = [[YXCareerCommentButton alloc] init];
        commentBtn.isSelected = NO;
        [self.view addSubview:commentBtn];
        [commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _commentBtn = commentBtn;
    }
    return _commentBtn;
}

- (YXCareerSortButton *)sortBtn {
    if (!_sortBtn) {
        YXCareerSortButton *sortBtn = [[YXCareerSortButton alloc] init];
        sortBtn.isSelected = NO;
        sortBtn.careerModel = _careerModel;
        [self.view addSubview:sortBtn];
        [sortBtn addTarget:self action:@selector(sortBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _sortBtn = sortBtn;
    }
    return _sortBtn;
}

- (YXCareerSortView *)sortView {
    if (!_sortView) {
        YXCareerSortView *sortView = [[YXCareerSortView alloc] init];
        sortView.delegate = self;
        sortView.clipsToBounds = YES;
        sortView.careerModel = _careerModel;
        [self.view addSubview:sortView];
        _sortView = sortView;
    }
    return _sortView;
}

- (void)showSortView {
    [_sortView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(_sortViewWidth, 110));
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

- (void)hideSortView {
    if (_sortView != nil) {
        [_sortView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(_sortViewWidth, 0));
        }];
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - Targets
- (void)commentBtnClicked:(YXCareerCommentButton *)sender {
    _commentBtn.isSelected = !_commentBtn.isSelected;
    _sortBtn.isSelected = NO;
    
    [self hideSortView];
    //遮住or显示注释
    [self.wordTableView reloadData];
}

- (void)sortBtnClicked:(YXCareerSortButton *)sender {
    _sortBtn.isSelected = !_sortBtn.isSelected;
    _commentBtn.isSelected = NO;
    
    if (_sortBtn.isSelected) {
        [self showSortView];
    } else {
        [self hideSortView];
    }
}

- (void)inspectionClicked:(YXSpringAnimateButton *)sender {
    
    if (_careerModel.bookId == 0){
        YXExerciseVC *exerciseVC = [YXExerciseVC exerciseVCWithType:YXExercisePickError learningBookId:@""];
        exerciseVC.disperseCloudView.type = YXExercisePickError;
        [self.navigationController pushViewController:exerciseVC animated:YES];
        return ;
    }
    
    YXExerciseVC *exerciseVC = [YXExerciseVC exerciseVCWithType:YXExercisePickError learningBookId: [NSString stringWithFormat:@"%zd", _careerModel.bookId] ];
    exerciseVC.disperseCloudView.type = YXExercisePickError;
    [self.navigationController pushViewController:exerciseVC animated:YES];
}

#pragma mark - YXCareerSortViewDelegate
-(void)careerSortViewDidChangeSort:(YXCareerSortView *)careerSortView sortIndex:(NSInteger)index {
    self.careerModel = [[YXCareerModel alloc] initWithItem:_sortView.careerModel.item
                                                    bookId:_sortView.careerModel.bookId
                                                      sort:index];
    [self sortBtnClicked:[YXCareerSortButton alloc]];
    //刷新单词列表
    [self handleDataSource];
}

#pragma mark - YXCareerNoteWordListCellDelegate
- (void)cellDidFinishedDeleteAnimation:(YXCareerNoteWordListCell *)noteWordListCell {
    //[_wordTableView deleteRowsAtIndexPaths:@[[_wordTableView indexPathForCell:noteWordListCell]] withRowAnimation:0];
    [self handleDataSource];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_noteWordListModelAry) {
        if (_noteWordListModelAry.count) {
            if (self.wordListViewType == kYXWordListNotStudied) {
                YXCareerNoteWordListModel *model = _noteWordListModelAry[0];
                if (model.wordIds.count == 0) {
                    [self showNoDataView];
                } else {
                    [self hideNoDataView];
                }
            } else {
                [self hideNoDataView];
            }
        } else {
            [self showNoDataView];
        }
    }
    return _noteWordListModelAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YXCareerNoteWordListModel *model = _noteWordListModelAry[section];
    return model.wordIds.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 50; }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section { return 42; }

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section { return 5; }

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section { return [[UIView alloc] init];}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _wordTableView.width, 42)];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *headerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 100, 14)];
    headerTitleLbl.textColor = UIColorOfHex(0x849EC5);
    headerTitleLbl.font = [UIFont pfSCRegularFontWithSize:13];
    [headerView addSubview:headerTitleLbl];
    
    YXCareerNoteWordListModel *model = _noteWordListModelAry[section];
    headerTitleLbl.text = model.date;
    if ([headerTitleLbl.text  isEqual: @"id"]) {
        headerTitleLbl.text = @"单词";
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCareerNoteWordListModel *model = _noteWordListModelAry[indexPath.section];
    NSArray *wordIds = model.wordIds;
    YXCareerNoteWordInfoModel *cellInfoModel = [YXCareerNoteWordInfoModel mj_objectWithKeyValues:wordIds[indexPath.row]];
    
    YXCareerNoteWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXCareerNoteWordListCellID];
    cell.delegate = self;
    if (_commentBtn.isSelected) {
        cell.isDetailHidden = YES;
    } else {
        cell.isDetailHidden = NO;
    }
    cell.wordInfoModel = cellInfoModel;
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        YXCareerWordGroupModel *wordGroupModel = wordGroupCell.wordGroupModel;
////        YXCareerWordInfo *cancleFavWordInfo = [wordGroupModel.groupWords objectAtIndex:wordIndexPath.section];
//        YXCareerNoteWordListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//        YXDeleteAnimateView *deleteView = [[YXDeleteAnimateView alloc] init];
//        deleteView.frame = self.view.bounds;
//        [self.view addSubview:deleteView];
//
//        YXCareerNoteWordListModel *model = _noteWordListModelAry[indexPath.section];
//        NSMutableArray *wordIds = model.wordIds;
//        YXCareerNoteWordInfoModel *cellInfoModel = [YXCareerNoteWordInfoModel mj_objectWithKeyValues:wordIds[indexPath.row]];
//
//        [YXWordModelManager keepWordId:cellInfoModel.word_id bookId:cellInfoModel.book_id isFav:NO completeBlock:^(YRHttpResponse *response, BOOL result) {
//            if (result) { //取消成功
//                [wordIds removeObject:wordIds[indexPath.row]];
//                [cell doAnimationAt:indexPath withDeleteAnimateView:deleteView withTableView:tableView];
//            }else {
//                [deleteView removeFromSuperview];
//            }
//        }];
//    }
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_wordListViewType == kYXWordListCollection) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCareerNoteWordListModel *model = _noteWordListModelAry[indexPath.section];
    NSArray *wordIds = model.wordIds;
    YXCareerNoteWordInfoModel *cellInfoModel = [YXCareerNoteWordInfoModel mj_objectWithKeyValues:wordIds[indexPath.row]];
    
//     *wdvc = [[YXWordDetailViewControllerNew alloc] init];
//    wdvc.wordId =YXWordDetailViewControllerNew cellInfoModel.word_id;
//   
//    [self.navigationController pushViewController:wdvc animated:YES];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    if (@available(iOS 11.0, *)) {
        UIContextualAction *deleteAction =
        [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                title:@"取消收藏"
                                              handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                             {
                                                 [self didRowClickedNotFav:tableView forRowAtIndexPath:indexPath];
                                             }];
        deleteAction.backgroundColor = UIColorOfHex(0xFC7D8B);
        UISwipeActionsConfiguration *actions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        actions.performsFirstActionWithFullSwipe = NO;
        
        return actions;
    }
    return nil;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteRowAction =
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                           title:@"取消收藏"
                                         handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath)
                                        {
                                            [self didRowClickedNotFav:tableView forRowAtIndexPath:indexPath];
                                        }];
    deleteRowAction.backgroundColor = UIColorOfHex(0xFC7D8B);
    return @[deleteRowAction];
}

- (void)didRowClickedNotFav:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath {
    YXCareerNoteWordListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    YXDeleteAnimateView *deleteView = [[YXDeleteAnimateView alloc] init];
    deleteView.frame = self.view.bounds;
    [self.view addSubview:deleteView];
    
    YXCareerNoteWordListModel *model = _noteWordListModelAry[indexPath.section];
    NSMutableArray *wordIds = model.wordIds;
    YXCareerNoteWordInfoModel *cellInfoModel = [YXCareerNoteWordInfoModel mj_objectWithKeyValues:wordIds[indexPath.row]];
    
    [YXWordModelManager keepWordId:cellInfoModel.word_id bookId:cellInfoModel.book_id isFav:NO completeBlock:^(YRHttpResponse *response, BOOL result) {
        if (result) { //取消成功
            [wordIds removeObject:wordIds[indexPath.row]];
            [cell doAnimationAt:indexPath withDeleteAnimateView:deleteView withTableView:tableView];
        }else {
            [deleteView removeFromSuperview];
        }
    }];
}

@end
